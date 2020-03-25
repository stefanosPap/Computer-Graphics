function I = diffuseLight(P,N,kd,S,I0)
    I = zeros(3,1);
    s = size(S);
    if s(1) ~= 3
        S = S';
        s = size(S);
    end
    for j = 1:s(2)
       L = (S(:,j) - P) / norm(S(:,j) - P);
       d = norm(S(:,j) - P);
       fatt = 1 / d ^ 2;
       I = I + I0 * fatt .* kd * dot(N,L);
     end
end