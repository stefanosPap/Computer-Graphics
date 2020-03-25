function I = specularLight(P, N, C, ks, ncoeff, S, I0)
    I = zeros(3,1);
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
       I = I + I0 .* ks * (dot((2 * N * dotNL - L),V) ^ ncoeff);
    end
end