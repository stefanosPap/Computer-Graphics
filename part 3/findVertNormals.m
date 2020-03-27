function Normals = findVertNormals(R, F)
    Triangles = zeros(3,length(F));
    Normals = zeros(3,length(R));
    for i = 1:length(F)
        a = R(:,F(1,i));
        b = R(:,F(2,i));
        c = R(:,F(3,i));
        
        n = cross(a - b,a - c);

        Triangles(:,i) = n;
    end
    for i = 1:length(R)
        f = F(1,:) == i | F(2,:) == i | F(3,:) == i;
        n = sum(Triangles(:,f),2);
        Normals(:,i) = n ./ norm(n);
    end
end