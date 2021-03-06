% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)

cov = zeros(3,3, K);
L_max = max(X(:, 1));
L_min = min(X(:, 1));
l = L_min + (-L_min + L_max)*rand;

a_max = max(X(:, 2));
a_min = min(X(:, 2));
a = a_min + (-a_min + a_max)*rand;

b_max = max(X(:, 3));
b_min = min(X(:, 3));
b = b_min + (-b_min + b_max)*rand;

for k = 1:K
    cov(:, :, k) = abs([l 0 0; 0 a 0; 0 0 b]);
end

end