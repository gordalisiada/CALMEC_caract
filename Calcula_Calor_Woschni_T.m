function [h,qw] = Calcula_Calor_Woschni_T(Engine,Ang,v_n,vmed,Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,T,hi,TCUL,TPIS,TCIL,inc,CGradosCiclo,Tumble)
% Calcula_Calor_Woschni_T calculates the heat transfer by using a gas speed
% model for engines with Tumble-predominant flow in the combustion chamber

% Piston mean speed
CM = 2 * Engine.S * v_n; % m/s


if Engine.Type == 1 % Combustion
    parr = pre_RCA * ((vol_RCA / vol)^1.36);
    COMB = ((Engine.VD * temp_RCA) / (pre_RCA * vol_RCA)) * (pre - parr);
elseif Engine.Type == 0 ||  Engine.Type == 2 % Motoring and skip fire
    COMB = 0;
end

C = Adjustment.C; % 0.012
C2 = Adjustment.C2; % 0.001
b = Adjustment.b; 

% Wiebe equation
Vw = exp(-Tumble.c1*((Ang-Tumble.a1)/(Tumble.a2-Tumble.a1))^Tumble.c2);

% Gas speed
% Vg = Adjustment.CW1*vmed*Vw + CM*Tumble.k1k2*Adjustment.CW1 + C2*COMB;
Vg = Tumble.rt*Adjustment.CW1*vmed*Vw + Adjustment.CW1*CM + C2*COMB;
% Heat transfer coefficient
h= C *Engine.D ^ (b-1) * T ^ (0.75-1.62*b) * pre ^ b * Vg ^ b;

% Combustion chamber area
areacul = pi * (((Engine.D)^2)/4);
AreaPiston = Engine.AP;
areapis = AreaPiston;
areacil = (Engine.HLI+hi) * pi * Engine.D;

% Heat transfer through each wall
ccul = inc * h * areacul * (T - TCUL);
cpis = inc * h * areapis * (T - TPIS);
ccil = inc * h * areacil * (T - TCIL);

% Total heat transfer
qw = ccul + cpis + ccil;
end