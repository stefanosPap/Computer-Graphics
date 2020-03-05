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
    if array(i).y1==y_minimum
        activePoints.x1 = array(i).x1;
        activePoints.y1 = array(i).y1;
        activePoints.m1 = array(i).m;
        activeEdges(k) = i;
        k = k + 1;
    elseif array(i).y2==y_minimum
        activePoints.x2 = array(i).x2;
        activePoints.y2 = array(i).y2;
        activePoints.m2 = array(i).m;
        activeEdges(k) = i;
        k = k + 1;
    end
 end
 %compute the slope of each active side

%compute active points for scanline 


%apply scanline algorithm

for y=y_minimum:y_maximum 

    %sort active points by increasing x

    if activePoints.x2 < activePoints.x1
        [activePoints.x2 , activePoints.x1] = deal(activePoints.x2,activePoints.x1);
        [activePoints.y2 , activePoints.y1] = deal(activePoints.y2,activePoints.y1);
    end
    cross_count = 0;
    %scan the image
    set = 0;
    for x=1:1200
         %if active point found increase cross_count 
        if x >= activePoints.x1 && set == 0
            set = 1; 
            cross_count = cross_count +1;      
        elseif   x >= activePoints.x2
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
        if x>activePoints.x2 || x == Inf
             break;
        end
    end
   
    count=0;
    %track active edges
    %when y reaches minimum value of ymax array then we should change active sides
    if y+1 == max(ymin(:))
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
        
        
        hist = histcounts([array(newActiveEdges(1)).m;
        array(newActiveEdges(2)).m;
        array(activeEdges(1)).m;
        array(activeEdges(2)).m]);
        for i = 1:length(hist)
            if hist(i) == 2
                found = i;
            end
        end
    else
        activePoints.y1 = activePoints.y1 + 1;
        activePoints.x1 = activePoints.x1 + 1/activePoints.m1;
        activePoints.y2 = activePoints.y2 + 1;
        activePoints.x2 = activePoints.x2 + 1/activePoints.m2;
    end
%      ok = 0;
%      for i=1:3%access array in order to find this value 
%          index_new = 3;
%          if array(i,2) == min(ymax(:)) || array(i,4) == min(ymax(:))
%             %if found,decrease count by 1 
%              if i == edge(1)+1;
%                 count=count-1;
%                 index = 1;%keep the index in the array
%             elseif i == edge(2)+1;
%                 count=count-1;
%                 index = 2;%keep the index in the array
%             else
%                 index_new = i;
%                 ok=1;
%              end    
%             %if count == 1 && ok == 1 this means that  
%             %found both sides in array so we change the slope  
%             if count == 1 && ok == 1
%                 edge(index) = index_new - 1;
%                 %compute slopes
%                 %we use fix function in order to keep only decimal part of
%                 %x
%                  m1 = (array(edge(1)+1,4)-array(edge(1)+1,2))/(array(edge(1)+1,3)-array(edge(1)+1,1));
%                  m2 = (array(edge(2)+1,4)-array(edge(2)+1,2))/(array(edge(2)+1,3)-array(edge(2)+1,1));
%                  %update active points
%                 active_points.x1 = round(active_points.x1 + 1/m1);
%                 active_points.x2 = round(active_points.x2 + 1/m2);  
%             end
%          end
%      end

    % else%this case is when we don't change active side so we update active
     %points
%         whole1 = whole1 + 1/ActiveEdgeTable.slope1;
%         whole2 = whole2 + 1/ActiveEdgeTable.slope2;
%         fract1 = whole1 - fix(whole1);
%         fract2 = whole2 - fix(whole2);
%         if fract1 > 1
    %        ActiveEdgeTable.x1 = ActiveEdgeTable.x1 + 1/ActiveEdgeTable.slope1;
%             fract1 = fract1 - 1;
%         end
%         if fract2 > 1 
     %       ActiveEdgeTable.x2 = ActiveEdgeTable.x2 +  1/ActiveEdgeTable.slope2;
%             fract2 = fract2 - 1; 
%         end
        %active_points.x1 = round(active_points.x1 + 1/m1);
        %active_points.x2 = round(active_points.x2 + 1/m2);
        %active_points.y1 = y+1;
        %active_points.y2 = y+1;
%        hold on 
 %       figure(1);
  %      
  %      for i=1:3
   %         plot([V(1,1) V(2,1)] ,[V(1,2) V(2,2)]);
    %        plot([V(2,1) V(3,1)] ,[V(2,2) V(3,2)]);
      %      plot([V(3,1) V(1,1)] ,[V(3,2) V(1,2)]);
     %   end
       % imshow(X)
        
    end
%       imshow(X)
   Y = X;  
end
%return image
  
   
%end
