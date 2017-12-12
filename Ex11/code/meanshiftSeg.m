function [map, peaks] = meanshiftSeg(img, r)
ERR = 1e-5;
% convert image to dataset X
[n ,m, chs] = size(img);
ch1 = img(:, :, 1);
ch2 = img(:, :, 2);
ch3 = img(:, :, 3);

ch1 = reshape(ch1, [n*m, 1]);
ch2 = reshape(ch2, [n*m, 1]);
ch3 = reshape(ch3, [n*m, 1]);

X = [ch1 ch2 ch3];
n_pixels = n*m;
assert(size(X,1) == n_pixels);
assert(size(X,2) == 3);

map = 1:n_pixels;
iter = 0;
while 1    
    iter = iter + 1;
    disp(['Iteration: ',num2str(iter)]);
    peaks = find_peak(X, X(1,:) , r);
    
    assert(size(peaks,2) == 3);
    assert(size(peaks,1) == 1);
    for i = 2:size(X, 1)
        new_peak = find_peak(X, X(i,:) , r);
        peaks_dists = sqrt(dist2(new_peak, peaks));
        [m, idx] = min(peaks_dists);
        %disp(['m = ', num2str(m)])
        if  m < r / 2.0
            merged_peak = (peaks(idx,:) + new_peak) / 2.0;
            peaks(idx,:) = merged_peak;
            map(i) = map(idx);
        else
            peaks = [peaks; new_peak];
            map(i) = size(peaks, 1) +1;
        end
    end
    
    % put some stopping criteria here
    disp(['num peakes = ', num2str(size(peaks, 1))])
    if size(X,1) == size(peaks, 1)
        break;
    else
        X = peaks;
    end
    
end







end