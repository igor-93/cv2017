function [K, R, t, error] = runDLT(xy, XYZ, IMG_NAME)

normalize = 1;
if normalize
    disp("Run with NORMALIZED data.")
    %normalize data points
    [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);
    xy = vertcat(xy, ones(1, size(xy,2)));
    XYZ = vertcat(XYZ, ones(1, size(XYZ,2)));
    
    %compute DLT
    [P_normalized, A_normalized] = dlt(xy_normalized, XYZ_normalized);

    %denormalize camera matrix
    P = inv(T) * P_normalized * U;
else
    disp("Run with ORIGINAL data.")
    xy = vertcat(xy, ones(1, size(xy,2)));
    XYZ = vertcat(XYZ, ones(1, size(XYZ,2)));
    
    %compute DLT
    [P, A] = dlt(xy, XYZ);
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

plot_reprojection(IMG_NAME, reprjs, 1);
end