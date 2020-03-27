function Im = photographObjectPhong(shader, f, C, K, u, bC, M, N, H, W, R, F, S, ka, kd, ks, ncoeff, Ia, I0)
    Normals = findVertNormals(R, F);
    [P_2d , D] = projectKu(f,C,K,u,R);
    P_2d = rasterize(P_2d, M, N, H, W);
    
    L = length(D);
    K = length(F);
    M = 1200;
    N = 1200;
    d = zeros(L,1);
    if bC == 1
        Y = ones(M,N,3);
    end
    p = zeros(2,3);
    Vn = zeros(3,3);
    kaArg = zeros(3,3);
    kdArg = zeros(3,3);
    ksArg = zeros(3,3);

    for i=1:K
        d1 = D(F(1,i)); %according to the indexes in matrix F we save in
        d2 = D(F(2,i)); %variables d1,d2,d3 the depth of each peak that is stored in D
        d3 = D(F(3,i));
        depth = sum([d1 d2 d3])/3; %find the mean of depths 
        d(i) = depth; %store in d(i)
    end
    
    %create the correspondenceTable with the mean of depths in the first column 
    %and the indexes of the peaks in columns 2-4 in order to keep the
    %corespondence 
    correspondenceTable = [d F(1,:)' F(2,:)' F(3,:)']; 
    correspondenceTable = sortrows(correspondenceTable,1); %sort them according to the first column 
    P_2d = P_2d';
    Normals = Normals';
    ka = ka';
    kd = kd';
    ks = ks';
    
    for i = K:-1:1
        
        %in table V we store the coordinates of the three peaks
        %in order to give it as argument to function triPaintFlat or triPaintGouraud
        p(:,1:3) = P_2d(correspondenceTable(i,2:4),:)'; 

        %in matrix COL we store the colour of the three peaks
        %in order to give it as argument to function triPaintFlat or triPaintGouraud
        Vn(:,1:3) = Normals(correspondenceTable(i,2:4),:)';
        
        kaArg(:,1:3) = ka(correspondenceTable(i,2:4),:)';
        
        kdArg(:,1:3) = kd(correspondenceTable(i,2:4),:)';
        
        ksArg(:,1:3) = ks(correspondenceTable(i,2:4),:)';
        
        Pc = (R(:,F(1,i)) + R(:,F(2,i)) + R(:,F(3,i))) / 3;
        
        %call triPaintFlat or triPaintGouraud according to variable painter
        if shader == 1
            Y = shadeGouraud(p, Vn, Pc, C, S, kaArg, kdArg, ksArg, ncoeff, Ia, I0, Y);
            i
        elseif shader == 2
            Y = shadePhong(p, Vn, Pc, C, S, kaArg, kdArg, ksArg, ncoeff, Ia, I0, Y);
            i
        end
    end
    Im = Y;
end