function [P, D] = projectCamera(w, cv , cx , cy , p)
    cx = cx(:);
    cy = cy(:);
    R = [cx  cy  zeros(3,1)];
    d = cv(:);
    s = size(p);
    P = zeros(2,s(2));
    D = zeros(s(2),1);
    for i = 1:s(2)
        p(:,i) = R' * p(:,i);
        p(:,i) = -R' * d +p(:,i);
        x = (w * p(1,i)) / p(3,i);
        y = (w * p(2,i)) / p(3,i);
        P(1,i) = x;
        P(2,i) = y;
        D(i) = p(3,i);
    end
end