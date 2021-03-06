% Generate initial values for mu
% K is the number of segments

function C = generate_mu(X, k)
X = X';
% The k-means++ initialization.
C = X(:,1+round(rand*(size(X,2)-1)));
L = ones(1,size(X,2));
for i = 2:k
    D = X-C(:,L);
    D = cumsum(sqrt(dot(D,D,1)));
    if D(end) == 0, C(:,i:k) = X(:,ones(1,k-i+1)); return; end
    C(:,i) = X(:,find(rand < D/D(end),1));
    [~,L] = max(bsxfun(@minus,2*real(C'*X),dot(C,C,1).'));
end
C = C';
assert(size(C, 1) == k);
assert(size(C, 2) == 3);

end