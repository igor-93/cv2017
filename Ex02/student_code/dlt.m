function [P, A] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
    n = size(xy, 2);
    A = zeros(2*n, 12);
    for i = 1:n
        xi = xy(1,i);
        yi = xy(2,i);
        wi = xy(3,i);
        Xi = XYZ(:, i)';
        tmp = [wi*Xi zeros(1,4) -xi*Xi; zeros(1,4) -wi*Xi yi*Xi];
        A(2*i-1:2*i,:) = tmp;
    end
    
    [~,~,V] = svd(A);
    ps = V(:,end);
    P = [ps(1:4)'; ps(5:8)'; ps(9:12)'];
end