function testClass = nn_classify(matchingCostVector,trainClasses,k)

[~, costsIdx] = sort(matchingCostVector);
%smallestCosts = costsSorted(1:k);
smallestKIdx = costsIdx(1:k);
 
classes_found = {};
 
 for i = 1:k
     idx = smallestKIdx(i);
     cl = trainClasses{idx};
     classes_found{i} = cl;
 end
 
x = classes_found;
y = unique(x);
n = zeros(length(y), 1);
for iy = 1:length(y)
  n(iy) = length(find(strcmp(y{iy}, x)));
end
[~, itemp] = max(n);
testClass = y(itemp)