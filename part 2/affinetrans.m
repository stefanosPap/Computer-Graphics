function cq = affinetrans(cp , R, ct)
    ct = ct(:);
    sizes = size(cp);
    if sizes(1) ~= 3
        cp = cp';
    end
    cq = R * cp + ct;    
end