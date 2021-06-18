clc; clear all ; close all
% deteccion de objetos , saca una foto en 12 segundos y calcula cuantos
% objetos hay , ademas elimina los objetos que estan en el borde 

% INICIALIZACION DE KINECT, CAMARA RGB Y SENSOR DE DISTANCIA
imaqreset;%Borra los objetos de adquicicion de todos los adaptadores que entran a la toolbox
th_min=800;         %Ingresar en mm
th_max=1000;         %mm 
depthVid= videoinput('kinect',2); %Creo un objeto de video.
triggerconfig (depthVid, 'manual');
depthVid.FramesPerTrigger=1;
depthVid.TriggerRepeat=inf;

%set(getselectedsource(depthVid),'TrackingMode','Skeleton');
viewer=vision.DeployableVideoPlayer();
start(depthVid);
himg=figure;
pause(1)
% SELECCIONAR PUNTOS SELECCIONADOS Y LOS DIBUJA
ii=1;
tic
while ishandle(himg)  
trigger(depthVid);
[depthMap,~,depthMetaData]=getdata(depthVid);
a=depthMap(320,240);

for i=1:480
 for j=1:640
    if(i<=120|j<=160|i>=360|j>=480)
        depthMap(i,j)=1;
    end
 end
end


for i=120:360
 for j=160:480
  if((depthMap(i,j)<=th_min))
   depthMap(i,j)=0;
  elseif((depthMap(i,j)>=th_max))
   depthMap(i,j)=0;
  else
   depthMap(i,j)=1;
  end       
 end
end

imshow(depthMap,[0 1]);
b=depthMap(320,240);
[a b];

ii=1+ii;
if(ii==30)
 cap=depthMap;
 toc
 disp(toc)
 break
end
ii;

end 
stop(depthVid);

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

