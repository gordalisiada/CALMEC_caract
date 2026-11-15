function espectro_exp= expandir(espectro,npc,ncl,cociente)
    %OJO QUE QUEDA LA IMAGEN ESPECULAR DE LA PRESION HAY QUE DARLE LA
    %VUELTA A LAS PRESIONES 'EXPANDIDAS'
    for i=1:npc
        espectro_exp((i-1)*ncl+1)=espectro(i);       
        espectro_exp=[espectro_exp zeros(1,ncl-1)];
    end    
    espectro_exp=espectro_exp'/cociente;
return