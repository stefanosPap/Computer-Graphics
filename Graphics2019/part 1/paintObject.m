function I = paintObject(V_2d,F,C,D,painter)
    %initialization 
    L = length(D);
    K = length(F);
    M = 1200;
    N = 1200;
    d = zeros(L,1);
    X = ones(M,N,3);
    V = zeros(3,2);
    COL = zeros(3,3);

    for i=1:K
        d1 = D(F(i,1));%according to the indexes in matrix F we save in
        d2 = D(F(i,2));%three variables the depth of each peak that is stored in D
        d3 = D(F(i,3));
        depth = sum([d1 d2 d3])/3;%find the mean of depths 
        d(i) = depth;%store in d(i)
    end
    %create a matrix with the mean of depths in the first column 
    %and the indexes of the peaks in columns 2-4
    matrix = [d F(:,1) F(:,2) F(:,3)]; 
    matrix = sortrows(matrix,1);%sort them according to the first column 
    for i=K:-1:1
        %in matrix V we store the coordinates of the three peaks
        %in order to give it as argument in function triPaintFlat or triPaintGouraud
        V(1,:) = V_2d(matrix(i,2),:); 
        V(2,:) = V_2d(matrix(i,3),:); 
        V(3,:) = V_2d(matrix(i,4),:);
        %in matrix COL we store the coordinates of the three peaks
        %in order to give it as argument in function triPaintFlat or triPaintGouraud
        COL(1,:) = C(matrix(i,2),:);
        COL(2,:) = C(matrix(i,3),:);
        COL(3,:) = C(matrix(i,4),:);
        %call triPaintFlat or triPaintGouraud according to variable painter
        if strcmp(painter,'Flat') == 1
            X = triPaintFlat(X,V,COL);
            i
        else
            X = triPaintGouraud(X,V,COL);
            i
        end
    end
    %return matrix  
    I = X;
end