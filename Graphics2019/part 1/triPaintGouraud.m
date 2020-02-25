function Y =triPaintGouraud(X,V,C)
    %initialization
    xmin = zeros(1,3);
    xmax = zeros(1,3);
    ymin = zeros(1,3);
    ymax = zeros(1,3);
    %compute xmin,xmax,ymin,ymax for each side of the triangle
    for i=0:1:2
        if i ~= 2
            xmin(i+1) = min(V(i+1:i+2,1));
            xmax(i+1) = max(V(i+1:i+2,1));
            ymin(i+1) = min(V(i+1:i+2,2));
            ymax(i+1) = max(V(i+1:i+2,2));
        else 
            xmin(i+1) = min(V(i+1,1),V(i-1,1));
            xmax(i+1) = max(V(i+1,1),V(i-1,1));
            ymin(i+1) = min(V(i+1,2),V(i-1,2));
            ymax(i+1) = max(V(i+1,2),V(i-1,2));
        end
    end
    y_minimum = min(ymin(:));%find y_min from the whole triangle 
    y_maximum = max(ymax(:));%find y_max from the whole triangle
    %compute and store active edges for ymin scanline
    k = 1;
    edge = zeros(2,1);
    %edge has two numbers 0 to 2 which indicates  
    %which side is active in every step 
    %array has the coordinates of sides' peaks 
    array = [V(1,1) V(1,2) V(2,1) V(2,2);V(2,1) V(2,2) V(3,1) V(3,2);V(3,1) V(3,2) V(1,1) V(1,2)];
    for i=1:3
        if array(i,2)==y_minimum || array(i,4)==y_minimum
            edge(k) = i-1;
            k = k + 1;
        end
    end
    %compute the slope of each active side
    m1 = (array(edge(1)+1,4)-array(edge(1)+1,2))/(array(edge(1)+1,3)-array(edge(1)+1,1));
    m2 = (array(edge(2)+1,4)-array(edge(2)+1,2))/(array(edge(2)+1,3)-array(edge(2)+1,1));
    %compute active points for scanline
    if array(edge(1)+1,2) == y_minimum
        x_minimum = array(edge(1)+1,1);
    elseif array(edge(1)+1,4) == y_minimum
        x_minimum = array(edge(1)+1,3);
    end
    active_points = [x_minimum y_minimum;x_minimum y_minimum];
    %apply scanline algorithm
    for y=y_minimum:y_maximum
        %sort active points by increasing x
        if active_points(2) < active_points(1)
            [active_points(2,:) , active_points(1,:)] = deal(active_points(1,:),active_points(2,:));
            [edge(1),edge(2)] = deal (edge(2),edge(1));
            [m1,m2] = deal(m2,m1);
        end
        %scan the image
        cross_count = 0;
        computed = 0;
        for x=1:1200
            if x ==1 && computed == 0
                computed = 1;
                %compute the color of sides' peaks 
                    for i=1:3
                            if V(i,1) == array(edge(1)+1,1) && V(i,2) == array(edge(1)+1,2) 
                                r1 = C(i,1);
                                g1 = C(i,2);
                                b1 = C(i,3);
                            end
                            if V(i,1) == array(edge(1)+1,3) && V(i,2) == array(edge(1)+1,4)
                                 r2 = C(i,1);
                                 g2 = C(i,2);
                                 b2 = C(i,3);
                            end
                    end
                    %linear interpolation for the first active point 
                    A(1) = r1 + (r2 - r1)*(x-array(edge(1)+1,1))/(array(edge(1)+1,3)-array(edge(1)+1,1));
                    A(2) = g1 + (g2 - g1)*(x-array(edge(1)+1,1))/(array(edge(1)+1,3)-array(edge(1)+1,1));
                    A(3) = b1 + (b2 - b1)*(x-array(edge(1)+1,1))/(array(edge(1)+1,3)-array(edge(1)+1,1));
                    ra = A(1);
                    ga = A(2);
                    ba = A(3);
                    X(y,x,1) = ra;
                    X(y,x,2) = ga;
                    X(y,x,3) = ba;  
                    a = active_points(1,1);
                    %linear interpolation for the first active point
                    for i=1:3
                            if V(i,1) == array(edge(2)+1,1) && V(i,2) == array(edge(2)+1,2) 
                                r1 = C(i,1);
                                g1 = C(i,2);
                                b1 = C(i,3);
                            end
                            if V(i,1) == array(edge(2)+1,3) && V(i,2) == array(edge(2)+1,4) 
                                 r2 = C(i,1);
                                 g2 = C(i,2);
                                 b2 = C(i,3);
                            end
                    end
                    B(1) = r1 + (r2 - r1)*(x-array(edge(2)+1,1))/(array(edge(2)+1,3)-array(edge(2)+1,1));
                    B(2) = g1 + (g2 - g1)*(x-array(edge(2)+1,1))/(array(edge(2)+1,3)-array(edge(2)+1,1));
                    B(3) = b1 + (b2 - b1)*(x-array(edge(2)+1,1))/(array(edge(2)+1,3)-array(edge(2)+1,1));
                    rb = B(1);
                    gb = B(2);
                    bb = B(3);
                    X(y,x,1) = rb;
                    X(y,x,2) = gb;
                    X(y,x,3) = bb;  
                    b = active_points(2,1);
            end
                %if active point found increase cross_count
                if x == active_points(1,1)
                    cross_count = cross_count +1; 
                elseif  x == active_points(2,1)
                     cross_count = cross_count +1;  
                end 
                %if cross_count is odd number then x is located between active
                %points so this point is painted
                if mod(cross_count,2) == 1
                    %in case x is not an active point we compute r,g,b 
                    %values by calling function colorInterp
                    if x~=active_points(1,1) && x~=active_points(2,1)
                    color = colorInterp(A,B,a,b,x);
                    r = color(1);
                    g = color(2);
                    b = color(3);
                    X(y,x,1) = r;
                    X(y,x,2) = g;
                    X(y,x,3) = b;  
                    end   
                end
                %if x surpass the second active point we break the loop 
                %or the second point is Inf 
                %this case exists when m1=0 or m2=0 so we break the loop
                if x>active_points(2,1) || active_points(2,1) == Inf
                    break;
                end
        end
        count=2;
    %track active edges
    %when y reaches minimum value of ymax array then we should change active sides
    if y+1 == min(ymax(:)) 
        ok = 0;
        for i=1:3%access array in order to find this value 
         index1 = 3;
         if array(i,2) == min(ymax(:)) || array(i,4) == min(ymax(:))
             %if found,decrease count by 1 
             if i == edge(1)+1;
                count=count-1;
                index = 1;%keep the index in the array
                
            elseif i == edge(2)+1;
                count=count-1;
                index = 2;%keep the index in the array
            else
                index1 = i;
                ok=1;
            end
            %if count == 1 && ok == 1 this means that  
            %found both sides in array so we change the slope
            if count == 1 && ok == 1
                edge(index) = index1 - 1;
                %compute slopes
                %we use fix function in order to keep only decimal part of
                %x
                 m1 = (array(edge(1)+1,4)-array(edge(1)+1,2))/(array(edge(1)+1,3)-array(edge(1)+1,1));
                 m2 = (array(edge(2)+1,4)-array(edge(2)+1,2))/(array(edge(2)+1,3)-array(edge(2)+1,1));
                  %update active points
                 active_points = [fix(active_points(1,1)+1/m1) y+1;fix(active_points(2,1)+1/m2) y+1];
            end
           
         end
        end
        
    else%this case is when we don't change active side so we update active
     %points 
        active_points = [fix(active_points(1,1)+1/m1) y+1;fix(active_points(2,1)+1/m2) y+1];
    end
    
    end
    %return image
    Y = X;
end