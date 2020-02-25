clear
V = fix(1000*[rand rand;rand rand;rand rand]);
C = [rand rand rand;rand rand rand;rand rand rand];
%find xmin,xmax,ymin,ymax for each edge of the triangle 
xmin = zeros(1,3);
xmax = zeros(1,3);
ymin = zeros(1,3);
ymax = zeros(1,3);
X = ones(1200,1200,3);
image=ones(1200,1200,3);

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
    if (array(i,2)==y_minimum && array(i,4)~=y_minimum) || (array(i,2)~=y_minimum && array(i,4)==y_minimum)
        edge(k) = i-1;
        k = k + 1;
    end
 end
hold on 
figure(1);
for i=1:3
    plot([V(1,1) V(2,1)] ,[V(1,2) V(2,2)]);
    plot([V(2,1) V(3,1)] ,[V(2,2) V(3,2)]);
    plot([V(3,1) V(1,1)] ,[V(3,2) V(1,2)]);
end

     
 m1 = (array(edge(1)+1,4)-array(edge(1)+1,2))/(array(edge(1)+1,3)-array(edge(1)+1,1));
 m2 = (array(edge(2)+1,4)-array(edge(2)+1,2))/(array(edge(2)+1,3)-array(edge(2)+1,1));
if m1~=0 && m2~=0 
 if array(edge(1)+1,2) == y_minimum
        x_minimum = array(edge(1)+1,1);
        active_points = [x_minimum y_minimum;x_minimum y_minimum];
    elseif array(edge(1)+1,4) == y_minimum
        x_minimum = array(edge(1)+1,3);
        active_points = [x_minimum y_minimum;x_minimum y_minimum];
 end
%  for i=1:3
%  if (array(i,2)==y_minimum && array(i,4)==y_minimum) 
%      active_points = [array(i,1) array(i,2);array(i,3) array(i,4)];
%  
%      
%  end
% end
    %  if m1 == 0 
%     active_points = [array(edge(1)+1,1) array(edge(1)+1,2);array(edge(1)+1,3) array(edge(1)+1,4)];
%  elseif m2 ==0
%      active_points = [array(edge(2)+1,1) array(edge(2)+1,2);array(edge(2)+1,3) array(edge(2)+1,4)];
%  b1 = y_active_min1-x_active_min1*m1;
%  b2 = y_active_min2-x_active_min2*m2;
% %  hold on 
%  
%  t=x_active_min1:x_active_max1;
%  y1 = m1*t+b1;
%  x1 = (y_minimum - b1)/m1;
% %  plot(y1,t);
%  t=x_active_min2:x_active_max2;
%  y2 = m2*t+b2;
%  x2 = (y_minimum - b2)/m2;
% %  plot(y2,t);
    


for y=y_minimum:y_maximum
    y
    change = 0;
    if active_points(2) < active_points(1)
        [active_points(2,:) , active_points(1,:)] = deal(active_points(1,:),active_points(2,:));
        [edge(1),edge(2)] = deal (edge(2),edge(1));
        [m1,m2] = deal(m2,m1);
    end
    
    cross_count = 0;
    change1 = 0;
    computed = 1;
    for x=1:active_points(2,1)+1
            if x ==1 && computed == 0
                computed = 1;
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
        if x == active_points(1,1)
                    cross_count = cross_count +1; 
        elseif  x == active_points(2,1)
                     cross_count = cross_count +1;  
        end 
        if mod(cross_count,2) == 1
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
    end

    count=2;
 if y+1 == min(ymax(:)) %|| y == min(ymax(:))
     ok = 0;
     for i=1:3
         if array(i,2) == min(ymax(:)) || array(i,4) == min(ymax(:))
            if i == edge(1)+1;
                count=count-1;
                index = 1;
                m=m1;
            elseif i == edge(2)+1;
                count=count-1;
                index = 2;
                m=m2;
            else
                index1 = i;
                ok=1;
                
            end
             if count == 0
                 active_points = [active_points(1,1)+ 1/m1 y+1;active_points(2,1)+1/m2 y+1];
                 break;
             end
            if count == 1  && ok==1;
                edge(index) = index1 - 1;
                 m1 = (array(edge(1)+1,4)-array(edge(1)+1,2))/(array(edge(1)+1,3)-array(edge(1)+1,1));
                 m2 = (array(edge(2)+1,4)-array(edge(2)+1,2))/(array(edge(2)+1,3)-array(edge(2)+1,1));
                 active_points = [fix(active_points(1,1)+1/m1) y+1;fix(active_points(2,1)+1/m2) y+1];
            end
            
         end
     end

else
    active_points = [fix(active_points(1,1)+1/m1) y+1;fix(active_points(2,1)+1/m2) y+1];
end
end
elseif m1 == 0 || m2 == 0
  for i=1:3
    if (array(i,2)==y_minimum && array(i,4)==y_minimum) 
      active_points = [array(i,1) array(i,2);array(i,3) array(i,4)];      
      break;
    end
  end
    
    for y=y_minimum:y_maximum
        y
        change = 0;
        if active_points(2) < active_points(1)
            [active_points(2,:) , active_points(1,:)] = deal(active_points(1,:),active_points(2,:));
            [edge(1),edge(2)] = deal (edge(2),edge(1));
            [m1,m2] = deal(m2,m1);
        end
    
        cross_count = 0;
        change1 = 0;
        for x=1:active_points(2,1)+1
         
            if x >= active_points(1,1) && change1 == 0
                change1 = 1;
                cross_count = cross_count +1;
            %%goraud
            
            elseif  x >= active_points(2,1) && change1 == 1
                change1 = 2;
                cross_count = cross_count +1;
            end 
            if mod(cross_count,2) == 1
                X(y,x,1) = r;
                X(y,x,2) = g;
                X(y,x,3) = b;  
          
          %%%goraud
          
            end
        end
       
        m = (active_points(2,2)-array(i,3))/(active_points(2,1)-array(i,1));
        if m==m1 || m==m2 
            m = (active_points(1,2)-array(i,3))/(active_points(1,1)-array(i,1));
        end
        if m1 == 0
            active_points = [active_points(1,1)+1/m y+1;active_points(2,1)+1/m2 y+1];
        elseif m2 == 0
            active_points = [active_points(1,1)+1/m1 y+1;active_points(2,1)+1/m y+1];
        end
    end
end
Y = X;

figure(2);
imshow(X);








