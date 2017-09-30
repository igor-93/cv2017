% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - w x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  

    n = size(corners, 2);
    disp(n)
    
    rows, cols = size(img)
    descr = zeros(81, n);
    
    for it = 1:n
        r = corners(1, it);
        c = corners(2, it);
        if r-3 < 0 || c-3 < 0
            continue;
        end
        if r+3 > rows || c+3 > cols:
            continue;
        end
        region = img(r-3:r+3, c-3:c+3);
        descr(:, it) = region(:);
    end

end