% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)

    [k, n] = size(descr1);
    m = size(descr2, 2);
    
    ssds = inf(n, m);
    
    disp('Building SSDs matrix...');
    for it1 = 1:n
        for it2 = 1:m
            % sum of square distances for each pair of descriptors
            ssd = sum((descr1(:, it1) - descr2(:,it2)) .^2);
            % discard if SSD bigger then threshold
            if ssd > thresh
                continue;
            end
            ssds(it1, it2) = ssd;
        end
    end
    
    disp('Done.');
    matches = [];
    
    disp('Finding best matches...');
    while true
        [min_val, min_ind] = min(ssds(:));
        [i1, i2] = ind2sub(size(ssds),min_ind);
        if isinf(min_val)
            break;
        end
        
        matches = [matches [i1; i2]];
        ssds(i1, :) = Inf;
        ssds(:, i2) = Inf;
    end
    disp('Done!');
end