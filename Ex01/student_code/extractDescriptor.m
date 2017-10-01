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
    disp('Extracting descriptors...');
    n = size(corners, 2);
    disp(n)
    
    [rows, cols] = size(img);
    descr = zeros(81, n);
    
    for it = 1:n
        r = corners(1, it);
        c = corners(2, it);
        if r-4 < 1 || c-4 < 1
            continue;
        end
        if r+4 > rows || c+4 > cols
            continue;
        end
        region = img(r-4:r+4, c-4:c+4);
        descr(:, it) = region(:);
    end
    
    disp('Done.');
end