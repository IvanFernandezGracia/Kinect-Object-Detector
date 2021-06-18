clc; clear all ; close all
% deteccion de objetos tiempo real y calcula cuantos
% objetos hay

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

cap=depthMap;
ii=1+ii;
if(ii==1000)
 cap=depthMap;
 toc
 disp(toc)
 break
end
ii;

%%% algoritmo
capcortado=cap(120+1:360-1,160+1:480-1);
[x y]=size(capcortado);
etiquetas=zeros(x,y);
tic
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contetiqueta=0;
for i=2:x-1
    for j=2:y-1
        if (capcortado(i,j)==1)
            [eti1,xxx,yyy]=pixelvecinos(etiquetas,i,j); % pixel vecinos etiquetas 0 1 2 3 ....
            [acti1,xxxx,yyyy]=vecactivos(capcortado,i,j);%pixel vecinos activos (1 o 0)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                % ¿Los vecinos etiquetados son todos iguales ?   si =0 no =1 
                cont=1;
                diferentes=0;
                poseticigual=0;
                for jj=1:8
                    if eti1(1,jj)~=0 ;
                        if cont==1;
                            eti2viejo=eti1(1,jj);
                            poseticigual=jj;
                            cont=2;
                        else cont==2;
                            if eti1(1,jj)~=eti2viejo;
                                diferentes=diferentes+1;
                        end
                    end
                    end
                end 
                
                %SALIDAS: POSETICIGUAL , DIFERENTEs
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% SI TODOS LOS VECINOS ETIQUETADOS SON DIFERENTES
                cont=1;
                cont3=0;
                cont4=0;
                diferentes1=0;
                poseticigual1=0;
                for jj=1:8
                    if eti1(1,jj)~=0 ;
                        cont3=cont3+1;
                        if cont==1;
                            eti2viejo=eti1(1,jj);
                            poseticigual1=jj;
                            cont=2;
                        else cont==2;
                            if eti1(1,jj)-(eti2viejo)~=0 & cont==2;
                               cont4=cont4+1; 
                            end
                        end            
                    end
                end
                numeropixelesestiquetados=cont3;
                numeropixelesdiferentes=cont4+1;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%Menor de los vecinos
                menorviejo=1000;
                for jj=1:8
                    if eti1(1,jj)~=0 & acti1(1,jj)==1;
                        menornuevo=eti1(1,jj);
                        if menorviejo-menornuevo>0;
                           menorviejo=menornuevo; 
                        end
                    end 
                end 
                % salida menor viejo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

            if etiquetas(i,j)~=0; %% si tiene etiqueca
                % Si todos los vecinos etiquetados tiene la misma etiqueta:
                if diferentes==0;
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1==1;
                            etiquetas(xxx(1,jj),yyy(1,jj))=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                        end
                    end
               % Si no     
               else
                    %%MERGE
                    for jj=1:8
                        if acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=menorviejo; %etiquetas(i,j);
                            etiquetas(i,j)=menorviejo;
                        end
                    end
                    %disp('hola1')
                end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
            else
                % Si todos los vecinos no estan etiquetados o no tienen vec
                if sum(eti1)==0 || sum(acti1)==0;
                    % se marca el pixel con la etiqueta siguiente
                    etiquetas(i,j)=contetiqueta+1;
                    % se marcan lso vecinos no etiquetados con la misma
                    % etiqueta
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1(1,jj)==1;
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=etiquetas(i,j);
                        end
                    end
                    % se incrementa la etiqueta
                    contetiqueta=contetiqueta+1;
                % si todos los vecinos etiquetados son diferentes    
                elseif  numeropixelesestiquetados==numeropixelesdiferentes;
                   %%MERGE
                    for jj=1:8
                        if acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=menorviejo;
                            etiquetas(i,j)=menorviejo;
                        end
                    end
                   %disp('hola2')
                % SI NO   
                else
                    % se marca el pixel con la etiqueta de los vecinos
                    etiquetas(i,j)=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                    % se marcan todos los vecinos no etiquetados con ma
                    % misma etiqueta
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                        end
                    end
                end 
            end
        end  
    end
    %disp( contetiqueta)
    %figure (2)
    %imshow(etiquetas, [0 1])
    %imagesc(etiquetas);
    %pause(0);
end

