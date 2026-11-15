function modifica_equis=modX(n,numpuntos)
if and(n>=1,n<=numpuntos)
    modifica_equis=n;
end
if n>numpuntos
    modifica_equis=n-numpuntos;
    
end
if n<1
    modifica_equis=n+numpuntos;
   
end
end
