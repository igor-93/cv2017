function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
    n = size(xy, 2);
    A = zeros(2*n, 12);
    for i = 1:n
        xi = xy(1,i);
        yi = xy(2,i);
        wi = xy(3,i);
        Xi = XYZ(:, i).T;
        tmp = [wi*Xi zeros(4,1) -xi*Xi; zeros(4,1) -wiXi yi*Xi];
        A(i:i+1,:) = tmp;
    end
    
    rhs = zeros(12, 1);
    
    [U,S,V] = svd(A,0);
    ps = V*((U'*rhs)./diag(S));
    P = [ps(1:4); ps(5:8); ps(9:12)];
end