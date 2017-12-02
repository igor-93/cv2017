function vCenters = kmeans(vFeatures,k,numiter)

  [nPoints, d]  = size(vFeatures);

  % Initialize each cluster center to a different random point.
  randidx = randperm(nPoints);
  vCenters = vFeatures(randidx(1:k), :);
  
  % Repeat for numiter iterations
  for i=1:numiter
      % Assign each point to the closest cluster
      [idx, Dist] = findnn( vFeatures, vCenters );

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

      disp(strcat(num2str(i),'/',num2str(numiter),' iterations completed.'));
  end
 
 disp(strcat('Final number of clusters: ',num2str(k)));
end
