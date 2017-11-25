function samples = get_samples(X, nsamp)

[n, ~] = size(X);

ind0 = randperm(n);
ind0 = ind0(1:nsamp);

samples = X(ind0, :);

[ns, ds] = size(samples);
assert(ns == nsamp && ds == 2,'Output is wrong.')