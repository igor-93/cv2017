function [Idx Dist] = findnn( D1, D2 )
  % input:
  %   D1  : NxD matrix containing N feature vectors of dim. D
  %   D2  : MxD matrix containing M feature vectors of dim. D
  % output:
  %   Idx : N-dim. vector containing for each feature vector in D1
  %         the index of the closest feature vector in D2.
  %   Dist: N-dim. vector containing for each feature vector in D1
  %         the distance to the closest feature vector in D2.
  
  % Find for each feature vector in D1 the nearest neighbor in D2
  dists_mat = dist2(D1, D2);
  
  [Dist,Idx] = min(dists_mat,[],2);
  
  assert(size(D1,1) == size(Dist,1), 'Result dimensions mismatch.')
  
  Dist = Dist';
  Idx = Idx';
end
      