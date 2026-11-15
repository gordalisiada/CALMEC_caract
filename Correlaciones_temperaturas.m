function [tpis,tcul,tcil]=Correlaciones_temperaturas(Engine,v_n,dencarga,PME,v_Tref)
Cm=2*Engine.S*v_n;
PME_bar=PME/100000;
%Temperatura del piston
tpis=v_Tref+(Engine.C1pis*(dencarga*Cm)^0.8)+Engine.C2pis*PME_bar;
%Temperatura de la culata
tcul=v_Tref+(Engine.C1cul*(dencarga*Cm)^0.8)+Engine.C2cul*PME_bar;
%Temperatura del cilindro
tcil=v_Tref+(Engine.C1cil*(dencarga*Cm)^0.8)+Engine.C2cil*PME_bar;
tcil=tcil+273.15; %conv de ºC a K
tpis=tpis+273.15; %conv de ºC a K
tcul=tcul+273.15; %conv de ºC a K
end
