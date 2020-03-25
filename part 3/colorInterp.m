function color = colorInterp(A,B,a,b,x)
%% VARIABLES  
    %A(3x1): first active point's color 
    %B(3x1): second active point's color
    %a: coordinates of first active point
    %b: coordinates of second active point
    %x: coordinates of current point that will be painted
%%  LINEAR INTERPOLATION  
    %compute r,g,b values with linear interpolation
    r = B(1)+(A(1)-B(1))*(x-b)/(a-b);
    g = B(2)+(A(2)-B(2))*(x-b)/(a-b);
    b = B(3)+(A(3)-B(3))*(x-b)/(a-b);
%% RETURN    
    %return r,g,b values
    color = [r g b];
end