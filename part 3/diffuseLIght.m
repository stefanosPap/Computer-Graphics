function I = diffuseLight(P,N,kd,S,I0)
    I = zeros(3,1);
    s = size(S);
    for j = 1:s(2)
       L = (S(:,j) - P) / norm(S(:,j) - P);
       d = norm(S(:,j) - P);
       fatt = 1 / d ^ 2;
       I(1) = I(1) + I0(1,j) * fatt * kd(1) * dot(N,L);
       I(2) = I(2) + I0(2,j) * fatt * kd(2) * dot(N,L);
       I(3) = I(3) + I0(3,j) * fatt * kd(3) * dot(N,L);
    end
end