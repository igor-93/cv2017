function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
 
  n_clusters = size(vCenters, 1);
  
  [idx, ~] = findnn( vFeatures, vCenters );
  
  bins = 1:n_clusters;
  histo = hist(idx, bins);
  
end
