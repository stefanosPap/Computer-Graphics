function Y =triPaintGouraud(X,V,C)
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
    for i=1:3
        if i ~= 3
            xmin(i) = min(V(i:i+1,1));
            xmax(i) = max(V(i:i+1,1));
            ymin(i) = min(V(i:i+1,2));
            ymax(i) = max(V(i:i+1,2));
        else 
            xmin(i) = min(V(i,1),V(i-2,1));
            xmax(i) = max(V(i,1),V(i-2,1));
            ymin(i) = min(V(i,2),V(i-2,2));
            ymax(i) = max(V(i,2),V(i-2,2));
        end
    end
    y_minimum = min(ymin(:));%find y_min from the whole triangle 
    y_maximum = max(ymax(:));%find y_max from the whole triangle
    %compute and store active edges for ymin scanline
 
    k = 1;
    activeEdges = zeros(2,1);%edge has two numbers 0 to 2 which indicates  
    %which side is active in every step 
    %array has the coordinates of sides' peaks
    m1 = (V(2,2) - V(1,2))/(V(2,1)-V(1,1));
    m2 = (V(3,2) - V(2,2))/(V(3,1)-V(2,1));
    m3 = (V(1,2) - V(3,2))/(V(1,1)-V(3,1));
 
    array(1) = struct('x1',V(1,1),'y1',V(1,2),'x2',V(2,1),'y2',V(2,2),'m',m1);
    array(2) = struct('x1',V(2,1),'y1',V(2,2),'x2',V(3,1),'y2',V(3,2),'m',m2);
    array(3) = struct('x1',V(3,1),'y1',V(3,2),'x2',V(1,1),'y2',V(1,2),'m',m3);
    activePoints = struct('x1',0,'y1',0,'m1',0,'x2',0,'y2',0,'m2',0);
    
    for i=1:3
        if array(i).y1==y_minimum && array(i).m ~= 0 
            activePoints.x1 = array(i).x1;
            activePoints.y1 = array(i).y1;
            activePoints.m1 = array(i).m;
            activeEdges(k) = i;
            k = k + 1;
        elseif array(i).y2==y_minimum && array(i).m ~= 0
            activePoints.x2 = array(i).x2;
            activePoints.y2 = array(i).y2;
            activePoints.m2 = array(i).m;
            activeEdges(k) = i;
            k = k + 1;
        end
    end
    %compute the slope of each active side

    %compute active points for scanline 
    countX = 0;
    countM = 0;
    countY = 0;
    for i = 1:3 
        if V(i,1) == V(1,1)
            countX = countX + 1;
        end
        if array(i).m == array(1).m && array(i).m ~= 0
            countM = countM + 1;
        end
        if V(i,2) == V(1,2)
            countY = countY + 1;
        end
    end
    countYmax = 0;
    countYmin = 0;
    for i =1:3
        if ymax(i) == ymax(1)
            countYmax = countYmax + 1;
        end
        if ymin(i) == ymin(1)
            countYmin = countYmin + 1;
        end
    end

    %apply scanline algorithm
    if countX ~= 3 && countY ~= 3 && countM ~= 3 && countM ~= 2
        for y=y_minimum:y_maximum 
        %sort active points by increasing x
            if activePoints.x2 < activePoints.x1
                [activePoints.x2 , activePoints.x1] = deal(activePoints.x1,activePoints.x2);
                [activePoints.y2 , activePoints.y1] = deal(activePoints.y1,activePoints.y2);
                [activePoints.m2 , activePoints.m1] = deal(activePoints.m1,activePoints.m2);
            end
            
            %scan the image
            set = 0;
            for x=1:1200
                %if active point found increase cross_count 
                if x >= activePoints.x1 && set == 0
                    for i=1:3
                        if activePoints.m1 == array(i).m 
                            found = i;
                        end
                    end
                    if found ~= 3
                         r1 = C(found,1);
                         r2 = C(found+1,1);
                         g1 = C(found,2);
                         g2 = C(found+1,2);
                         b1 = C(found,3);
                         b2 = C(found+1,3);                     
                    else
                         r1 = C(found,1);
                         r2 = C(found-2,1);
                         g1 = C(found,2);
                         g2 = C(found-2,2);
                         b1 = C(found,3);
                         b2 = C(found-2,3);                        
                    end
                    if (array(found).x2-array(found).x1) ~= 0
                    vectorX = [x y];
                    vectorX1 = [array(found).x1 array(found).y1];
                    vectorX2 = [array(found).x2 array(found).y2];
                    A(1) = r1 + (r2 - r1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    A(2) = g1 + (g2 - g1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    A(3) = b1 + (b2 - b1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    else
                    A(1) = r1 + (r2 - r1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    A(2) = g1 + (g2 - g1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    A(3) = b1 + (b2 - b1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    end
                    X(y,x,1) = A(1);
                    X(y,x,2) = A(2);
                    X(y,x,3) = A(3);
                    set = 1; 
                    
                elseif abs(x - activePoints.x2) < 1
                    for i=1:3
                        if activePoints.m2 == array(i).m 
                            found = i;
                        end
                    end
                    if found ~= 3
                         r1 = C(found,1);
                         r2 = C(found+1,1);
                         g1 = C(found,2);
                         g2 = C(found+1,2);
                         b1 = C(found,3);
                         b2 = C(found+1,3);                     
                    else
                         r1 = C(found,1);
                         r2 = C(found-2,1);
                         g1 = C(found,2);
                         g2 = C(found-2,2);
                         b1 = C(found,3);
                         b2 = C(found-2,3);                        
                    end
                    if (array(found).x2-array(found).x1) ~= 0
                    vectorX = [x y];
                    vectorX1 = [array(found).x1 array(found).y1];
                    vectorX2 = [array(found).x2 array(found).y2];
                    B(1) = r1 + (r2 - r1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    B(2) = g1 + (g2 - g1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    B(3) = b1 + (b2 - b1)*norm(vectorX - vectorX1)/norm(vectorX2 - vectorX1);
                    else
                    B(1) = r1 + (r2 - r1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    B(2) = g1 + (g2 - g1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    B(3) = b1 + (b2 - b1)*norm(y - array(found).y1)/norm(array(found).y2 - array(found).y1);
                    end
                    X(y,x,1) = B(1);
                    X(y,x,2) = B(2);
                    X(y,x,3) = B(3);                   
                    
                end

                %if x surpass the second active point we break the loop 
                if x>activePoints.x2
                    break;
                end
            end
            cross_count = 0;
            %scan the image
            set = 0;
            for x=1:1200
                %if active point found increase cross_count 
                if x >= activePoints.x1 && set == 0
                    set = 1; 
                    cross_count = cross_count +1;
                end
                if x >= activePoints.x2 
                    cross_count = cross_count +1;
                end

                if mod(cross_count,2) == 1
                    a = activePoints.x1;
                    b = activePoints.x2;
                    color = colorInterp(A,B,a,b,x);
                     r = color(1);
                     g = color(2);
                     b = color(3);
                     X(y,x,1) = r;
                     X(y,x,2) = g;
                     X(y,x,3) = b;
                end
                %if x surpass the second active point we break the loop 
                if x>= activePoints.x2
                    break;
                end
            end
            %track active edges
            %when y reaches minimum value of ymax array then we should change active sides
   
            if y+1 == max(ymin(:)) && countYmax ~= 3 && countYmin ~= 3
                k = 1;
                index = zeros(2,1);
                newActiveEdges = zeros(2,1);
                for i=1:3
                    if array(i).y1 == max(ymin(:)) || array(i).y2 == max(ymin(:))
                    index(k) = i; 
                    k = k + 1;
                    end
                end
                k = 1;
                hist = histcounts([activeEdges;index]);
                for i = 1:length(hist)
                    if hist(i) == 1
                        newActiveEdges(k) = i;
                        k = k + 1;
                    end
                end
                flag = ones(3,1);
                for i = 1:3
                    if array(i).m == array(activeEdges(1)).m || array(i).m == array(activeEdges(2)).m
                        flag(i) = 0;
                    end
                end
                for i = 1:3
                    if hist(i) == 2
                        newIndex = i;
                    end
                end
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
                        mEx = array(i).m;
                    end
                end
                if activePoints.m1 == mEx
                    activePoints.x1 = xNew;
                    activePoints.y1 = yNew;
                    activePoints.m1 = m;
                    activePoints.y2 = activePoints.y2 + 1;
                    activePoints.x2 = activePoints.x2 + 1/activePoints.m2;
                elseif activePoints.m2 == mEx
                    activePoints.x2 = xNew;
                    activePoints.y2 = yNew;
                    activePoints.m2 = m;
                    activePoints.y1 = activePoints.y1 + 1;
                    activePoints.x1 = activePoints.x1 + 1/activePoints.m1;
                end
                activeEdges = newActiveEdges;
    
            else                
                activePoints.y1 = activePoints.y1 + 1;
                activePoints.x1 = activePoints.x1 + 1/activePoints.m1;
                activePoints.y2 = activePoints.y2 + 1;
                activePoints.x2 = activePoints.x2 + 1/activePoints.m2;
            end
        end
    else
        if countY == 3
            maxX = max(V(:,1));
            minX = min(V(:,1));
            for x = minX:maxX
                X(V(1,2),x,1) = r;
                X(V(1,2),x,2) = g;
                X(V(1,2),x,3) = b;
            end
        end
        if countX == 3
            maxY = max(V(:,2));
            minY = min(V(:,2));
            for y = minY:maxY
                X(y,V(1,1),1) = r;
                X(y,V(1,1),2) = g;
                X(y,V(1,1),3) = b;
            end
        end
        if countM == 3
            maxY = max(V(:,2));
            [minY,j] = min(V(:,2));
            startX = V(j,1);
            x = startX;
            xMod = startX;
            for y = minY:maxY
                X(y,x,1) = r;
                X(y,x,2) = g;
                X(y,x,3) = b;
                xMod = xMod + 1/array(1).m;
                x = round(xMod);
            end
        end
    end
    %return image
    %imshow(X)
    Y = X;  
end