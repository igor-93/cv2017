function [mus, vars, alphas] = maximization(P, X)

K = size(P,2);
n = size(X,1);

Ps_summed = sum(P, 1);

assert(size(Ps_summed, 1) == 1);
assert(size(Ps_summed, 2) == K);
alphas = Ps_summed ./ n;

mus = zeros(K,3);
for k = 1:K
    P_col = P(:, k);
    P_cols = [P_col P_col P_col];
    mu_k = sum(X .* P_cols, 1);
    mus(k, :) = mu_k ./ Ps_summed(k);
end

vars = zeros(3,3, K);
for k = 1:K
    mus_repeated = repmat(mus(k,:), n, 1);
    P_col_repeated = repmat(P(:,k), 1, 3);
    diff = X - mus_repeated;
    var_k = diff' * (diff .* P_col_repeated);
    vars(:, :, k) = var_k ./ Ps_summed(k);
end


end