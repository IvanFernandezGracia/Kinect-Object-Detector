function [vecinos,posxx,posyy]=pixeletiquet(metiquetado,posi,posj)
i=posi;
j=posj;
vecinos=[(metiquetado(i-1,j+1)) (metiquetado(i-1,j)) (metiquetado(i-1,j-1)) (metiquetado(i,j-1)) (metiquetado(i+1,j-1)) (metiquetado(i+1,j)) (metiquetado(i+1,j+1)) (metiquetado(i,j+1))];
posxx=[i-1 i-1 i-1 i i+1 i+1 i+1 i];
posyy=[j+1 j j-1 j-1 j-1 j j+1 j+1];
end 