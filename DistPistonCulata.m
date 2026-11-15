function DPC=DistPistonCulata(angulo,Engine)
Ang = (((angulo) * pi) / 180);            
DPC = sqrt(((Engine.LM + Engine.LB)^2 - Engine.desc^2)) - (Engine.LM * cos(Ang) + sqrt(Engine.LB^2 - ((Engine.LM * sin(Ang)) - Engine.desc)^2));
end