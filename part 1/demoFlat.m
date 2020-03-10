%% demoFlat.m
% This script demonstrates the triangle filling algorithm by using the Flat
% method
%% --START--

%clear workspace and close windows 
clear
close

%load workspace
load('duck_hw1.mat')

%choose painter
painter = 'Flat';

%call function paintObject
fprintf("Running...\n")
tic
image = paintObject(V_2d,F,C,D,painter);
toc

%show results
imshow(image);
fprintf("Done\n")

%image will be saved in the path that the programm is executed
imwrite(image,'FlatDuck.png');

%% --END--
