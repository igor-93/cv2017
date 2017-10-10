function [K, R, t, error] = runGoldStandard(xy, XYZ, IMG_NAME)

normalize = 1;
if normalize
    disp("Run with NORMALIZED data.")
    %normalize data points
    [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);
    xy = vertcat(xy, ones(1, size(xy,2)));
    XYZ = vertcat(XYZ, ones(1, size(XYZ,2)));

    %compute DLT
    [Pn, A_normalized] = dlt(xy_normalized, XYZ_normalized);

    %minimize geometric error
    pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
    for i=1:20
        [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
    end

    %denormalize camera matrix
    P_min = [pn(1:4);pn(5:8);pn(9:12)];
    P = inv(T) * P_min * U;
else
    disp("Run with ORIGINAL data.")
    xy = vertcat(xy, ones(1, size(xy,2)));
    XYZ = vertcat(XYZ, ones(1, size(XYZ,2)));

    %compute DLT
    [P, A] = dlt(xy, XYZ);

    %minimize geometric error
    p = [P(1,:) P(2,:) P(3,:)];
    for i=1:20
        [p] = fminsearch(@fminGoldStandard, p, [], xy, XYZ, i/5);
    end

end


    
%factorize camera matrix in to K, R and t
[ K, R, t ] = decompose(P);

%compute reprojection error
n = size(XYZ, 2);
errs = zeros(n,1);
reprjs = zeros(2,n);
for i = 1:n
    repr = P*XYZ(:,i);
    repr = repr ./ repr(end);
    reprjs(:,i) = repr(1:2);
    errs(i) = norm(repr - xy(:,i));
end
error = mean(errs)

plot_reprojection(IMG_NAME, reprjs, 2);
end