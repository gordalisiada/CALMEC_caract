function masabb= Calcula_Blow_By(CRevCiclo,pc,pre,n,NPC,Gamma,CBB,Engine,r,temp)

inc = (CRevCiclo / (n * NPC));
if (pc / pre) <= 0.528 ;
 pc = pre * 0.528;
end
if pc > pre;
 ac = sqrt((2 * Gamma / (Gamma - 1)) * ((pre / pc) ^ (2 / Gamma) - (pre / pc) ^ ((Gamma + 1) / Gamma))) * inc;  
else
 ac = sqrt((2 * Gamma / (Gamma - 1)) * ((pc / pre) ^ (2 / Gamma) - (pc / pre) ^ ((Gamma + 1) / Gamma))) * inc; 
end
masabb = CBB * Engine.CFBB  * Engine.D * pre * (1 / sqrt(r * temp)) * ac;
end
 

