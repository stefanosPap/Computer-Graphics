function Y = shadeGouraud(p, Vn, Pc, Cam, S, ka, kd, ks, ncoeff, Ia, I0, X)
    
    for i = 1:3
        Iam = ambientLight(ka(:,i),Ia);
        Idif = diffuseLight(Pc, Vn(:,i), kd(:,i),S,I0);
        if Idif < 0
            Idif = 0;
        end
        Isp = specularLight(Pc, Vn(:,i), Cam, ks(:,i), ncoeff, S, I0);
        C(i,:) = Iam + Idif + Isp;
    end
    xmin = zeros(1,3);
    xmax = zeros(1,3);
    ymin = zeros(1,3);
    ymax = zeros(1,3);
    V = p';
    
    %compute xmin,xmax,ymin,ymax for each side of the triangle
    for i=1:3 %case of edges 1 and 2
        if i ~= 3
            xmin(i) = min(V(i:i+1,1));
            xmax(i) = max(V(i:i+1,1));
            ymin(i) = min(V(i:i+1,2));
            ymax(i) = max(V(i:i+1,2));
        else %case of edge 3
            xmin(i) = min(V(i,1),V(i-2,1));
            xmax(i) = max(V(i,1),V(i-2,1));
            ymin(i) = min(V(i,2),V(i-2,2));
            ymax(i) = max(V(i,2),V(i-2,2));
        end
    end
    
    countYmax = 0;
    countYmin = 0;
    for i =1:3
        if ymax(i) == ymax(1)
            countYmax = countYmax + 1;%countYmax is used to examine if there is
        end                           %a horizontal line at the top of the triangle
        if ymin(i) == ymin(1)
            countYmin = countYmin + 1;%countYmax is used to examine if there is
        end                           %a horizontal line at the bottom of the triangle
    end
    
    y_minimum = min(ymin(:)); %find y_min from the whole triangle 
    y_maximum = max(ymax(:)); %find y_max from the whole triangle
 
    activeEdges = zeros(2,1); %activeEdges has two numbers 1 to 3 which indicates  
                              %which side is active in every step
                             
    m1 = (V(2,2) - V(1,2))/(V(2,1)-V(1,1)); %m1,m2,m3 are the splopes of each edge.
    m2 = (V(3,2) - V(2,2))/(V(3,1)-V(2,1));
    m3 = (V(1,2) - V(3,2))/(V(1,1)-V(3,1));
    
    %array contains the information of each edge, x1,y1 and x2,y2 are coordinates of the two vertices and m is the slope of each side.
    array(1) = struct('x1',V(1,1),'y1',V(1,2),'x2',V(2,1),'y2',V(2,2),'m',m1);
    array(2) = struct('x1',V(2,1),'y1',V(2,2),'x2',V(3,1),'y2',V(3,2),'m',m2);
    array(3) = struct('x1',V(3,1),'y1',V(3,2),'x2',V(1,1),'y2',V(1,2),'m',m3);
    
    %activePoints contains the information of each active point, x1,y1 and x2,y2 are two vertices and m1,m2 are the slope of each side.
    activePoints = struct('x1',0,'y1',0,'m1',0,'x2',0,'y2',0,'m2',0);
    
    %compute active points for scanline ymin
    k = 1;
    for i=1:3
        if array(i).y1==y_minimum && array(i).m ~= 0 %case of edges 1 and 2
            activePoints.x1 = array(i).x1;
            activePoints.y1 = array(i).y1;
            activePoints.m1 = array(i).m;
            activeEdges(k) = i;
            k = k + 1;
        elseif array(i).y2==y_minimum && array(i).m ~= 0 %case of edge 3
            activePoints.x2 = array(i).x2;
            activePoints.y2 = array(i).y2;
            activePoints.m2 = array(i).m;
            activeEdges(k) = i;
            k = k + 1;
        end
    end
 
    countX = 0;
    countM = 0;
    countY = 0;
    for i = 1:3 
        if V(i,1) == V(1,1)
            countX = countX + 1; %examine if vertices are in the same vertical line (parallelly to Y axis)
        end
        if array(i).m == array(1).m && array(i).m ~= 0
            countM = countM + 1; %examine if vertices are in the same line (have the same slope)
        end
        if V(i,2) == V(1,2)
            countY = countY + 1; %examine if vertices are in the same horizontal line (parallelly to X axis)
        end
    end
