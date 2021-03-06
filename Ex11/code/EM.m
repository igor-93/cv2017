function [map, mus] = EM(img, K)
% convert image to dataset X
[n ,m, chs] = size(img);
disp(['Total pixels: ',num2str(n*m)]);
ch1 = img(:, :, 1);
ch2 = img(:, :, 2);
ch3 = img(:, :, 3);

ch1 = reshape(ch1, [n*m, 1]);
ch2 = reshape(ch2, [n*m, 1]);
ch3 = reshape(ch3, [n*m, 1]);

X = [ch1 ch2 ch3 ones(n*m,1)];

% normalize data
[X, T] = normalise3dpts(X');
X = (X(1:3,:))';

% use function generate_mu to initialize mus
mus = generate_mu(X, K);
old_mus = mus;
% use function generate_cov to initialize covariances
vars = generate_cov(X, K);

alphas = ones(1, K) ./ K;

% iterate between maximization and expectation
iter = 0;
for i = 1:300
    iter = iter + 1;
    
    % use function expectation
    P = expectation(old_mus,vars,alphas,X);
    
    % use function maximization
    [mus, vars, alphas] = maximization(P, X);

    %ids = visualizeMostLikelySegments(img,alphas,mus,vars);
    %keyboard;
    
    sq_diff = (mus - old_mus).^2;
    diff = sum(sq_diff(:));
    if diff < 1e-3
        break
    else
        old_mus = mus;
    end
end
disp(['Iterations: ',num2str(iter)]);

[~, map] = max(P, [], 2);
map = reshape(map, [n, m]);

end