contetiqueta;
figure (3)
%imshow(etiquetas, [0 1])
etiquetavieja=etiquetas;
contetiqueta=0;
for i=x-1:-1:2
    for j=y-1:-1:2
        if (capcortado(i,j)==1)
            [eti1,xxx,yyy]=pixelvecinos(etiquetas,i,j); % pixel vecinos etiquetas 0 1 2 3 ....
            [acti1,xxxx,yyyy]=vecactivos(capcortado,i,j);%pixel vecinos activos (1 o 0)  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                % ¿Los vecinos etiquetados son todos iguales ?   si =0 no =1 
                cont=1;
                diferentes=0;
                poseticigual=0;
                for jj=1:8
                    if eti1(1,jj)~=0 ;
                        if cont==1;
                            eti2viejo=eti1(1,jj);
                            poseticigual=jj;
                            cont=2;
                        else cont==2;
                            if eti1(1,jj)~=eti2viejo;
                                diferentes=diferentes+1;
                        end
                    end
                    end
                end 
                
                %SALIDAS: POSETICIGUAL , DIFERENTEs
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% SI TODOS LOS VECINOS ETIQUETADOS SON DIFERENTES
                cont=1;
                cont3=0;
                cont4=0;
                diferentes1=0;
                poseticigual1=0;
                for jj=1:8
                    if eti1(1,jj)~=0 ;
                        cont3=cont3+1;
                        if cont==1;
                            eti2viejo=eti1(1,jj);
                            poseticigual1=jj;
                            cont=2;
                        else cont==2;
                            if eti1(1,jj)-(eti2viejo)~=0 & cont==2;
                               cont4=cont4+1; 
                            end
                        end            
                    end
                end
                numeropixelesestiquetados=cont3;
                numeropixelesdiferentes=cont4+1;
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
%Menor de los vecinos
                menorviejo=1000;
                for jj=1:8
                    if eti1(1,jj)~=0 & acti1(1,jj)==1;
                        menornuevo=eti1(1,jj);
                        if menorviejo-menornuevo>0;
                           menorviejo=menornuevo; 
                        end
                    end 
                end 
                % salida menor viejo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

            if etiquetas(i,j)~=0; %% si tiene etiqueca
                % Si todos los vecinos etiquetados tiene la misma etiqueta:
                if diferentes==0;
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1==1;
                            etiquetas(xxx(1,jj),yyy(1,jj))=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                        end
                    end
               % Si no     
               else
                    %%MERGE
                    for jj=1:8
                        if acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=menorviejo; %etiquetas(i,j);
                            etiquetas(i,j)=menorviejo;
                        end
                    end
                    %disp('hola1')
                end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
            else
                % Si todos los vecinos no estan etiquetados o no tienen vec
                if sum(eti1)==0 || sum(acti1)==0;
                    % se marca el pixel con la etiqueta siguiente
                    etiquetas(i,j)=contetiqueta+1;
                    % se marcan lso vecinos no etiquetados con la misma
                    % etiqueta
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1(1,jj)==1;
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=etiquetas(i,j);
                        end
                    end
                    % se incrementa la etiqueta
                    contetiqueta=contetiqueta+1;
                % si todos los vecinos etiquetados son diferentes    
                elseif  numeropixelesestiquetados==numeropixelesdiferentes;
                   %%MERGE
                    for jj=1:8
                        if acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=menorviejo;
                            etiquetas(i,j)=menorviejo;
                        end
                    end
                   %disp('hola2')
                % SI NO   
                else
                    % se marca el pixel con la etiqueta de los vecinos
                    etiquetas(i,j)=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                    % se marcan todos los vecinos no etiquetados con ma
                    % misma etiqueta
                    for jj=1:8
                        if eti1(1,jj)==0 & acti1(1,jj)==1
                            etiquetas(xxxx(1,jj),yyyy(1,jj))=etiquetas(xxx(1,poseticigual),yyy(1,poseticigual));
                        end
                    end
                end 
            end
        end
    end
    %disp( contetiqueta)
    %figure (2)
    %imshow(etiquetas, [0 1])
    %imagesc(etiquetas);
    %pause(0);
end

contetiqueta=unique(etiquetas);
[x,y]=size(contetiqueta);
cantidad= x-1;
figure (3)
%imshow(etiquetas, [0 1])
subplot(1,2,2) ;imagesc(etiquetas)
title(['Cantidad Objetos: ', num2str(cantidad)])
subplot(1,2,1);imagesc(etiquetavieja)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc





end 
stop(depthVid);




