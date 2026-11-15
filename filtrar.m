function filtro = filtrar(comb,n,npc)

if comb
    if n<1250
        corte=240;
    elseif and(n>=1250,n<=4000)
        corte=round(240-(240-144)/(4000-1250)*(n-1250));
    else
        corte=144;
    end  
    ancho=60;
else    
    corte=55;
    ancho=10;
end
rel=pi/ancho;
for i=1:npc
    if i<(corte-ancho/2)
        filtro(i)=1;
    elseif and((i>=corte-ancho/2),(i<=corte+ancho/2))
        cont=i-(corte-ancho/2);
        filtro(i)=(cos(cont*rel)+1)/2;
    elseif and((i>corte+ancho/2) , (i<npc-(corte+ancho/2-2)))
        filtro(i)=0;
    elseif and((i>=npc-(corte+ancho/2-2)) , (i<=npc-(corte-ancho/2-2)))
        cont=(npc-(corte-ancho/2-2))-i;
        filtro(i)=(cos(cont*rel)+1)/2;
    else
        filtro(i)=1;
    end    
end  
return