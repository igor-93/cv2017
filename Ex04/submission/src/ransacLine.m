function [k, b] = ransacLine(data, dim, iter, threshDist, inlierRatio)
% data: a 2xn dataset with #n data points
% num: the minimum number of points. For line fitting problem, num=2
% iter: the number of iterations
% threshDist: the threshold of the distances between points and the fitting line
% inlierRatio: the threshold of the number of inliers

number = size(data,2); % Total number of points
bestInNum = 0;         % Best fitting line with largest number of inliers
k=0; b=0;              % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points
    cols = randperm(size(data, 2), dim);
    p1 = data(:, cols(1));
    p2 = data(:, cols(2));
    
    % Compute the distances between all points with the fitting line
    distances = abs((p2(2)-p1(2))*data(1,:) - (p2(1)-p1(1))*data(2,:) + p2(1)*p1(2)-p2(2)*p1(1)) / sqrt( (p2(2)-p1(2))^2 + (p2(1) - p1(1))^2 );
    
    % Compute the inliers with distances smaller than the threshold
    inliers = find(distances <= threshDist);
    if size(inliers,2) < 2
        inliers
        disp("ERROR: only 2 points are inliers")
        continue;
    end
    new_model = polyfit(data(1,inliers), data(2,inliers), 1);
    % FOR DEBUG ONLY!!
    k_new = new_model(1);
    b_new = new_model(2);
    
    % Update the number of inliers and fitting model if better model is found
    distances = abs(-data(2,:)+k_new*data(1,:)+b_new) / (sqrt(1+k_new*k_new));
    n_inliers = size(find(distances <= threshDist), 2);
    if n_inliers > bestInNum
        bestInNum = n_inliers
        k = k_new;
        b = b_new;
    end
end

end
