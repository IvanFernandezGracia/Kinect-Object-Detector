clc; clear all ; close all
imaqreset;                        %Borra los objetos de adquicicion de todos los adaptadores que entran a la toolbox
% ------------------------------------------------------------------------
% DETECCION DE OBJETOS Y CONTEO EN IMAGEN.
%-------------------------------------------------------------------------
% INICIALIZACION DE KINECT,SENSOR DE DISTANCIA
%------------------------------------------------------------------------
% PARAMETROS DE FUNCIONAMIENTO
%------------------------------------------------------------------------                  
th_min=800;                       %Ingresar en mm, 800 ES EL MINIMO
th_max=1000;
min_pix=5000;
%------------------------------------------------------------------------
%Flood Fill
%------------------------------------------------------------------------
depthVid= videoinput('kinect',2); % CREA EL OBJETO DE VIDEO.
triggerconfig (depthVid, 'manual');
depthVid.FramesPerTrigger=1;
depthVid.TriggerRepeat=inf;
%viewer=vision.DeployableVideoPlayer();
start(depthVid);
himg=figure;
global contador;
global depthMap;
global l;
global pix_contador;
c=zeros(240,320,3);
contador=0;
pix_contador=0;
ii=0;
%------------------------------------------------------------------------
%Captura de Imagen.
%------------------------------------------------------------------------
while ishandle(himg)
    contador=0;
trigger(depthVid);
[cap,~,depthMetaData]=getdata(depthVid);
depthMap=cap(121:360,161:480);
for i=1:240
 for j=1:320
  if((depthMap(i,j)<=th_min))
   depthMap(i,j)=0;
  elseif((depthMap(i,j)>=th_max))
   depthMap(i,j)=0;
  else
   depthMap(i,j)=1;
  end       
 end
end
%------------------------------------------------------------------------
%LLAMADA A Flood Fill START
%------------------------------------------------------------------------
sz=size(depthMap);
l=logical(depthMap);
%%if(ii==5)
for i=1:sz(1)
    for j=1:sz(2)
        if(l(i,j)==1)
            pix_contador=0;
       sq(i,j,1,contador+2);
       if(pix_contador>=min_pix)
       contador=contador+1;
       end
        end
    end
end
for i=1:sz(1)
    for j=1:sz(2)
         if(depthMap(i,j)==0)
       c(i,j,:)=[0,0,0];
        end
        if(depthMap(i,j)==1)
       c(i,j,:)=[0,0,255];
        end
          if(depthMap(i,j)==2)
       c(i,j,:)=[255,0,0];
          end
         if(depthMap(i,j)==3)
       c(i,j,:)=[0,255,0];
         end
         if(depthMap(i,j)==4)
       c(i,j,:)=[0,255,255];
        end
    end
end
%end
%------------------------------------------------------------------------
%LLAMADA A Flood Fill END
%------------------------------------------------------------------------
pix_contador=0;
c = insertText(c,[0 0],'Cantidad: ');
c = insertText(c,[65,0],contador);
imshow(c)
contador
end 
%stop(depthVid);


%------------------------------------------------------------------------
%Flood Fill- ESTA FUNCION RECURSIVA HACE LA MAGIA
%------------------------------------------------------------------------

function sq(x,y,t,r)
global depthMap;
global pix_contador;
global l;
sz=size(depthMap);
if(t==r)
    return
end
if(l(x,y)~=t)
    return
end
l(x,y)=0;
depthMap(x,y)=r;
pix_contador=1+pix_contador;
if(x<sz(1))
sq(x+1,y,t,r);
end
if(x>1)
sq(x-1,y,t,r);
end
if(y<sz(2))
sq(x,y+1,t,r);
end
if(y>1)
sq(x,y-1,t,r);
end
end

