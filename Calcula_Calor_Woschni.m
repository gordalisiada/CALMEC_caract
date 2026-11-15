function [ h,qw ] = Calcula_Calor_Woschni(Engine,Ang,v_n,Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,T,hi,TCUL,TPIS,TCIL,inc)
%Calcula Woschni

k_nodis=exp(-0.200679*(Engine.CTM^0.431262));

if k_nodis>1
    k_nodis=1;
end

ratio_ctms = (((Engine.DB / Engine.D)^ 2) / k_nodis);
X = ratio_ctms + (1 / ((cosh(Ang / 100)) ^ 40 + (ratio_ctms / (1 - ratio_ctms))));
cu_prima = ((Engine.D / Engine.DB)^2) * Engine.CTM * (Engine.DB / 2) * 2 * pi * v_n;
cu = k_nodis * cu_prima * X;
CM = 2 * Engine.S * v_n;
c1 = Adjustment.CW1 + Adjustment.CW2 * (cu / CM);

if Engine.Type == 1 % Combustion
    parr = pre_RCA * ((vol_RCA / vol)^1.36);
    COMB = ((Engine.VD * temp_RCA) / (pre_RCA * vol_RCA)) * (pre - parr);
elseif Engine.Type == 0 ||  Engine.Type == 2 % Motoring and skip fire
    COMB = 0;
end

C = Adjustment.C; % 0.012
C2 = Adjustment.C2; % 0.001
b = Adjustment.b; % 0.8
h= C *Engine.D ^ (b-1) * T ^ (0.75-1.62*b) * pre ^ b * (c1 * CM + C2 * COMB) ^ b;
% h= 0.012 *Engine.D ^ (-0.2) * T ^ (-0.53) * pre ^ 0.8 * (c1 * CM + 0.001 * COMB) ^ 0.8;

areacul = pi * (((Engine.D)^2)/4);
AreaPiston = Engine.AP;
areapis = AreaPiston;
areacil = (Engine.HLI+hi) * pi * Engine.D; % Incluye area del cilindro al PMS
% areacil = hi * pi * Engine.D; % No incluye area del cilindro al PMS
ccul = inc * h * areacul * (T - TCUL);
cpis = inc * h * areapis * (T - TPIS);
ccil = inc * h * areacil * (T - TCIL); %4 * ((VCIL - VPMS) / D * (TGAS - TCIL)))
% ccul = (h * areacul * (T - TCUL))/(CGradosCiclo*v_n);
% cpis = (h * areapis * (T - TPIS))/(CGradosCiclo*v_n);
% ccil = (h * areacil * (T - TCIL))/(CGradosCiclo*v_n);
qw = ccul + cpis + ccil;
end