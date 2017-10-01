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
    
    % matrix that will contain SSD for each pair of descriptors
    ssds = inf(n, m);
    
    disp('Building SSDs matrix...');
    for it1 = 1:n
        for it2 = 1:m
            % sum of square distances for each pair of descriptors
            ssd = sum((descr1(:, it1) - descr2(:,it2)) .^2);
            % discard if SSD is bigger then threshold
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
        % find 2 closest descriptors from all possible pairs
        [min_val, min_ind] = min(ssds(:));
        [i1, i2] = ind2sub(size(ssds),min_ind);
        
        % stop when the whole matrix are only Infs
        if isinf(min_val)
            break;
        end
        
        % add the closest descriptors to output
        matches = [matches [i1; i2]];
        
        % disable furhter matches for these two descriptors
        ssds(i1, :) = Inf;
        ssds(:, i2) = Inf;
    end
    disp('Done!');
end