function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor in the positive and negative sets
  % and decide based on this neighbor
  [~, dists_pos] = findnn( histogram, vBoWPos );
  [~, dists_neg] = findnn( histogram, vBoWNeg );
  
  if (dists_pos<dists_neg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
