% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatirx(x1s, x2s)
    % normalize the data: mean = 0, avg. dist. = sqrt(2)
    mean1 = mean(x1s,2);
    mean2 = mean(x2s,2);
    x1s = x1s(1:2,:) - mean1(1:2,:);
    x2s = x2s(1:2,:) - mean2(1:2,:);
    x1s_scale = sqrt(2) ./ mean(sqrt(sum(x1s.^2, 1)));
    x2s_scale = sqrt(2) ./ mean(sqrt(sum(x2s.^2, 1)));
    x1s = x1s * x1s_scale;
    x2s = x2s * x2s_scale;
    x1s = vertcat(x1s, ones(1, size(x1s,2)));
    x2s = vertcat(x2s, ones(1, size(x2s,2)));
    

    % A * fs = 0 must hold,
    n_points = size(x1s, 2);
    A = zeros(n_points, 9);
    for i=1:n_points
        x = x1s(1, i); 
        y = x1s(2, i); 
        x_ = x2s(1, i);
        y_ = x2s(2, i);
        A(i,:) = [ x_*x x_*y x_ y_*x y_*y y_ x y 1.0 ];
    end
    
    [~,~,V] = svd(A);
    fs = V(:,end);
    F = [fs(1:3)'; fs(4:6)'; fs(7:9)']
    
    % impose the singularity constraint
    [U,S,V] = svd(F);
    S(3,3) = 0;
    Fh = U*S*V.'
end