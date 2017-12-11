function [map, mus] = EM(img, K)
% convert image to dataset X
[n ,m, chs] = size(img);
ch1 = img(:, :, 1);
ch2 = img(:, :, 2);
ch3 = img(:, :, 3);

ch1 = reshape(ch1, [n*m, 1]);
ch2 = reshape(ch2, [n*m, 1]);
ch3 = reshape(ch3, [n*m, 1]);

X = [ch1 ch2 ch3];

% use function generate_mu to initialize mus
mus = generate_mu(X, K);
old_mus = mus;
% use function generate_cov to initialize covariances
vars = generate_cov(X, K);

alphas = ones(1, K) ./ K;

% iterate between maximization and expectation
for i = 1:300
    disp(['Iteration: ',num2str(i)]);
    % use function expectation
    P = expectation(old_mus,vars,alphas,X);
    
    % use function maximization
    [mus, vars, alphas] = maximization(P, X);

    sq_diff = (mus - old_mus).^2;
    err = sum(sq_diff(:))
    if err < 1e-8
        break
    else
        old_mus = mus;
    end
end

map = max(P, [], 2);
map = reshape(map, [n, m]);

end