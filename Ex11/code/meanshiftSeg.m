function [assignments, peaks] = meanshiftSeg(img, r)
% convert image to dataset X
[n ,m, ~] = size(img);
disp(['Total pixels: ',num2str(n*m)]);
ch1 = img(:, :, 1);
ch2 = img(:, :, 2);
ch3 = img(:, :, 3);

ch1 = reshape(ch1, [n*m, 1]);
ch2 = reshape(ch2, [n*m, 1]);
ch3 = reshape(ch3, [n*m, 1]);

X = [ch1 ch2 ch3 ones(n*m,1)];

% normalize data
[X, T] = normalise3dpts(X');
X = (X(1:3,:))';
r = r * T(1,1); % rescale the radius as well

n_pixels = n*m;
assert(size(X,1) == n_pixels);
assert(size(X,2) == 3);

% assigns each pixel to a cluster
assignments = 1:n_pixels;


% iterate until convergence
iter = 0;
while 1    
    iter = iter + 1;
    peaks = find_peak(X, X(1,:) , r);
    
    % maps previous peaks to the current peakes
    map = [1];
    
    assert(size(peaks,2) == 3);
    assert(size(peaks,1) == 1);
    for i = 2:size(X, 1)
        new_peak = find_peak(X, X(i,:) , r);
        peaks_dists = sqrt(dist2(new_peak, peaks));
        [mval, idx] = min(peaks_dists);
        if  mval < r / 2.0
            %disp(['mval = ', num2str(mval)])
            merged_peak = (peaks(idx,:) + new_peak) / 2.0;
            peaks(idx,:) = merged_peak;
            map = [map idx];
        else
            peaks = [peaks; new_peak];
            map = [map max(map)+1];
        end
    end
    
    % put some stopping criteria here
    disp(['num peakes = ', num2str(size(peaks, 1))])
    if size(X,1) == size(peaks, 1)
        break;
    else
        X = peaks;
    end
    
    assignments = reassign(assignments, map);
    num_peaks = size(peaks,1);
    num_clusters = max(assignments);
    assert(num_peaks == num_clusters, '%d == %d', num_peaks, num_clusters)
       
end

disp(['Iterations: ',num2str(iter)]);

assignments = reshape(assignments, [n, m]);

end