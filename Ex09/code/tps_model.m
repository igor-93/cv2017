function [wx wy E] = tps_model(X,Y,lambda)

[n, d] = size(X);
assert(d==2);

dists_sq = dist2(X, X);
log_dists = log(dists_sq);
log_dists(log_dists==-Inf) = 0;
K = dists_sq .* log_dists;

P = horzcat(ones(n, 1), X);

L = [K+lambda*eye(n) P; P' zeros(3,3)];
[L_rows, L_cols] = size(L);
assert(L_rows == (n+3));
assert(L_cols == (n+3));

rhs_x = [Y(:,1); 0; 0; 0;];
rhs_y = [Y(:,2); 0; 0; 0;];
wx = L \ rhs_x;
wy = L \ rhs_y;

E = wx(1:end-3)' * K * wx(1:end-3) + wy(1:end-3)' * K * wy(1:end-3);