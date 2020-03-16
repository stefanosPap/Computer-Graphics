function cq = affinetrans(cp , R, ct)
    sizes = size(cp);
    if sizes(1) ~= 3
        cp = cp';
        sizes = size(cp);
    end
    cq = zeros(sizes(1),sizes(2));
    for i = 1:sizes(2)
        cq(:,i) = R * cp(:,i);
        cq(:,i) = cq(:,i) + ct;
    end
end