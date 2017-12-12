function new_a = reassign(a, map)
    to_reassign = find(((1:size(map, 2)) - map) ~= 0);
    for cl = to_reassign
        a(a == cl) = map(cl);
    end
    unq = unique(a,'sorted');
    iter = 0;
    for u = unq
        iter = 1 + iter;
        a(a == u) = iter;
    end
    new_a = a;
    
    unq = unique(new_a);
    assert(size(unq, 2) == max(new_a));
end