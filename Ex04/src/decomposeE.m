% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% Yu will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1s, x2s)

    [U,S,V] = svd(E);

    W = [0 -1 0; 1 0 0; 0 0 1];
    R1 = U * W * V';
    if det(R1) < 0
        R1 = -R1;
    end
    R2 = U * W' * V';
    if det(R2) < 0
        R2 = -R2;
    end
    t = U(:,end);
    t = t/norm(t);
    P1 = horzcat(R1, t);
    P2 = horzcat(R1, -t);
    P3 = horzcat(R2, t);
    P4 = horzcat(R2, -t);
    Ps = {P1, P2, P3, P4};

    for i = 1:4
        [XS, err] = linearTriangulation([eye(3), zeros(3,1)], x1s, Ps{i}, x2s);
        PXS = Ps{i}*XS;
        if all(XS(3,:) >= 0) %&& all(PXS(3,:) >= 0)
            disp(['It is P', num2str(i)])
            P = Ps{i};
        end
    end

    P1 = [R1 * horzcat(eye(3), t);0 0 0 1];
    P2 = [R1 * horzcat(eye(3), -t);0 0 0 1];
    P3 = [R2 * horzcat(eye(3), t);0 0 0 1];
    P4 = [R2 * horzcat(eye(3), -t);0 0 0 1];
    Ps = {P1, P2, P3, P4};
    showCameras(Ps, 7)
end