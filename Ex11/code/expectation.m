function P = expectation(mus,vars,alphas,X)

K = size(alphas,2);
N = size(X,1);

P = zeros(N,K);
for k = 1:K
    y_k = mvnpdf(X,mus(k, :),vars(:,:,k));
    P(:, k) = alphas(k) * y_k;
end

norm_factors = sum(P, 2);
norm_factors = repmat(norm_factors, 1, K);
P = P ./ norm_factors;

end