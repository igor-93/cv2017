% Compute the essential matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1s, x2s)

    [x1s, T1] = normalise2dpts(x1s);
    [x2s, T2] = normalise2dpts(x2s);
    
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
    es = V(:,end);
    En = [es(1:3)'; es(4:6)'; es(7:9)'];
    
    % impose the singularity constraint
    [U,S,V] = svd(En);
    m = (S(1,1)+S(2,2)) / 2;
    S(1,1) = m;
    S(2,2) = m;
    S(3,3) = 0;
    Ehn = U * S * V';
    
    %E = T1' * En * T2
    %Eh = T1' * Ehn * T2
    E = T2' * En * T1;
    Eh = T2' * Ehn * T1;
end
