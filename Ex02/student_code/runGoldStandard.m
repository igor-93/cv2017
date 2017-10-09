function [K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
xy_normalized = [];
XYZ_normalized = [];

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

%denormalize camera matrix

%factorize camera matrix in to K, R and t

%compute reprojection error

end