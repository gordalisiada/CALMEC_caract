function pre_ciclo_der = derivarp(Preference,npc,comb,n)
    pre_ciclo = Preference(:,2);
    espectro_ciclo=fft(pre_ciclo);
    filtro=filtrar(comb,n,npc)';
    espectro_ciclo_filt=espectro_ciclo.*filtro;
    
    clear i
for cont=1:npc/2
    espectro_ciclo_der(cont)=i*(cont-1)*espectro_ciclo_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(cont-1)*espectro_ciclo_OK_filt(cont);
end  
for cont=npc/2+1:npc
    espectro_ciclo_der(cont)=-i*(npc-cont+1)*espectro_ciclo_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(npc-cont+1)*espectro_ciclo_OK_filt(cont);
end 
pre_ciclo_der=ifft(espectro_ciclo_der)';
pre_ciclo_der=pre_ciclo_der/2;
% pre_ciclo_der_KK=diff([pre_ciclo;pre_ciclo(1)])/intang*(180/pi); %EN TESIS PONE QUE ES POR EL METODO DE LAS DIFERENCIAS CENTRADAS PERO REALMENTE ES MAS CUTRE AUN
end
