function color = colorInterp(A,B,a,b,x)
    %A=[r1 g1 b1]
    %B=[r2 g2 b2]
    %compute r,g,b values with linear interpolation
    r = B(1)+(A(1)-B(1))*(x-b)/(a-b);
    g = B(2)+(A(2)-B(2))*(x-b)/(a-b);
    b = B(3)+(A(3)-B(3))*(x-b)/(a-b);
    %return r,g,b values
    color = [r g b];
end