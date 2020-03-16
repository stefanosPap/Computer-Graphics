function [P_2d , D] = photographObject(p, M, N, H, W, w, cv , cK , cu)
    [P_2d, D] = projectKu(w, cv , cK , cu , p);
    P_2d = rasterize(P_2d, M, N, H, W );
end