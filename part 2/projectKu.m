function [P, D] = projectKu(w, cv , cK , cu , p)
    cv = cv(:);
    cu = cu(:);
    cK = cK(:);
    
    s = size(p);
    if s(1) ~= 3
        p = p';
        s = size(p);
    end
    P = zeros(2,s(2));
    
    cz = cK/norm(cK);
    t = cu - dot(cu,cz) * cz;
    cy = t/norm(t);
    cx = cross(cy,cz);
    
    p = systemtrans(p , cx , cy , -cz , cv);
    for i = 1:s(2)
        x = (w * p(1,i)) / p(3,i);
        y = (w * p(2,i)) / p(3,i);
        P(1,i) = x;
        P(2,i) = y;
        D(i) = p(3,i);
    end
end