load('hw3.mat');

% %% Gouraud shader
 shader = 1;
% 
% %% Ambient
% Ka = ka;
% Kd = 0*kd;
% Ks = 0*ks;
% Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
% %figure(1);
% % imshow(Y);
% imwrite(Y, 'gouraud_ambient.jpg');
% 
 %% Difussion 
 Ka = 0*ka;
 Kd = kd;
 Ks = 0*ks;
 Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
 %figure(2);
 %imshow(Y);
 imwrite(Y, 'gouraud_diffusion.jpg');
 
 %% Specular 
 Ka = 0*ka;
 Kd = 0*kd;
 Ks = ks;
 Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
 %figure(3);
 %imshow(Y);
 imwrite(Y, 'gouraud_specular.jpg');
 
% %% All together 
 Ka = ka;
 Kd = kd;
 Ks = ks;
 Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
% %figure(4);
% %imshow(Y);
 imwrite(Y, 'gouraud_all.jpg');

%% Phong shader
  shader = 2;

%% Ambient
Ka = ka;
Kd = 0*kd;
Ks = 0*ks;
Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
%figure(5);
%imshow(Y);
imwrite(Y, 'phong_ambient.jpg');

%% Difussion 
Ka = 0*ka;
Kd = kd;
Ks = 0*ks;
Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
%figure(6);
%imshow(Y);
imwrite(Y, 'phong_diffusion.jpg');

%% Specular 
Ka = 0*ka;
Kd = 0*kd;
Ks = ks;
Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
%figure(7);
%imshow(Y);
imwrite(Y, 'phong_specular.jpg');

%% All together 
Ka = ka;
Kd = kd;
Ks = ks;
Y = photographObjectPhong(shader,f,C,K,u,bC,M,N,H,W,R,F,S,Ka,Kd,Ks,ncoeff,Ia,I0);
%figure(8);
%imshow(Y);
imwrite(Y, 'phong_all.jpg');
