function peak = find_peak(X, x_l , r)
dists = dist2(X, x_l);

in_idx = find(dists <= r^2);
in = X(in_idx, :);
peak = mean(in, 1);