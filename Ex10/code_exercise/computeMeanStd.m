function [mu sigma] = computeMeanStd(X)

mu = mean(X, 1);
sigma = std(X, 0, 1);

assert(size(mu,2) == size(X,2));
assert(size(sigma,2) == size(X,2));

end