function Y = shadePhong(p, Vn, Pc, Cam, S, ka, kd, ks, ncoeff, Ia, I0, X,i)
    

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
    array(1) = struct('x1',V(1,1),'y1',V(1,2),'x2',V(2,1),'y2',V(2,2),'m',m1,'normal',Vn(:,1),'ka',ka(:,1),'kd',kd(:,1), 'ks', ks(:,1));
    array(2) = struct('x1',V(2,1),'y1',V(2,2),'x2',V(3,1),'y2',V(3,2),'m',m2,'normal',Vn(:,2),'ka',ka(:,2),'kd',kd(:,2), 'ks', ks(:,2));
    array(3) = struct('x1',V(3,1),'y1',V(3,2),'x2',V(1,1),'y2',V(1,2),'m',m3,'normal',Vn(:,3),'ka',ka(:,3),'kd',kd(:,3), 'ks', ks(:,3));
    
    %activePoints contains the information of each active point, x1,y1 and x2,y2 are two vertices and m1,m2 are the slope of each side.
    activePoints = struct('x1',0,'y1',0,'m1',0,'normal1',[0;0;0],'ka1',[0;0;0],'kd1',[0;0;0], 'ks1',[0;0;0],'x2',0,'y2',0,'m2',0,'normal2',[0;0;0],'ka2',[0;0;0],'kd2',[0;0;0], 'ks2', [0;0;0]);
    
    %compute active points for scanline ymin
    k = 1;
    for i=1:3
        if array(i).y1==y_minimum && array(i).m ~= 0 %case of edges 1 and 2
            activePoints.x1 = array(i).x1;
            activePoints.y1 = array(i).y1;
            activePoints.m1 = array(i).m;
            activePoints.normal1 = array(i).normal;
            activePoints.ka1 = array(i).ka;
            activePoints.kd1 = array(i).kd;
            activePoints.ks1 = array(i).ks;
            activeEdges(k) = i;
            k = k + 1;
        elseif array(i).y2==y_minimum && array(i).m ~= 0 %case of edge 3
            activePoints.x2 = array(i).x2;
            activePoints.y2 = array(i).y2;
            activePoints.m2 = array(i).m;
            activePoints.normal2 = array(i).normal;
            activePoints.ka2 = array(i).ka;
            activePoints.kd2 = array(i).kd;
            activePoints.ks2 = array(i).ks;            
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
                [activePoints.normal2 , activePoints.normal1] = deal(activePoints.normal1,activePoints.normal2);
                [activePoints.ka2 , activePoints.ka1] = deal(activePoints.ka1,activePoints.ka2);
                [activePoints.kd2 , activePoints.kd1] = deal(activePoints.kd1,activePoints.kd2);
                [activePoints.ks2 , activePoints.ks1] = deal(activePoints.ks1,activePoints.ks2);
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
                    
                    if found ~= 3 %case where active edges are 1 or 2
                         xn1 = Vn(1,found);
                         xn2 = Vn(1,found + 1);
                         yn1 = Vn(2,found);
                         yn2 = Vn(2,found + 1);
                         zn1 = Vn(3,found);
                         zn2 = Vn(3,found + 1);
                         
                         kar1 = ka(1,found);
                         kar2 = ka(1,found + 1);
                         kag1 = ka(2,found);
                         kag2 = ka(2,found + 1);
                         kab1 = ka(3,found);
                         kab2 = ka(3,found + 1);
                         
                         kdr1 = kd(1,found);
                         kdr2 = kd(1,found + 1);
                         kdg1 = kd(2,found);
                         kdg2 = kd(2,found + 1);
                         kdb1 = kd(3,found);
                         kdb2 = kd(3,found + 1);
                         
                         ksr1 = ks(1,found);
                         ksr2 = ks(1,found + 1);
                         ksg1 = ks(2,found);
                         ksg2 = ks(2,found + 1);
                         ksb1 = ks(3,found);
                         ksb2 = ks(3,found + 1); 
                    else %case where active edge is 3
                         xn1 = Vn(1,found);
                         xn2 = Vn(1,found - 2);
                         yn1 = Vn(2,found);
                         yn2 = Vn(2,found - 2);
                         zn1 = Vn(3,found);
                         zn2 = Vn(3,found - 2);
                         
                         kar1 = ka(1,found);
                         kar2 = ka(1,found - 2);
                         kag1 = ka(2,found);
                         kag2 = ka(2,found - 2);
                         kab1 = ka(3,found);
                         kab2 = ka(3,found - 2);
                         
                         kdr1 = kd(1,found);
                         kdr2 = kd(1,found - 2);
                         kdg1 = kd(2,found);
                         kdg2 = kd(2,found - 2);
                         kdb1 = kd(3,found);
                         kdb2 = kd(3,found - 2);
                         
                         ksr1 = ks(1,found);
                         ksr2 = ks(1,found - 2);
                         ksg1 = ks(2,found);
                         ksg2 = ks(2,found - 2);
                         ksb1 = ks(3,found);
                         ksb2 = ks(3,found - 2);
                    end
                    
                    vectorX = [x y]; %current point
                    vectorX1 = [array(found).x1 array(found).y1]; %first vertex
                    vectorX2 = [array(found).x2 array(found).y2]; %second vertex
                    NA(1) = xn1 + (xn2 - xn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    NA(2) = yn1 + (yn2 - yn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    NA(3) = zn1 + (zn2 - zn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KAA(1) = kar1 + (kar2 - kar1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KAA(2) = kag1 + (kag2 - kag1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KAA(3) = kab1 + (kab2 - kab1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KDA(1) = kdr1 + (kdr2 - kdr1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KDA(2) = kdg1 + (kdg2 - kdg1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KDA(3) = kdb1 + (kdb2 - kdb1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KSA(1) = ksr1 + (ksr2 - ksr1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KSA(2) = ksg1 + (ksg2 - ksg1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KSA(3) = ksb1 + (ksb2 - ksb1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    NA = NA(:);
                    KAA = KAA(:);
                    KDA = KDA(:);
                    KSA = KSA(:);
                    
                    
                    Iam = ambientLight(KAA,Ia);
                    Idif = diffuseLight(Pc, NA, KDA,S,I0);
                    if Idif < 0
                        Idif = 0;
                    end
                    Isp = specularLight(Pc, NA, Cam, KSA, ncoeff, S, I0);
                    color = Iam + Idif + Isp;
                                                             
                    %paint the points 
                    X(y,x,1) = color(1);
                    X(y,x,2) = color(2);
                    X(y,x,3) = color(3);
                    set = 1;                    
                elseif abs(x - activePoints.x2) < 1
                    for i=1:3 %if second active point found 
                        if activePoints.m2 == array(i).m 
                            found = i; %find which is the active point in array
                        end
                    end
                    
                    if found ~= 3 %case where active edges are 1 or 2
                         xn1 = Vn(1,found);
                         xn2 = Vn(1,found + 1);
                         yn1 = Vn(2,found);
                         yn2 = Vn(2,found + 1);
                         zn1 = Vn(3,found);
                         zn2 = Vn(3,found + 1);
                         
                         kar1 = ka(1,found);
                         kar2 = ka(1,found + 1);
                         kag1 = ka(2,found);
                         kag2 = ka(2,found + 1);
                         kab1 = ka(3,found);
                         kab2 = ka(3,found + 1);
                         
                         kdr1 = kd(1,found);
                         kdr2 = kd(1,found + 1);
                         kdg1 = kd(2,found);
                         kdg2 = kd(2,found + 1);
                         kdb1 = kd(3,found);
                         kdb2 = kd(3,found + 1);
                         
                         ksr1 = ks(1,found);
                         ksr2 = ks(1,found + 1);
                         ksg1 = ks(2,found);
                         ksg2 = ks(2,found + 1);
                         ksb1 = ks(3,found);
                         ksb2 = ks(3,found + 1); 
                    else %case where active edge is 3
                         xn1 = Vn(1,found);
                         xn2 = Vn(1,found - 2);
                         yn1 = Vn(2,found);
                         yn2 = Vn(2,found - 2);
                         zn1 = Vn(3,found);
                         zn2 = Vn(3,found - 2);
                         
                         kar1 = ka(1,found);
                         kar2 = ka(1,found - 2);
                         kag1 = ka(2,found);
                         kag2 = ka(2,found - 2);
                         kab1 = ka(3,found);
                         kab2 = ka(3,found - 2);
                         
                         kdr1 = kd(1,found);
                         kdr2 = kd(1,found - 2);
                         kdg1 = kd(2,found);
                         kdg2 = kd(2,found - 2);
                         kdb1 = kd(3,found);
                         kdb2 = kd(3,found - 2);
                         
                         ksr1 = ks(1,found);
                         ksr2 = ks(1,found - 2);
                         ksg1 = ks(2,found);
                         ksg2 = ks(2,found - 2);
                         ksb1 = ks(3,found);
                         ksb2 = ks(1,found - 2);
                    end
                    
                    vectorX = [x y]; %current point
                    vectorX1 = [array(found).x1 array(found).y1]; %first vertex
                    vectorX2 = [array(found).x2 array(found).y2]; %second vertex
                    NB(1) = xn1 + (xn2 - xn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    NB(2) = yn1 + (yn2 - yn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    NB(3) = zn1 + (zn2 - zn1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KAB(1) = kar1 + (kar2 - kar1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KAB(2) = kag1 + (kag2 - kag1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KAB(3) = kab1 + (kab2 - kab1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KDB(1) = kdr1 + (kdr2 - kdr1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KDB(2) = kdg1 + (kdg2 - kdg1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KDB(3) = kdb1 + (kdb2 - kdb1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    KSB(1) = ksr1 + (ksr2 - ksr1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1); %apply linear interpolation
                    KSB(2) = ksg1 + (ksg2 - ksg1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    KSB(3) = ksb1 + (ksb2 - ksb1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                    
                    NB = NB(:);
                    KAB = KAB(:);
                    KDB = KDB(:);
                    KSB = KSB(:);
                    
                    
                    Iam = ambientLight(KAB,Ia);
                    Idif = diffuseLight(Pc, NB, KDB,S,I0);
                    if Idif < 0
                       Idif = 0;
                    end
                    Isp = specularLight(Pc, NB, Cam, KSB, ncoeff, S, I0);
                    color = Iam + Idif + Isp; 
                    
                    %paint the points 
                    X(y,x,1) = color(1);
                    X(y,x,2) = color(2);
                    X(y,x,3) = color(3);                                       
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
                     
                    n(1) = NB(1)+(NA(1)-NB(1))*(x-b)/(a-b);
                    n(2) = NB(2)+(NA(2)-NB(2))*(x-b)/(a-b);
                    n(3) = NB(3)+(NA(3)-NB(3))*(x-b)/(a-b);
    
                    kaCur(1) = KAB(1)+(KAA(1)-KAB(1))*(x-b)/(a-b);
                    kaCur(2) = KAB(2)+(KAA(2)-KAB(2))*(x-b)/(a-b);
                    kaCur(3) = KAB(3)+(KAA(3)-KAB(3))*(x-b)/(a-b);
    
                    kdCur(1) = KDB(1)+(KDA(1)-KDB(1))*(x-b)/(a-b);
                    kdCur(2) = KDB(2)+(KDA(2)-KDB(2))*(x-b)/(a-b);
                    kdCur(3) = KDB(3)+(KDA(3)-KDB(3))*(x-b)/(a-b);
    
                    ksCur(1) = KSB(1)+(KSA(1)-KSB(1))*(x-b)/(a-b);
                    ksCur(2) = KSB(2)+(KSA(2)-KSB(2))*(x-b)/(a-b);
                    ksCur(3) = KSB(3)+(KSA(3)-KSB(3))*(x-b)/(a-b);
                    
                    n = n(:);
                    kaCur = kaCur(:);
                    kdCur = kdCur(:);
                    ksCur = ksCur(:);
                    
                   
                    Iam = ambientLight(kaCur,Ia);
                    Idif = diffuseLight(Pc, n, kdCur,S,I0);
                    if Idif < 0
                       Idif = 0;
                    end
                    Isp = specularLight(Pc, n, Cam, ksCur, ncoeff, S, I0);
                    color = Iam + Idif + Isp;
                    
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
             n1 = array(maxIndex).normal;
             n2 = array(minIndex).normal;
             ka1 = array(maxIndex).ka;
             ka2 = array(minIndex).ka;
             
             kd1 = array(maxIndex).kd;
             kd2 = array(minIndex).kd;
             
             ks1 = array(maxIndex).ks;
             ks2 = array(minIndex).ks;
             
             a = maxX;
             b = minX;
             
             
             %compute color of maximum and minimun vertex in order to use it later for linear interpolation  
              
             for x = minX:maxX %scan image in x axis from min to max value of x and paint these points
                 nCur = n1+(n1-n2)*(x-b)/(a-b);
                 kaCur = ka1+(ka1-ka2)*(x-b)/(a-b);
                 kdCur = kd1+(kd1-kd2)*(x-b)/(a-b);
                 ksCur = ks1+(ks1-ks2)*(x-b)/(a-b);
                 
                 nCur = nCur(:);
                 kaCur = kaCur(:);
                 kdCur = kdCur(:);
                 ksCur = ksCur(:);
                 
                 Iam = ambientLight(kaCur,Ia);
                 Idif = diffuseLight(Pc, nCur, kdCur,S,I0);
                 if Idif < 0
                   Idif = 0;
                 end
                 Isp = specularLight(Pc, nCur, Cam, ksCur, ncoeff, S, I0);
                 color = Iam + Idif + Isp;

                 X(V(1,2),x,1) = color(1);
                 X(V(1,2),x,2) = color(2);
                 X(V(1,2),x,3) = color(3);
             end
         end
         
         if countX == 3 %if vertices are parallel to y axis
             [maxY,maxIndex] = max(V(:,2)); %find maximum and minimum value of y
             [minY,minIndex] = min(V(:,2));
             
             n1 = array(maxIndex).normal;
             n2 = array(minIndex).normal;
             ka1 = array(maxIndex).ka;
             ka2 = array(minIndex).ka;
             
             kd1 = array(maxIndex).kd;
             kd2 = array(minIndex).kd;
             
             ks1 = array(maxIndex).ks;
             ks2 = array(minIndex).ks;
             
             a = maxY;
             b = minY;
             %compute color of maximum and minimun vertex in order to use it later for linear interpolation
             
             for y = minY:maxY %scan image in y axis from min to max value of y and paint these points
                 
                 nCur = n1+(n1-n2)*(y-b)/(a-b);
                 kaCur = ka1+(ka1-ka2)*(y-b)/(a-b);
                 kdCur = kd1+(kd1-kd2)*(y-b)/(a-b);
                 ksCur = ks1+(ks1-ks2)*(y-b)/(a-b);
                 
                 nCur = nCur(:);
                 kaCur = kaCur(:);
                 kdCur = kdCur(:);
                 ksCur = ksCur(:);
                 
                 Iam = ambientLight(kaCur,Ia);
                 Idif = diffuseLight(Pc, nCur, kdCur,S,I0);
                 if Idif < 0
                   Idif = 0;
                 end
                 Isp = specularLight(Pc, nCur, Cam, ksCur, ncoeff, S, I0);
                 color = Iam + Idif + Isp;

                 X(y,V(1,1),1)  = color(1);
                 X(y,V(1,1),2)  = color(2);
                 X(y,V(1,1),1)  = color(3);
             end
         end
         
         if countM == 3 %if vertices are in the same line (have the same slope)
             [maxY,maxIndex] = max(V(:,2));%find maximum and minimum value of y
             [minY,minIndex] = min(V(:,2));

             n1 = array(maxIndex).normal;
             n2 = array(minIndex).normal;
             ka1 = array(maxIndex).ka;
             ka2 = array(minIndex).ka;
             
             kd1 = array(maxIndex).kd;
             kd2 = array(minIndex).kd;
             
             ks1 = array(maxIndex).ks;
             ks2 = array(minIndex).ks;
             
             %compute color of maximum and minimun vertex in order to use it later for linear interpolation
             startX = V(minIndex,1);
             x = startX; %x is the rounded value of xMod 
             xMod = startX; %start value of x
             
             for y = minY:maxY %scan image in y axis from min to max value of y 
                 
                 %compute color using linear interpolation
                 vectorX = [x y]; %current point
                 vectorX1 = [V(maxIndex,1) V(maxIndex,2)]; %max vertex 
                 vectorX2 = [V(minIndex,1) V(minIndex,2)]; %min vertex
                 nCur = n1 + (n2 - n1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                 kaCur = ka1 + (ka2 - ka1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                 kdCur = kd1 + (kd2 - kd1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                 ksCur = ks1 + (ks2 - ks1) * norm(vectorX - vectorX1) / norm(vectorX2 - vectorX1);
                 
                 Iam = ambientLight(kaCur,Ia);
                 Idif = diffuseLight(Pc, nCur, kdCur,S,I0);
                 if Idif < 0
                   Idif = 0;
                 end
                 Isp = specularLight(Pc, nCur, Cam, ksCur, ncoeff, S, I0);
                 color = Iam + Idif + Isp;

                 X(y,x,1) = color(1);
                 X(y,x,2) = color(2);
                 X(y,x,3) = color(3);
                 
                 xMod = xMod + 1/array(1).m;
                 x = round(xMod); %round x because pixels must be integers 
             end
         end
    end
    
    %return image
    Y = X;
    
end