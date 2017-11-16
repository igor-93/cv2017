function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
%first compute centroid
xy_centroid = mean(xy,2);
XYZ_centroid = mean(XYZ, 2);

%then, compute scale
xy_centered = xy - xy_centroid;
XYZ_centered = XYZ - XYZ_centroid;

xy_scale = sqrt(2) ./ mean(sqrt(sum(xy_centered.^2, 1)));
XYZ_scale = sqrt(3) ./ mean(sqrt(sum(XYZ_centered.^2, 1)));


%create T and U transformation matrices
T = [1.0/xy_scale 0 xy_centroid(1); 0 1.0/xy_scale xy_centroid(2); 0 0 1];
U = [1.0/XYZ_scale 0 0 XYZ_centroid(1); 0 1.0/XYZ_scale 0 XYZ_centroid(2); 0 0 1.0/XYZ_scale XYZ_centroid(3); 0 0 0 1];

T = inv(T);
U = inv(U);

%and normalize the points according to the transformations
xyh = vertcat(xy, ones(1, size(xy,2)));
XYZh = vertcat(XYZ, ones(1, size(XYZ,2)));
xyn = T * xyh;
XYZn = U * XYZh;

% check 

%xy_check_m = mean(xyn,2)
%XYZ_check_m = mean(XYZn,2)

%xyz_scale_check = mean(sqrt(sum(xyn(1:2,:).^2, 1)))
%XYZ_scale_check = mean(sqrt(sum(XYZn(1:3,:).^2, 1)))

end