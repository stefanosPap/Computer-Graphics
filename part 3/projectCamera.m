function [P, D] = projectCamera(w, cv , cx , cy , p)
    cx = cx(:);
    cy = cy(:);
    cz = cross(cx,cy);
    cz = cz(:);
    
    s = size(p);
    if s(1) ~= 3
        p = p';
        s = size(p);
    end
    P = zeros(2,s(2));
    D = zeros(1,s(2));
    
    p = systemtrans(p , cx , cy , cz , cv);
    for i = 1:s(2)
        x = (w * p(1,i)) / p(3,i);
        y = (w * p(2,i)) / p(3,i);
        P(1,i) = x;
        P(2,i) = y;
        D(i) = p(3,i);
    end
end