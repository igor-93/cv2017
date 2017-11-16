% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s, normalize)
    % normalize the data: mean = 0, avg. dist. = sqrt(2)
    % normalize = true;
    if normalize
        [nxs1, T1] = normalizePoints2d(x1s);
        [nxs2, T2] = normalizePoints2d(x2s);
    else
        nxs1 = x1s;
        nxs2 = x2s;
        T1 = eye(3);
        T2 = eye(3);
    end
    
    
    % A * fs = 0 must hold,
    n_points = size(x1s, 2);
    A = zeros(n_points, 9);
    for i=1:n_points
        x = nxs1(1, i); 
        y = nxs1(2, i); 
        x_ = nxs2(1, i);
        y_ = nxs2(2, i);
        A(i,:) = [ x_*x x_*y x_ y_*x y_*y y_ x y 1.0 ];
    end
    
    [~,~,V] = svd(A);
    fs = V(:,end);
    Fn = [fs(1:3)'; fs(4:6)'; fs(7:9)'];
    
    % impose the singularity constraint
    [U,S,V] = svd(Fn);
    S(3,3) = 0;
    Fhn = U*S*V';
    
    % transform F and Fh back to original units
    F = T2' * Fn * T1;
    
    %Fh = T1' * Fhn * T2;
    Fh = T2' * Fhn * T1;
end
