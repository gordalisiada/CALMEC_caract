function [h,qw] = Calcula_Calor_Woschni_T(Engine,Ang,v_n,vmed,Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,T,hi,TCUL,TPIS,TCIL,inc,CGradosCiclo,Tumble)
% Calcula_Calor_Woschni_T calculates the heat transfer by using a gas speed
% model for engines with Tumble-predominant flow in the combustion chamber

% Piston mean speed
CM = 2 * Engine.S * v_n;

% Wiebe equation
Vw = exp(-Tumble.c1*((Ang-Tumble.a1)/(Tumble.a2-Tumble.a1))^Tumble.c2);

% Gas speed
Vg = CM*Tumble.k1+(Adjustment.CW1*vmed*Vw);

% Heat transfer coefficient
h= 0.012 *Engine.D ^ (-0.2) * T ^ (-0.53) * pre ^ 0.8 * Vg ^ 0.8;

% Combustion chamber area
areacul = pi * (((Engine.D)^2)/4);
AreaPiston=Engine.AP;
areapis=AreaPiston;
areacil = (Engine.HLI+hi) * pi * Engine.D; % Incluye area del cilindro al PMS
% areacil = hi * pi * Engine.D; % No incluye area del cilindro al PMS

% Heat transfer through each wall
ccul = inc * h * areacul * (T - TCUL);
cpis = inc * h * areapis * (T - TPIS);
ccil = inc * h * areacil * (T - TCIL); %4 * ((VCIL - VPMS) / D * (TGAS - TCIL)))
% ccul = (h * areacul * (T - TCUL))/(CGradosCiclo*v_n);
% cpis = (h * areapis * (T - TPIS))/(CGradosCiclo*v_n);
% ccil = (h * areacil * (T - TCIL))/(CGradosCiclo*v_n);

% Total heat transfer
qw = ccul + cpis + ccil;
end