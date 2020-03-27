function [P, D, S] = projectKu(w, cv , cK , cu , p, S)
    cv = cv(:);
    cu = cu(:);
    cK = cK(:);
    
    cz = (cK - cv) / norm(cK-cv);
    t = cu - dot(cu,cz) * cz;
    cy = t/norm(t);
    cx = cross(cy,cz);
    
    [P,D] = projectCamera(w, cv , cx , cy , p);
end