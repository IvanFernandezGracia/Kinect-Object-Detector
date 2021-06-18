function sq(x,y,t,r)
global depthMap;
global pix_contador;
sz=size(depthMap);
if(t==r)
    return
end
if(depthMap(x,y)~=t)
    return
end
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