clear
load('duck_hw1.mat')%load workspace
painter = 'Flat';
image = paintObject(V_2d,F,C,D,painter);%call function paintObject
imshow(image);%show results
imsave;%save image