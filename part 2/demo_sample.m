clc
clear

%% Load data %%
load('hw2.mat');

%% Initial position
p = V';
% TODO Photograph object with photographObject
[P_2d , D] = photographObject(p, M, N, H, W, w, cv , ck , cu);
% TODO Paint object with ObjectPainter with gouraud

I0 = paintObject(P_2d',F,C,D,"Gouraud");
% Save result

imwrite(I0, '0.jpg');

%% Step 1 - Translate by t1
% TODO Apply translation
R = [1 0 0;0 1 0;0 0 1];
ct = t1;
cp = V';
cq = affinetrans(cp , R, ct);
p = cq;
% TODO Photograph object with photographObject
[P_2d , D] = photographObject(p, M, N, H, W, w, cv , ck , cu);
% TODO Paint object with ObjectPainter with gouraud
I1 = paintObject(P_2d',F,C,D,"Gouraud");
% Save result
imwrite(I1, '1.jpg');

%% Step 2 - Rotate by theta around given axis
% TODO Apply rotation
R = rotmat(theta,g);
ct = [0;0;0];
cp = cq;
cq = affinetrans(cp , R, ct);
p = cq;
% TODO Photograph object with photographObject
[P_2d , D] = photographObject(p, M, N, H, W, w, cv , ck , cu);
% TODO Paint object with ObjectPainter with gouraud
I2 = paintObject(P_2d',F,C,D,"Gouraud");
% Save result
imwrite(I2, '2.jpg');

%% Step 3 - Translate back
% TODO Apply translation
R = [1 0 0;0 1 0;0 0 1];
ct = t2;
cp = cq;
cq = affinetrans(cp , R, ct);
p = cq;
% TODO Photograph object with photographObject
[P_2d , D] = photographObject(p, M, N, H, W, w, cv , ck , cu);
% TODO Paint object with ObjectPainter with gouraud
I3 = paintObject(P_2d',F,C,D,"Gouraud");
% Save result
imwrite(I3, '3.jpg');
