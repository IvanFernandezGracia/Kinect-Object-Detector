clc; clear all ; close all
% deteccion de objetos tiempo real y calcula cuantos
% objetos hay

% INICIALIZACION DE KINECT, CAMARA RGB Y SENSOR DE DISTANCIA
imaqreset; %Borra los objetos de adquicicion de todos los adaptadores que entran a la toolbox

% Limites entre los que el Kinect captara objetos
th_min=800;         %Ingresar en mm 
th_max=1000;         %mm 

depthVid= videoinput('kinect',2); %Creo un objeto de video.
triggerconfig (depthVid, 'manual'); %configura la toma de fotogramas 
depthVid.FramesPerTrigger=1; %cantidad de fotogramas
depthVid.TriggerRepeat=inf;

%set(getselectedsource(depthVid),'TrackingMode','Skeleton');
viewer=vision.DeployableVideoPlayer(); % Visualizacion por medio de un reproductor de video
start(depthVid); % Inicia el objeto Kinect
himg=figure;
pause(1)

ii=1;
tic
while ishandle(himg)  
trigger(depthVid);
[depthMap,~,depthMetaData]=getdata(depthVid); % Extraccion capa de profundidad
a=depthMap(320,240);


% Seleccionar region de interes (Region central de la imagen)
for i=1:480
 for j=1:640
    if(i<=120|j<=160|i>=360|j>=480)
        depthMap(i,j)=1;
    end
 end
end


% Funcion que activa (les da valor 1) a los objetos que esten entre los
% limites antes seleccionados y a los que esten fuera de los limites les da
% valor 0 (Imagen binaria)
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

% Plotea la imagen de profundidad Binaria
imshow(depthMap,[0 1]);
b=depthMap(320,240);
[a b];

cap=depthMap;
ii=1+ii;
if(ii==10)
 cap=depthMap;
 toc
 disp(toc)
 break
end
ii;

%figure (1)
%cap1=cap;
%imshow(cap1,[0 1])
[etiquetas num]=bwlabel(cap(120+1:360-1,160+1:480-1)); %% detecta objetos y los etiqueta en la region de interes
figure (1)
color=label2rgb(etiquetas);   %% da color a los objetos etiquetados
color = insertText(color,[0 0],'Cantidad: ');
color = insertText(color,[65,0],num);
foto=ii-1;
color = insertText(color,[80 0],'Foto: ');
color = insertText(color,[140,0],foto);
%subplot(1,2,1);imshow(cap1(120+1:360-1,160+1:480-1),[0 1]);subplot(1,2,2);
imshow(color);
%disp('Numero de objetos: ')
%Numero=num


end 
stop(depthVid);


