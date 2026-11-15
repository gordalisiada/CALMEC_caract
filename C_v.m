function [Cv,cv_a,cv_f,cv_q] = C_v(T,Ya,Yf,Yq,FUELT,COMBT)
% Calcula el calor específico a volumen constante

cv_a = -10.4199 * T ^ 0.5 + 2522.88 - 67227.1 * T ^ (-0.5) + 917124.4 * T ^ (-1) - 4174853.6 * T ^ (-1.5);

% GASOIL
cv_f_gasoil = -256.4 + 6.95372 * T - 0.00404715 * T ^ 2 + 0.000000910259 * T ^ 3 + 1458487 * T ^ (-2);  %Octavio, 22-09-98
cv_q_gasoil = 641.154 + 0.43045 * T - 0.0001125 * T ^ 2 + 0.000000008979 * T ^ 3;

% GASOLINA
if T < 1000
    cv_f_gasolina = -12291002.2 * T ^ -2 + 227580.041 * T ^ -1 - 1545.51269 + 10.8382363 * T - 0.00837844 * T ^ 2 + 0.0000032557 * T ^ 3 - 0.00000000040429 * T ^ 4 - 72.78128689;
else
    cv_f_gasolina = 984559799 * T ^ -2 - 3394060.95 * T ^ -1 + 5673.52925 + 1.036209 * T - 0.00036926 * T ^ 2 + 0.000000052754 * T ^ 3 - 2.7797E-12 * T ^ 4 - 72.78128689 + 0.0312498;
end

cv_q_gasolina = 655.1103865 + 0.401687993 * T - 0.0000698091 * T ^ 2 - 0.00000000931055 * T ^ 3 + 2.53355E-12 * T ^ 4;

if FUELT == 2 % Mezcla
    if COMBT == 0 && FUELT == 0 % Compresión y Gasoil
        cv_f1 = cv_f_gasoil;
        cv_q1 = cv_q_gasoil;
    elseif COMBT == 0 && FUELT == 1 % Compresión y Gasolina
        cv_f1 = cv_f_gasolina;
        cv_q1 = cv_q_gasolina;
    elseif COMBT == 1 && FUELT == 0 % Provocado y Gasoil
        cv_f2 = cv_f_gasoil;
        cv_q2 = cv_q_gasoil;
    elseif COMBT == 1 && FUELT == 1 % Provocado y Gasolina
        cv_f2 = cv_f_gasolina;
        cv_q2 = cv_q_gasolina;
    end
    %cv_f = ens.ConfiguracionFluidos.YFUEL1 * cv_f1 + ens.ConfiguracionFluidos.YFUEL2 * cv_f2;
    %Yq1_BLEND = ens.ConfiguracionFluidos.Xq1_BLEND * ens.ConfiguracionFluidos.PMC1 / ens.ConfiguracionFluidos.PMC;
    %cv_q = ens.ConfiguracionFluidos.Xq1_BLEND * cv_q1 + ens.ConfiguracionFluidos.Xq1_BLEND * cv_q2;
elseif FUELT == 0 || FUELT == 1 % Gasoil o Gasolina
    if FUELT == 0 % Gasoil
        cv_f = cv_f_gasoil;
        cv_q = cv_q_gasoil;
    elseif FUELT == 1 % Gasolina
        cv_f = cv_f_gasolina;
        cv_q = cv_q_gasolina;
    end
end

Cv = Ya*cv_a+Yf*cv_f+Yq*cv_q;

end
