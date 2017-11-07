function [in1, in2, out1, out2, m, F] = ransac8pF(xy1, xy2, threshold)
    
    number = size(xy1,2) % Total number of points
    bestInNum = 0;         % Best fitting F with largest number of inliers
    F = eye(3);              % parameters for best fitting line

    xy1 = [xy1; ones(1, number)];
    xy2 = [xy2; ones(1, number)];
    
    for i=1:number
        % Randomly select 8 points
        cols = randperm(size(xy1, 2), 8);
        
        points1 = xy1(:, cols);
        points2 = xy2(:, cols);
        
        % calculate F for these 8 points
        [F_curr, ~] = fundamentalMatrix(points1, points2, false);
        
        % Compute the distances between matching p1 and transformed p2
        distances = zeros(number,1);
        for j=1:number
            d1 = pdist([ xy1(:, j)'; (F_curr * xy2(:, j))']);
            d2 = pdist([ xy2(:, j)'; (F_curr' * xy1(:, j))']);
            distances(j) = d1 + d2;
        end
        inliers = find(distances <= threshold);
        
        [F_new, ~] = fundamentalMatrix(xy1(:, inliers), xy2(:, inliers), false);
        distances = zeros(number,1);
        for j=1:number
            d1 = pdist([ xy1(:, j)'; (F_new * xy2(:, j))']);
            d2 = pdist([ xy2(:, j)'; (F_new' * xy1(:, j))']);
            distances(j) = d1 + d2;
        end
        inliers = find(distances <= threshold);
        [n_inliers,~] = size(inliers)
        if n_inliers > bestInNum
            bestInNum = n_inliers
            F = F_new;
            in1 = xy1(:, inliers);
            in2 = xy2(:, inliers);
        end
    end
end


