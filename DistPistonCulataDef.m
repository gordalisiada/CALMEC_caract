function [HI,Vdef]= DistPistonCulataDef(intang,NPC,angulo,Engine,n,pre,factp,facti,vcc,CRevCiclo)
     
h_ahora = DistPistonCulata(angulo,Engine);
h_antes=DistPistonCulata(angulo-intang,Engine);
h_luego=DistPistonCulata(angulo+intang,Engine);
inc = (CRevCiclo / (n * NPC));
ace = (h_antes + h_luego - 2*h_ahora) / inc^2;
y_total = (pre * factp - ace * facti);
HI = h_ahora + y_total;
DPC=DistPistonCulata(angulo,Engine);
vol= vcc + (pi * Engine.D ^ 2 / 4)*DPC;
nueva_vcc = vcc + Engine.D ^ 2 * pi * y_total / 4;
Vdef = vol - vcc + nueva_vcc;
end

