function Prast = rasterize(P, M, N, H, W)
    s = size(P);
    Pnorm = zeros(2,s(2));
    Prast = zeros(2,s(2));
    for i = 1:s(2)
        Pnorm(1,i) = (P(1,i) + W/2)/W;
        Pnorm(2,i) = (P(2,i) + H/2)/H;
        Prast(1,i) = floor((1 - Pnorm(1,i)) * M);
        Prast(2,i) = floor((1 - Pnorm(2,i)) * N);
    end
end