function ORD=Obtener_Rc_Dinamica(angulo,Engine,vcc,voldef)
DPC=DistPistonCulata(angulo,Engine);
vol= vcc + (pi * Engine.D ^ 2 / 4)*DPC;
vccdef = voldef - vol + vcc;
ORD = (Engine.VD + vccdef) / vccdef;

end