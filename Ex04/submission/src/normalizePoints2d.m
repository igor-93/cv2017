% Normalization of 2d-pts
% Inputs: 
%           x1s = 2d points
% Outputs:
%           nxs = normalized points in hom. coordiantes
%           T = normalization matrix
function [nxs, T] = normalizePoints2d(x1s)
    %data normalization
    
    % cut the last entry for now and add it later
    x1s = x1s(1:2,:);
    
    %first compute centroid
    x1s_centroid = mean(x1s,2);

    %then, compute scale
    x1s_centered = x1s - x1s_centroid;

    x1s_scale = sqrt(2) ./ mean(sqrt(sum(x1s_centered.^2, 1)));


    %create T and U transformation matrices
    T = [1.0/x1s_scale 0 x1s_centroid(1); 0 1.0/x1s_scale x1s_centroid(2); 0 0 1];
    
    %and normalize the points according to the transformations
    xyh = vertcat(x1s, ones(1, size(x1s,2)));
    T = inv(T);
    nxs = T * xyh;
    
    

    % check 

    xy_check_m = mean(nxs,2);

    xyz_scale_check = mean(sqrt(sum(nxs(1:2,:).^2, 1)));
    
end
