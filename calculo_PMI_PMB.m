function [pmi,pmb]= calculo_PMI_PMB(Adjustment,CGradosCiclo,CRevCiclo,presionr,intang,NPC,Engine,n,factp,facti,vcc)

wtc = 0;
wta = 0;
desfase = -Adjustment.desfasetot;
Ang = mod720(desfase,CGradosCiclo);
for i= 1:NPC
    Ang = mod720(Ang,CGradosCiclo);
    presion1 = presionr(i,2);
    if i == NPC;  
        presion2 = presionr(1,2); 
    else
        presion2 = presionr(i + 1,2);
    end
    pm = (presion1 + presion2) / 2;
    [hi,volumen1]=DistPistonCulataDef(intang,NPC,Ang,Engine,n,presion1,factp,facti,vcc,CRevCiclo);
    [hi,volumen2]=DistPistonCulataDef(intang,NPC,Ang+intang,Engine,n,presion2,factp,facti,vcc,CRevCiclo);
    if and(Ang >= -180,Ang < 180);
        wtc = wtc + pm * (volumen2 - volumen1); % Trabajo indicado
    else
        wta = wta + pm * (volumen2 - volumen1); %Trabajo linea de admision
    end
    Ang = Ang + intang;
end
pmi = wtc / Engine.VD;
pmb = wta / Engine.VD;
end
