function I = specularLight(P, N, C, ks, ncoeff, S, I0)
    I = zeros(3,1);
    I0 = I0(:);
    
    s = size(S);
    if s(1) ~= 3
        S = S';
        s = size(S);
    end
    C = C(:);
    for j = 1:s(2)
       L = (S(:,j) - P) / norm(S(:,j) - P);
       V = (C - P) / norm(C - P);
       dotNL = dot(N,L);
       d = norm(S(:,j) - P);
       fatt = 1; %consider fatt = 1 in order to distinguish the differnces in colours
       I = I + I0 * fatt .* ks * (dot((2 * N * dotNL - L),V) ^ ncoeff);
    end
end