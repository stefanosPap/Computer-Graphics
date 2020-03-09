clc
clear

%% Load data %%
load('hw2.mat');

%% Initial position 
% TODO Photograph object with photographObject

% TODO Paint object with ObjectPainter with gouraud

% Save result
imwrite(I0, '0.jpg');

%% Step 1 - Translate by t1
% TODO Apply translation

% TODO Photograph object with photographObject

% TODO Paint object with ObjectPainter with gouraud

% Save result
imwrite(I1, '1.jpg');

%% Step 2 - Rotate by theta around given axis
% TODO Apply rotation

% TODO Photograph object with photographObject

% TODO Paint object with ObjectPainter with gouraud

% Save result
imwrite(I2, '2.jpg');

%% Step 3 - Translate back
% TODO Apply translation

% TODO Photograph object with photographObject

% TODO Paint object with ObjectPainter with gouraud

% Save result
imwrite(I3, '3.jpg');
