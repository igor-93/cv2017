function [vCenters, loss] = kmeans(vFeatures,k,numiter)

  [nPoints, d]  = size(vFeatures);

  % Initialize each cluster center to a different random point.
  randidx = randperm(nPoints);
  vCenters = vFeatures(randidx(1:k), :);
  
  old_loss = Inf;
  ERR = 1;
  
  % Repeat for numiter iterations
  for i=1:numiter
      % Assign each point to the closest cluster
      [idx, dists] = findnn( vFeatures, vCenters );
      
      c_loss = sum(dists(:)) / size(dists,1);
      loss_diff = old_loss - c_loss;
      if loss_diff > ERR
          %disp(strcat('Loss difference: ',num2str(loss_diff)));
          old_loss = c_loss;
      else
          break;
      end
          

      % Shift each cluster center to the mean of its assigned points
      vCenters = zeros(0, d);
      for j=1:k
          xj = vFeatures(idx==j,:);
          ck = size(xj,1);
          if ck == 0
              continue
          end
          new_mean = (1/ck) * sum(xj, 1);
          vCenters = [vCenters; new_mean];
      end
      k = size(vCenters, 1);

      %disp(strcat(num2str(i),'/',num2str(numiter),' iterations completed.'));
  end
 
  [~, dists] = findnn( vFeatures, vCenters );
  disp(strcat('Final number of clusters: ',num2str(k)));
  loss = sum(dists(:)) / size(dists,1);
  disp(strcat('Loss: ',num2str(loss)));
end
