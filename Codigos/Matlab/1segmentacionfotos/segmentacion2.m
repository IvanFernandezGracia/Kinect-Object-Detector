clc; clear all ; close all
%load('imagen.mat')
load('3objrectborde.mat')
figure (1)
cap1=cap;
imshow(cap1,[0 1])
[etiquetas num]=bwlabel(cap(120+1:360-1,160+1:480-1)); %%detector objetos y los etiqueta
figure (2)
color=label2rgb(etiquetas);   %% da color a los objetos etiquetados
color = insertText(color,[0 0],'Cantidad: ');
color = insertText(color,[65,0],num);

subplot(1,2,1);imshow(cap1(120+1:360-1,160+1:480-1),[0 1]);subplot(1,2,2);imshow(color);
disp('Numero de objetos: ')
Numero=num

