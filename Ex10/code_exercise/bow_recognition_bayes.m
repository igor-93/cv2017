function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);


% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

likelihood_pos = normpdf(histogram,muPos,sigmaPos);
likelihood_neg = normpdf(histogram,muNeg,sigmaNeg);

likelihood_pos(isnan(likelihood_pos)) = 1;
likelihood_neg(isnan(likelihood_neg)) = 1;
    
likelihood_pos = log(likelihood_pos);
likelihood_neg = log(likelihood_neg);

likelihood_pos = sum(likelihood_pos(:));
likelihood_neg = sum(likelihood_neg(:));

 if (likelihood_pos > likelihood_neg)
    label = 1;
  else
    label = 0;
  end


end