function [in1, in2, out1, out2, m, F] = ransac8pF(xy1, xy2, threshold)
    
    number = size(xy1,2); % Total number of points
    bestInNum = 0;         % Best fitting F with largest number of inliers
    F = eye(3);              % parameters for best fitting line

    xy1 = [xy1; ones(1, number)];
    xy2 = [xy2; ones(1, number)];
    
    for i=1:1
        % Randomly select 8 points
        cols = randperm(size(xy1, 2), 8);
        
        points1 = xy1(:, cols);
        points2 = xy2(:, cols);
        
        % calculate F for these 8 points
        [F_curr, ~] = fundamentalMatrix(points1, points2, true);
        
        % Compute the distances between matching p1 and transformed p2
        R = zeros(1,number);
	    for n = 1:length(xy1)
            R(n) = xy1(:,n)'*F_curr*xy2(:,n);
	    end
	    
	    l_prime = F_curr' * xy1
	    l = F_curr * xy2   
        l = l ./ l(3,:)

	    % Evaluate distances
	    d = R.^2 ./ ...
		 (l(1,:).^2 + l(2,:).^2 + l_prime(1,:).^2 + l_prime(2,:).^2);

        
%         distances = zeros(number,1);
%         for j=1:number
%             proj1 = (F_curr * xy1(:, j));
%             proj2 = (F_curr' * xy2(:, j));
%             [ xy1(:, j)'; (proj2/proj2(3))']
%             d1 = pdist([ xy1(:, j)'; (proj2/proj2(3))']);
%             d2 = pdist([ xy2(:, j)'; (proj1/proj1(3))']);
%             distances(j) = d1 + d2;
%         end
         inliers = find(d <= threshold);
         [n_inliers, ~] = size(inliers)
        if n_inliers >= 8
            disp(n_inliers)
        else
            continue
        end
%         
         [F_new, ~] = fundamentalMatrix(xy1(:, inliers), xy2(:, inliers), true);
%         distances = zeros(number,1);
%         for j=1:number
%             proj1 = (F_new * xy1(:, j)); 
%             proj2 = (F_new' * xy2(:, j)); 
%             d1 = pdist([ xy1(:, j)'; (proj2/proj2(3))']);
%             d2 = pdist([ xy2(:, j)'; (proj1/proj1(3))']);
%             distances(j) = d1 + d2;
%         end
        
        R = zeros(1,number);
	    for n = 1:length(xy1)
            R(n) = xy1(:,n)'*F_new*xy2(:,n);
	    end
	    
	    l_prime = F_new' * xy1;
	    l = F_new * xy2;     

	    % Evaluate distances
	    d2 = R.^2 ./ ...
		 (l(1,:).^2 + l(2,:).^2 + l_prime(1,:).^2 + l_prime(2,:).^2)
        
        
        inliers = find(d2 <= threshold);
        [n_inliers,~] = size(inliers)
        if n_inliers > bestInNum
            bestInNum = n_inliers
            disp(n_inliers)
            F = F_new;
            in1 = xy1(:, inliers);
            in2 = xy2(:, inliers);
        end
    end
end


