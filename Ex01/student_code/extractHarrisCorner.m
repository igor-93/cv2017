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
    [Ix,Iy] = gradient(img);
    
    Ix2 = Ix .^2;
    Iy2 = Iy .^2;
    Ixy = Ix .* Iy;
    
    [rows,cols] = size(img);
    H(1:rows,1:cols) = 0;   % init output of haris with zeros
    
    for c = 2:cols-1
        for r = 2:rows-1
            harris(1:2,1:2) = 0;
            for cn = c-1:c+1
                for rn = r-1:r+1
                    ix2 = Ix2(rn,cn);
                    iy2 = Iy2(rn,cn);
                    ixy = Ixy(rn,cn);
                    harris_temp = [ix2 ixy; ixy iy2];
                    harris = harris + harris_temp;
                end
            end
            
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