function testClass = nn_classify(matchingCostVector,trainClasses,k)

[~, costsIdx] = sort(matchingCostVector);
%smallestCosts = costsSorted(1:k);
smallestKIdx = costsIdx(1:k);
 
classes_found = [];
 
 for i = 1:k
     idx = smallestKIdx(i);
     cl = trainClasses{idx};
     classes_found = [classes_found, cl];
 end
 
 testClass = mode(classes_found);