%% SCANLINE ALGORITHM
    
    if countX ~= 3 && countY ~= 3 && countM ~= 3 && countM ~= 2
        
        %general case of scanline algorithm where the vertices don't belong in the same line 
        for y=y_minimum:y_maximum 
        
            %sort active points by increasing x
            if activePoints.x2 < activePoints.x1
                [activePoints.x2 , activePoints.x1] = deal(activePoints.x1,activePoints.x2);
                [activePoints.y2 , activePoints.y1] = deal(activePoints.y1,activePoints.y2);
                [activePoints.m2 , activePoints.m1] = deal(activePoints.m1,activePoints.m2);
            end
            set = 0; %flag that used to examine if the first active point is surpassed
            
            %each line is scanned twice
            %first time in order to compute edge's color and second time
            %in order to compute inner triangle's color
            %--- *FIRST TIME* ---
            %scan the image
            for x = round(activePoints.x1)-1:1200
                
                %if active point found 
                if x >= activePoints.x1 && set == 0
                    for i=1:3 %find which is the active point in array 
                        if activePoints.m1 == array(i).m 
                            found = i;
                        end
                    end
                    
                    %find vertices' color
                    if found ~= 3 %case where active edges are 1 or 2 
                         r1 = C(found,1);
                         r2 = C(found+1,1);
                         g1 = C(found,2);
                         g2 = C(found+1,2);
                         b1 = C(found,3);
                         b2 = C(found+1,3);                     
                    else %case where active edge is 3
                         r1 = C(found,1);
                         r2 = C(found-2,1);
                         g1 = C(found,2);
                         g2 = C(found-2,2);
                         b1 = C(found,3);
                         b2 = C(found-2,3);                        
                    end
                    
                    %compute edges' color using linear interpolation 
                    vectorX = [x y]; %current point
                    vectorX1 = [array(found).x1 array(found).y1]; %first vertex
                    vectorX2 = [array(found).x2 array(found).y2]; %second vertex
                    A(1) = r1 + (r2 - r1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    A(2) = g1 + (g2 - g1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    A(3) = b1 + (b2 - b1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    %paint the points 
                    X(y,x,1) = A(1);
                    X(y,x,2) = A(2);
                    X(y,x,3) = A(3);
                    set = 1;                    
                elseif abs(x - activePoints.x2) < 1
                    for i=1:3 %if second active point found 
                        if activePoints.m2 == array(i).m 
                            found = i; %find which is the active point in array
                        end
                    end
                    
                    %find vertices' color
                    if found ~= 3 %case where active edges are 1 or 2 
                         r1 = C(found,1);
                         r2 = C(found+1,1);
                         g1 = C(found,2);
                         g2 = C(found+1,2);
                         b1 = C(found,3);
                         b2 = C(found+1,3);                     
                    else %case where active edge is 3 
                         r1 = C(found,1);
                         r2 = C(found-2,1);
                         g1 = C(found,2);
                         g2 = C(found-2,2);
                         b1 = C(found,3);
                         b2 = C(found-2,3);                        
                    end
                   
                    %compute edges' color using linear interpolation 
                    vectorX = [x y]; %current point
                    vectorX1 = [array(found).x1 array(found).y1]; %first vertex
                    vectorX2 = [array(found).x2 array(found).y2]; %second vertex
                    B(1) = r1 + (r2 - r1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1); %apply linear interpolation
                    B(2) = g1 + (g2 - g1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    B(3) = b1 + (b2 - b1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);                    
                    
                    %paint the points 
                    X(y,x,1) = B(1);
                    X(y,x,2) = B(2);
                    X(y,x,3) = B(3);                                       
                end

                %if x surpass the second active point we break the loop 
                if x > activePoints.x2
                    break;
                end
            end
            
            set = 0;
            cross_count = 0;
            
            %--- *SECOND TIME* ---
            %scan the image
            for x = round(activePoints.x1)-1:1200
                
                %if active point found increase cross_count 
                if x >= activePoints.x1 && set == 0
                    %set the flag in order to know that first active point haw surpassed
                    set = 1; 
                    cross_count = cross_count +1;
                end
                if x >= activePoints.x2 
                    cross_count = cross_count +1;
                end
                
                %if cross_count is odd number then x is located between
                %active points so this point is painted
                if mod(cross_count,2) == 1
                    a = activePoints.x1;
                    b = activePoints.x2;
                    color = colorInterp(A,B,a,b,x); %call function colorInterp to calculate the color 
                    r = color(1); %give r,g,b values
                    g = color(2);
                    b = color(3);
                    X(y,x,1) = r;
                    X(y,x,2) = g;
                    X(y,x,3) = b;
                end
                
                %if x surpass the second active point we break the loop 
                if x >= activePoints.x2
                    break;
                end
            end
            
            %track active edges
            %when y reaches minimum value of ymax array and there is not a horizontal side
            %we should change active edges
            if y+1 == max(ymin(:)) && countYmax ~= 3 && countYmin ~= 3
                
                k = 1;
                index = zeros(2,1);
                newActiveEdges = zeros(2,1);  %store here the new active edges
                for i=1:3 %index contains new active edges 
                    if array(i).y1 == max(ymin(:)) || array(i).y2 == max(ymin(:))
                    index(k) = i; %index contains the location (index) of new active edge in array
                    k = k + 1;
                    end
                end
                
                k = 1;
                hist = histcounts([activeEdges; index]);%hist contains the frequency of each element in 
                                                        %table -> [activeEdges; index] which has the old and new active edges 
                for i = 1:length(hist)                  %so the element that has value 2 is the element that appears both 
                    if hist(i) == 1                     %in old and new active edges so it must be replaced.
                        newActiveEdges(k) = i; %keep only edges with hist == 1 
                        k = k + 1;
                    end
                end
                
                flag = ones(3,1);
                for i = 1:3 %find the edge that is common to old and new active edges
                            %this edge's flag value will remain 1 after this for loop  
                    if array(i).m == array(activeEdges(1)).m || array(i).m == array(activeEdges(2)).m
                        flag(i) = 0;
                    end
                end
                
                for i = 1:3 %the element that has value 2 is the element that must be replaced 
                    if hist(i) == 2
                        newIndex = i;
                    end
                end
                
                %find from array the information of the new activePoints
                %after the change of active edges
                for i =1:3
                    
                    if flag(i) ~= 0
                        if array(i).y1 == max(ymin(:))
                            yNew = array(i).y1;
                            xNew = array(i).x1;
                        elseif array(i).y2 == max(ymin(:))
                            yNew = array(i).y2;
                            xNew = array(i).x2;
                        end
                        m = array(i).m;
                    end
                    if i == newIndex
                        mPrev = array(i).m; %this will be the edge that will be replaced
                    end                   %mPrev operates like the key to find the information 
                                          %of active points that must be replaced
                end
                
                %replace the iformation in activePoints
                if activePoints.m1 == mPrev  
                    activePoints.x1 = xNew;
                    activePoints.y1 = yNew;
                    activePoints.m1 = m;
                    activePoints.y2 = activePoints.y2 + 1;
                    activePoints.x2 = activePoints.x2 + 1/activePoints.m2;
                elseif activePoints.m2 == mPrev
                    activePoints.x2 = xNew;
                    activePoints.y2 = yNew;
                    activePoints.m2 = m;
                    activePoints.y1 = activePoints.y1 + 1;
                    activePoints.x1 = activePoints.x1 + 1/activePoints.m1;
                end
                
                %after all calculations replace the new active edges
                activeEdges = newActiveEdges;
    
            else %this is the case where we don't change active edges 
                 %if active edges don't change y1 and y2 values in activePoints icrease by 1 
                 %and x value by 1/activePoints.m1 (1/m1) and 1/activePoints.m2 (1/m2) accordingly
                 activePoints.y1 = activePoints.y1 + 1;
                 activePoints.x1 = activePoints.x1 + 1/activePoints.m1;
                 activePoints.y2 = activePoints.y2 + 1;
                 activePoints.x2 = activePoints.x2 + 1/activePoints.m2;
            end
        end

    else %this case happens when vertices belong to the same line
        
        if countY == 3 %if vertices are parallel to x axis  
            [maxX,maxIndex] = max(V(:,1)); %find maximum and minimum value of x
            [minX,minIndex] = min(V(:,1));
            
            %compute color of maximum and minimun vertex in order to use it later for linear interpolation  
            r1 = C(maxIndex,1);
            g1 = C(maxIndex,2);
            b1 = C(maxIndex,3);
            
            r2 = C(minIndex,1);
            g2 = C(minIndex,2);
            b2 = C(minIndex,3);
             
            for x = minX:maxX %scan image in x axis from min to max value of x and paint these points
                
                %compute color using linear interpolation
                r = r1 + (r2 - r1) * norm(x - maxX) / norm(minX - maxX);
                g = g1 + (g2 - g1) * norm(x - maxX) / norm(minX - maxX);
                b = b1 + (b2 - b1) * norm(x - maxX) / norm(minX - maxX);
                
                X(V(1,2),x,1) = r;
                X(V(1,2),x,2) = g;
                X(V(1,2),x,3) = b;
            end
        end
        
        if countX == 3 %if vertices are parallel to y axis
            [maxY,maxIndex] = max(V(:,2)); %find maximum and minimum value of y
            [minY,minIndex] = min(V(:,2));
            
            %compute color of maximum and minimun vertex in order to use it later for linear interpolation
            r1 = C(maxIndex,1);
            g1 = C(maxIndex,2);
            b1 = C(maxIndex,3);
            
            r2 = C(minIndex,1);
            g2 = C(minIndex,2);
            b2 = C(minIndex,3);
            
            for y = minY:maxY %scan image in y axis from min to max value of y and paint these points
                
                %compute color using linear interpolation
                r = r1 + (r2 - r1) * norm(y - maxY) / norm(minY - maxY);
                g = g1 + (g2 - g1) * norm(y - maxY) / norm(minY - maxY);
                b = b1 + (b2 - b1) * norm(y - maxY) / norm(minY - maxY);
                         
                X(y,V(1,1),1) = r;
                X(y,V(1,1),2) = g;
                X(y,V(1,1),3) = b;
            end
        end
        
        if countM == 3 %if vertices are in the same line (have the same slope)
            [maxY,maxIndex] = max(V(:,2));%find maximum and minimum value of y
            [minY,minIndex] = min(V(:,2));
            
            %compute color of maximum and minimun vertex in order to use it later for linear interpolation
            r1 = C(maxIndex,1);
            g1 = C(maxIndex,2);
            b1 = C(maxIndex,3);
            
            r2 = C(minIndex,1);
            g2 = C(minIndex,2);
            b2 = C(minIndex,3);            
            
            startX = V(minIndex,1);
            x = startX; %x is the rounded value of xMod 
            xMod = startX; %start value of x
            
            for y = minY:maxY %scan image in y axis from min to max value of y 
                
                %compute color using linear interpolation
                vectorX = [x y]; %current point
                vectorX1 = [V(maxIndex,1) V(maxIndex,2)]; %max vertex 
                vectorX2 = [V(minIndex,1) V(minIndex,2)]; %min vertex
                r = r1 + (r2 - r1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                g = g1 + (g2 - g1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                b = b1 + (b2 - b1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                                     
                X(y,x,1) = r; %and increase x by 1/m and paint these points
                X(y,x,2) = g;
                X(y,x,3) = b;
                xMod = xMod + 1/array(1).m;
                x = round(xMod); %round x because pixels must be integers 
            end
        end
    end
    
    %return image
    Y = X;
    
end