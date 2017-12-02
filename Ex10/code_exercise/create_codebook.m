function vCenters = create_codebook(nameDir,k,numiter)
  
  vImgNames = dir(fullfile(nameDir,'*.png'));
  
  nImgs = length(vImgNames);
  vFeatures = zeros(0,128); % 16 histograms containing 8 bins
  vPatches = zeros(0,16*16); % 16*16 image patches 
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  % Extract features for all images
  for i=1:nImgs
    
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(nameDir,vImgNames(i).name))));

    % Collect local feature points for each image
    % and compute a descriptor for each local feature point
    vPoints = grid_points(img,nPointsX,nPointsY,border);
    
    % create hog descriptors and patches
    [cFeatures, cPatches] = descriptors_hog(img,vPoints,cellWidth,cellHeight);
    
    vFeatures = [vFeatures; cFeatures];
    vPatches = [vPatches; cPatches];
    
  end
  disp(strcat('    Number of extracted features:',num2str(size(vFeatures,1))));

  % Cluster the features using K-Means
%   ks = [5, 10, 15, 20, 25, 30, 35, 50, 70, 80, 100, 200, 300, 400, 500, 700, 1000];
%   losses = [];
%   num_trials = 10;
%   for ki = ks
%       ave_loss = 0
%       for j = 1:num_trials
%           disp(strcat('  Clustering...'));
%           [~, loss] = kmeans(vFeatures, ki, numiter);
%           ave_loss = ave_loss + loss;
%       end
%       ave_loss = ave_loss / num_trials;
%       losses = [losses; ave_loss];
%   end
%   figure(7)
%   plot(ks,losses)

  [vCenters, loss] = kmeans(vFeatures, k, numiter);
  
  
  
  % Visualize the code book  
  disp('Visualizing the codebook...');
  visualize_codebook(vCenters,vFeatures,vPatches,cellWidth,cellHeight);
  %disp('Press any key to continue...');
  %pause;
  
 

end