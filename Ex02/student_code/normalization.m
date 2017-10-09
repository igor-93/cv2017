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
T = [xy_scale 0 0; 0 xy_scale 0; 0 0 1];
U = [XYZ_scale 0 0 0; 0 XYZ_scale 0 0; 0 0 XYZ_scale 0; 0 0 0 1];

%and normalize the points according to the transformations
xyh = vertcat(xy_centered, ones(1, size(xy,2)));
XYZh = vertcat(XYZ_centered, ones(1, size(XYZ,2)));

%xyn = vertcat(xy_centered ./ xy_scale , ones(1, size(xy,2)));
%XYZn = vertcat(XYZ_centered ./ XYZ_scale , ones(1, size(XYZ,2)));
xyn = T * xyh;
XYZn = U * XYZh;

% check 

xy_check_m = mean(xyn,2);
XYZ_check_m = mean(XYZn,2);

if isequal(xy_check_m, [0;0;1]) && isequal(XYZ_check_m, [0;0;0;1])
    disp("Means are correct")
else
    xy_check_m
    XYZ_check_m
end

xyz_scale_check = mean(sqrt(sum(xyn(1:2,:).^2, 1)))
XYZ_scale_check = mean(sqrt(sum(XYZn(1:3,:).^2, 1)))


end