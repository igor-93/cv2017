% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh)
    % get derivatives
    [Ix,Iy] = gradient(img);
    
    % precompute the necessary parts of haris matrix
    Ix2 = Ix .^2;
    Iy2 = Iy .^2;
    Ixy = Ix .* Iy;
    
    % gaussian kernel
    gaus = fspecial('gaussian',max(1,fix(6*3)), 3);
    
    % smoothed image derivs
    Ix2 = conv2(Ix2, gaus, 'same'); 
    Iy2 = conv2(Iy2, gaus, 'same');
    Ixy = conv2(Ixy, gaus, 'same');
    
    % precompute sums from neighbourhood,
    % so we can later build harris from that
    unifrmal_kernel = [1 1 1; 1 1 1; 1 1 1];
    Sx2 = conv2(unifrmal_kernel, Ix2);
    Sy2 = conv2(unifrmal_kernel, Iy2);
    Sxy = conv2(unifrmal_kernel, Ixy);
    
    
    [rows,cols] = size(img);
    H(1:rows,1:cols) = 0;   % init output of harris with zeros
    
    for c = 1:cols
        for r = 1:rows
            harris = [Sx2(r, c) Sxy(r, c); Sxy(r, c) Sy2(r, c)];
            
            K = det(harris) / trace(harris);
            H(r,c) = K;
        end
    end
    
    disp('Calculated H.')
    
    fun = @(x) max([max(x([1 3], :)) x(2,1) x(2,3)]);
    supression = nlfilter(H,[3 3],fun);
    
    disp('Calculated supression.')
    
    passed_thresh = (H > thresh) & (H > supression);
    
    [rows, cols] = find(passed_thresh);
    
    corners = transpose([rows(:), cols(:)]);
    
    disp('Found corners:');
    disp(size(corners));
    
end