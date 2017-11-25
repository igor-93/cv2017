% X are points. Shape (n,d)
% the rest are the params
% descriptors is of shape n,k with k = nbBins_theta * nbBins_r
function descriptors = sc_compute(X, nbBins_theta, nbBins_r, smallest_r,biggest_r)

[n, d] = size(X);
assert(d == 2, int2str(d));

descriptors = zeros(n, nbBins_theta * nbBins_r);

r_bins = linspace(smallest_r, biggest_r, nbBins_r+1);
theta_bins = linspace(0, 2*pi, nbBins_theta+1);

% calculate log distances for all pairs
dists = real(sqrt(dist2(X, X)));
%keyboard;
% normalize the distances 
dists = log(dists);
idx = 1==eye(size(dists));
dists(idx) = 0;
%mean_dist = mean(dists(:));
%dists = dists / mean_dist;


% for each point calculate the histogram
for i = 1:n
    h = zeros(nbBins_theta, nbBins_r);
    for j = 1:n
        r = dists(i,j);
        if j == i || r < smallest_r || r >= biggest_r
            continue
        end
        theta = angle(X(i,:), X(j,:));
        theta_bin = find(theta_bins>theta, 1)-1;
        r_bin = find(r_bins>r, 1)-1;
        % this can be omitted since it is checked in the prev if block
        %if isempty(r_bin) || r_bin == 0
        %    continue
        %end
        h(theta_bin, r_bin) = h(theta_bin, r_bin) + 1;
    end
    % vectorize the histogram nad put it in the final result
    %keyboard;
    h = reshape(h, 1,[]);
    descriptors(i,:) = h;
end
        



