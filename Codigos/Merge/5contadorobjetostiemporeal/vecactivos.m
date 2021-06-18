function [activos,posxx,posyy]=vecactivos(matriz,i,j)
activos=[(matriz(i-1,j+1)) (matriz(i-1,j)) (matriz(i-1,j-1)) (matriz(i,j-1)) (matriz(i+1,j-1)) (matriz(i+1,j)) (matriz(i+1,j+1)) (matriz(i,j+1))];
posxx=[i-1 i-1 i-1 i i+1 i+1 i+1 i];
posyy=[j+1 j j-1 j-1 j-1 j j+1 j+1];
end 