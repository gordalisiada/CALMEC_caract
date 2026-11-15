function derivative = derivate(Signal,npc,comb,n,CRevCiclo)
% Derivates and filter the given signals 
    espectro=fft(Signal);
    filtro=filtrar(comb,n,npc)';
    espectro_filt=espectro.*filtro;
    
    clear i
for cont=1:npc/2
    espectro_der(cont)=i*(cont-1)*espectro_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(cont-1)*espectro_ciclo_OK_filt(cont);
end  
for cont=npc/2+1:npc
    espectro_der(cont)=-i*(npc-cont+1)*espectro_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(npc-cont+1)*espectro_ciclo_OK_filt(cont);
end 
derivative = ifft(espectro_der)';
derivative = derivative/CRevCiclo;
% entiendo..........
% pre_ciclo_der_KK=diff([pre_ciclo;pre_ciclo(1)])/intang*(180/pi); %EN TESIS PONE QUE ES POR EL METODO DE LAS DIFERENCIAS CENTRADAS PERO REALMENTE ES MAS CUTRE AUN
end
