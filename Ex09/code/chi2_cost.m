% s1, s2 are descriptors. shape: n, k
% C is cost matrix of shape: n, n
function C = chi2_cost(s1,s2)

[n1, k1] = size(s1);
[n2, k2] = size(s2);
assert(k1 == k2,'Dimmensions do not agree.')

C = zeros(n1, n2);
for i1 = 1:n1
    for i2 = (i1+1):n2
        g = s1(i1, :);
        h = s2(i2, :);
        C(i1, i2) = 0.5 * sum(((g - h).^2) / (g + h));
    end
end

% make it symmetric
C = C + C';

            
