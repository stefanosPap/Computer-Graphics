clear
load('duck_hw1.mat')
L = 8758;
K = 17504;
M = 1200;
N = 1200;
d = zeros(L,1);
X = ones(M,N,3);
V = zeros(3,2);
COL = zeros(3,3);

for i=1:K
        d1 = D(F(i,1));
        d2 = D(F(i,2));
        d3 = D(F(i,3));
        depth = sum([d1 d2 d3])/3;
        d(i) = depth;
end
matrix = [d F(:,1) F(:,2) F(:,3)]; 
matrix = sortrows(matrix,1);
for i=K:-1:1
    V(1,:) = V_2d(matrix(i,2),:);
    V(2,:) = V_2d(matrix(i,3),:);
    V(3,:) = V_2d(matrix(i,4),:);

    COL(1,:) = C(matrix(i,2),:);
    COL(2,:) = C(matrix(i,3),:);
    COL(3,:) = C(matrix(i,4),:);
    if strcmp(painter,'Flat') == 1
        X = triPaintFlat(X,V,COL);
    else
        X = triPaintGouraud(X,V,COL);
    end
end