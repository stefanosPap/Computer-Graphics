function Y = triPaintFlat(X,V,C)
%initialization
    xmin = zeros(1,3);
    xmax = zeros(1,3);
    ymin = zeros(1,3);
    ymax = zeros(1,3);
    %compute color for each triangle 
    r = (C(1,1)+C(2,1)+C(3,1))/3;
    g = (C(1,2)+C(2,2)+C(3,2))/3;
    b = (C(1,3)+C(2,3)+C(3,3))/3;
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
 edge = zeros(2,1);%edge has two numbers 0 to 2 which indicates  
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
    if active_points(2,1) < active_points(1,1)
        [active_points(2,:) , active_points(1,:)] = deal(active_points(1,:),active_points(2,:));
        [edge(1),edge(2)] = deal (edge(2),edge(1));
        [m1,m2] = deal(m2,m1);
    end
    cross_count = 0;
    %scan the image 
    for x=1:1200
         %if active point found increase cross_count 
        if x == active_points(1) ||  x == active_points(2)
            cross_count = cross_count +1;     
        end 
        %if cross_count is odd number then x is located between active
        %points so this point is painted
        if mod(cross_count,2) == 1
          %give r,g,b values  
          X(y,x,1) = r;
          X(y,x,2) = g;
          X(y,x,3) = b;  
        end
        %if x surpass the second active point we break the loop 
        %or the second point is Inf 
        %this case exists when m1=0 or m2=0 so we break the loop 
        if x>active_points(2,1) || active_points(2,1) == Inf || active_points(1,1) == Inf
             break;
        end
    end
    count=2;
    %track active edges
    %when y reaches minimum value of ymax array then we should change active sides
    if y+1 == min(ymax(:)) 
     ok = 0;
     for i=1:3%access array in order to find this value 
         index_new = 3;
         if array(i,2) == min(ymax(:)) || array(i,4) == min(ymax(:))
            %if found,decrease count by 1 
             if i == edge(1)+1;
                count=count-1;
                index = 1;%keep the index in the array
            elseif i == edge(2)+1;
                count=count-1;
                index = 2;%keep the index in the array
            else
                index_new = i;
                ok=1;
             end    
            %if count == 1 && ok == 1 this means that  
            %found both sides in array so we change the slope  
            if count == 1 && ok == 1
                edge(index) = index_new - 1;
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
