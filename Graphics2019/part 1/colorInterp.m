function color = colorInterp(A,B,a,b,x)
    %A=[r1 g1 b1]
    %B=[r2 g2 b2]
    %compute r,g,b values with linear interpolation
    r = A(1)+(B(1)-A(1))*(b-x)/(b-a);
    g = A(2)+(B(2)-A(2))*(b-x)/(b-a);
    b = A(3)+(B(3)-A(3))*(b-x)/(b-a);
    %return r,g,b values
    color = [r g b];
end