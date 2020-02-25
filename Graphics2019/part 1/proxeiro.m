clear
V = [10 4;2 6;5 9];
C = [0.1 0.2 0.3;0.2 0.3 0.5;0.7 0.8 0.3];
%find xmin,xmax,ymin,ymax for each edge of the triangle 
xmin = zeros(1,3);
xmax = zeros(1,3);
ymin = zeros(1,3);
ymax = zeros(1,3);
X = zeros(1200,1200,3);
image=zeros(1200,1200,3);
r = (C(1,1)+C(2,1)+C(3,1))/3;
g = (C(1,2)+C(2,2)+C(3,2))/3;
b = (C(1,3)+C(2,3)+C(3,3))/3;
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
 
 turn = 0;
 k = 1;
 edge = zeros(2,1);
 array = [V(1,1) V(1,2) V(2,1) V(2,2);V(2,1) V(2,2) V(3,1) V(3,2);V(3,1) V(3,2) V(1,1) V(1,2)]
 for i=1:3
    if array(i,2)==y_minimum || array(i,4)==y_minimum
        edge(k) = i-1;
        k = k + 1;
    end
 end
 edge = sort(edge);
 for i=1:3
    if (ymin(i)==y_minimum && turn ~=1)
        turn = 1;
        y_active_min1 = ymin(i);
        x_active_min1 = xmin(i);
        y_active_max1 = ymax(i);
        x_active_max1 = xmax(i);
    elseif (ymin(i) == y_minimum) 
        y_active_min2 = ymin(i);
        x_active_min2 = xmin(i);
        y_active_max2 = ymax(i);
        x_active_max2 = xmax(i);
    end
 end
 active_edges = [x_active_min1 y_active_min1;
                 x_active_min2 y_active_min2;
                 x_active_max1 y_active_max1;
                 x_active_max2 y_active_max2];
     
 m1 = (y_active_max1 - y_active_min1)/(x_active_max1 - x_active_min1);
 m2 = (y_active_max2 - y_active_min2)/(x_active_max2 - x_active_min2);

 b1 = y_active_min1-x_active_min1*m1;
 b2 = y_active_min2-x_active_min2*m2;
%  hold on 
 
 t=x_active_min1:x_active_max1;
 y1 = m1*t+b1;
 x1 = (y_minimum - b1)/m1;
%  plot(y1,t);
 t=x_active_min2:x_active_max2;
 y2 = m2*t+b2;
 x2 = (y_minimum - b2)/m2;
%  plot(y2,t);
active_points = [x_active_min1 y_minimum;x_active_min2 y_minimum];
for y=y_minimum:y_maximum
    if active_points(2) < active_points(1)
        [active_points(2,:) , active_points(1,:)] = deal(active_points(1,:),active_points(2,:));
        [active_edges(2,:) , active_edges(1,:)] = deal(active_edges(1,:) , active_edges(2,:));
        [active_edges(4,:) , active_edges(3,:)] = deal(active_edges(3,:) , active_edges(4,:));
    end
    
    cross_count = 0;
   
    for x=1:1200
        if x == active_points(1)
            cross_count = cross_count +1;
            %%goraud
            
        elseif  x == active_points(2)
            cross_count = cross_count +1;
        end 
        if mod(cross_count,2) == 1
          X(x,y,1) = r;
          X(x,y,2) = g;
          X(x,y,3) = b;  
          
          %%%goraud
          
        end
    end
if y+1 == min(ymax(:))
      
     if y+1 == y_active_max1
        x = x_active_max1;
        active_edges = [x y+1;
                     x_active_min2 y_active_min2;
                     x_active_max2 y_active_max2;
                     x_active_max2 y_active_max2];
                     m = (active_edges(3,2) - active_edges(1,2))/(active_edges(3,1) - active_edges(1,1));
                     b = active_edges(1,2)-active_edges(1,1)*m;
                    active_points = [active_points(1,1)+1/m y+1;active_points(2,1)+1/m2 y+1];
                     m1=m;
     elseif y+1 == y_active_max2
        x = x_active_max2;
        active_edges = [x_active_min1 y_active_min1;
                     x y+1;
                     x_active_max1 y_active_max1;
                     x_active_max1 y_active_max1];
                     m = (active_edges(3,2) - active_edges(1,2))/(active_edges(3,1) - active_edges(1,1));
                     b = active_edges(1,2)-active_edges(1,1)*m;
                    active_points = [active_points(1,1)+1/m1 y+1;active_points(2,1)+1/m y+1];
                    m2=m;
     end
     
    else
     active_points = [active_points(1,1)+1/m1 y+1;active_points(2,1)+1/m2 y+1];
end
end
Y = X;









