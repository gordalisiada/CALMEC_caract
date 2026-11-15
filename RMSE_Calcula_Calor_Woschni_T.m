function [RMSE_T] = RMSE_Calcula_Calor_Woschni_T(path,test_name,intang,Identifier,Engine,v_n,vmed,Adjustment,TCUL,TPIS,TCIL,inc,Tumble,C)

for i = 1 : length(test_name)
    
    Temporal = importdata([path 'Base/' cell2mat(test_name(i)) '_' Identifier '_Base.dat']);
    Ang = Temporal(2:end-1,1);
    pre = Temporal(2:end-1,2)*10^5;
    Qn  = Temporal(2:end-1,23);
    T   = Temporal(2:end-1,8);
    hi  = Temporal(2:end-1,32);
    %Calcula Woschni
    
    % k_nodis=exp(-0.200679*(Engine.CTM^0.431262));
    % if k_nodis>1
    %     k_nodis=1;
    % end
    % ratio_ctms = (((Engine.DB / Engine.D)^ 2) / k_nodis);
    % X = ratio_ctms + (1 / ((cosh(Ang / 100)) ^ 40 + (ratio_ctms / (1 - ratio_ctms))));
    % cu_prima = ((Engine.D / Engine.DB)^2) * Engine.CTM * (Engine.DB / 2) * 2 * pi * v_n;
    % cu = k_nodis * cu_prima * X;
    CM = 2 * Engine.S * v_n;
    % c1 = Adjustment.CW1 + Adjustment.CW2 * (cu / CM);
    % d = Engine.d;
    % if Engine.Type == 1 % Combustion
    %     parr = pre_RCA * ((vol_RCA / vol)^1.36);
    %     COMB = ((Engine.VD * temp_RCA) / (pre_RCA * vol_RCA)) * (pre - parr);
    % elseif Engine.Type == 0 ||  Engine.Type == 2 % Motored and skip fire
    %     COMB = 0;
    % end
    
    % Tumble model
%     GEOM.c1 = 6.908;
%     GEOM.c2 = 6;
    % GEOM.a1 = -35;
    % GEOM.a2 = 17;
    % k1 = 0.5;
    % k2 = 30;
%     Vw = exp(-Tumble.c1*((Ang-Tumble.a1)/(C(1)-Tumble.a1)).^C(2));
    Vw = exp(-Tumble.c1*((Ang-C(1))/(C(2)-C(1))).^6);
%     Vg = CM(i)*Tumble.k1+(C(3)*vmed(i)*Vw);
    Vg = CM(i)*Tumble.k1+(Adjustment.CW1*vmed(i)*Vw);
    h= 0.012 *Engine.D ^ (-0.2) * T .^ (-0.53) .* pre .^ 0.8 .* Vg .^ 0.8;
    
    areacul = pi * (((Engine.D)^2)/4);
    AreaPiston=Engine.AP;
    areapis=AreaPiston;
    areacil = (Engine.HLI+hi) * pi * Engine.D; % Incluye area del cilindro al PMS
    % areacil = hi * pi * Engine.D; % No incluye area del cilindro al PMS
    ccul = inc .* h .* areacul .* (T - TCUL(i));
    cpis = inc .* h .* areapis .* (T - TPIS(i));
    ccil = inc .* h .* areacil .* (T - TCIL(i)); %4 * ((VCIL - VPMS) / D * (TGAS - TCIL)))
    % ccul = (h * areacul * (T - TCUL))/(CGradosCiclo*v_n);
    % cpis = (h * areapis * (T - TPIS))/(CGradosCiclo*v_n);
    % ccil = (h * areacil * (T - TCIL))/(CGradosCiclo*v_n);
    qw = (ccul + cpis + ccil);
    qn = Qn*intang;
    RMSE(i) = sqrt(mean((qn-qw).^2));
    
end

RMSE_T = sum(RMSE);

end