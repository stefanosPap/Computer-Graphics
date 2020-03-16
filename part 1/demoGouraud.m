%% demoGouraud.m
% This script demonstrates the triangle filling algorithm by using the Gouraud
% method
%% -----START-----
%% 
%clear workspace and close windows 
clear
close

%load workspace
load('duck_hw1.mat')

%choose Gouraud painter
painter = 'Gouraud';

%call function paintObject
fprintf("Gouraud version is now running...\n")
tic
image = paintObject(V_2d,F,C,D,painter);
toc

%show results
imshow(image);
fprintf("Gouraud version Done\n")

%image will be saved in the path that the programm is executed
imwrite(image,'GouraudDuck.jpg');

%% -----END-----
%% INFO
%   AUTHOR
% 
%   Stefanos Papadam          stefanospapadam@gmail.com
% 
%   March 2020