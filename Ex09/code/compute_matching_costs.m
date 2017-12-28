function costMatrix = compute_matching_costs(objects,nSamples)

n = length(objects);
display_flag = false;

costMatrix = Inf*eye(n);

for i = 1:n
    X_samp = get_samples_1(objects(i).X, nSamples);
    
    for j = 1:n
        if i == j
            continue
        end
        Y_samp = get_samples_1(objects(j).X, nSamples);
        matchingCost = shape_matching(X_samp,Y_samp,display_flag);
        costMatrix(i,j) = matchingCost;
    end
end

        
