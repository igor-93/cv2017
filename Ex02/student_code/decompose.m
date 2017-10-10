function [ K, R, C ] = decompose(P)
%decompose P into K, R and t
    M = P(1:3,1:3);
    KRC = P(1:3, 4);

    [R_inv,K_inv] = qr(inv(M));
    R = inv(R_inv)
    K = inv(K_inv);
    K = K ./ K(3,3)

    [~,~,V] = svd(P);
    C = V(:,end);
end