function P_rast = rasterize(P, M, N, H, W )
    s = size(P);
    for i = 1:s(2)
        Pnorm(1,i) = (P(1,i)+M/2)/M;
        Pnorm(2,i) = (P(2,i)+N/2)/N;
        P_rast(1,i) = floor(Pnorm(1,i) * H);
        P_rast(2,i) = floor(Pnorm(2,i) * W);
    end
end