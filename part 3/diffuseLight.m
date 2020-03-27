function I = diffuseLight(P,N,kd,S,I0)
    I = zeros(3,1);
    I0 = I0(:);
    s = size(S);
    if s(1) ~= 3
        S = S';
        s = size(S);
    end
    for j = 1:s(2)
       L = (S(:,j) - P);
       L = L / norm(L);
       d = norm(S(:,j) - P);
       fatt = 1;
       I = I + I0 .* fatt .* kd .* dot(N,L);
     end
end