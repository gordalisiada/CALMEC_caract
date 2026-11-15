function [alpha,alpha_geom,alpha_Hoh,error] = Hohenberg (ang0,p0,vol0,T0,mbb0,Qw0,Engine,Rg0,num_tests,CRevCiclo,NPC,intang,v,alpha0,Ajcomb)
% Hohenberg: Estimates the thermal phase by means of the Hohenberg
% formulation.


% Polynomial resolution
res = 1000;
% Initialize variables to save results
alpha_geom = zeros(num_tests,1);
alpha_Hoh = zeros(num_tests,1);
alpha = zeros(num_tests,1);
error = zeros(num_tests,1);

%% MAIN CALCULATION
for i = 1 : num_tests
    % Determines the range to adjust a polynom
    % Near the maximum pressure angle position
    [~,Ipmax0] = max(p0(:,i));
    % Define angle
    if strcmp(Ajcomb,'yes') % If SOI test
        inc = 10/intang;
        a1 = Ipmax0 - inc;
        a2 = Ipmax0;
        ang = ang0(a1:a2,i);
        ang1 = ang0(a1,i);
        ang2 = ang0(a2,i);
    else % Normal motoring test and skip-fired
        inc = 10/intang;
        a1 = Ipmax0 - inc;
        a2 = Ipmax0 + inc;
        ang = ang0(a1:a2,i);
        ang1 = ang0(a1,i);
        ang2 = ang0(a2,i);
    end
    %     ang1 = ang0(a1);
    %     ang2 = ang0(a2);
    
    ang_poly(:,1) = linspace(ang1,ang2,res);
    clear('ang1','ang2')
    % Load pressure
    p = p0(a1:a2,i)*100000;
    ph = polyfit(ang,p,6);
    p_poly = ph(1).*ang_poly.^6+ph(2).*ang_poly.^5+ph(3).*ang_poly.^4+ph(4).*ang_poly.^3+ph(5).*ang_poly.^2+ph(6).*ang_poly+ph(7);
    [pmax,Ipmax] = max(p_poly);
    clear Ph
    % Load volume
    vol = vol0(a1:a2,i);
    volh = polyfit(ang,vol,6);
    vol_poly = volh(1).*ang_poly.^6+volh(2).*ang_poly.^5+volh(3).*ang_poly.^4+volh(4).*ang_poly.^3+volh(5).*ang_poly.^2+volh(6).*ang_poly+volh(7);
    [~,Ivolmin] = min(vol_poly);
    clear Vh
    % Load gas temperature
    T = T0(a1:a2,i);
    Th = polyfit(ang,T,6);
    T_poly = Th(1).*ang_poly.^6+Th(2).*ang_poly.^5+Th(3).*ang_poly.^4+Th(4).*ang_poly.^3+Th(5).*ang_poly.^2+Th(6).*ang_poly+Th(7);
    Tmax = T_poly(Ipmax);
    clear Th
    % Load ideal gas constant
    Rg = Rg0(a1:a2,i);
    Rgh = polyfit(ang,Rg,6);
    Rg_poly = Rgh(1).*ang_poly.^6+Rgh(2).*ang_poly.^5+Rgh(3).*ang_poly.^4+Rgh(4).*ang_poly.^3+Rgh(5).*ang_poly.^2+Rgh(6).*ang_poly+Rgh(7);
    Rgmax = Rg_poly(Ipmax);
    clear Rgh
    % Load gas blow by mass
    mbb = mbb0(a1:a2,i);
    mh = polyfit(ang,mbb,6);
    mbb_poly = mh(1).*ang_poly.^6+mh(2).*ang_poly.^5+mh(3).*ang_poly.^4+mh(4).*ang_poly.^3+mh(5).*ang_poly.^2+mh(6).*ang_poly+mh(7);
    mbbmax = mbb_poly(Ipmax);
    clear mh
    % Load heat transfer Woschni model
    Qw = Qw0(a1:a2,i);
    Qh = polyfit(ang,Qw,6);
    Qw_poly = Qh(1).*ang_poly.^6+Qh(2).*ang_poly.^5+Qh(3).*ang_poly.^4+Qh(4).*ang_poly.^3+Qh(5).*ang_poly.^2+Qh(6).*ang_poly+Qh(7);
    %     [Qw_max_grad_in,IQw_max_in] = max(Qw_in); % J/º
    Qw_max_grad = Qw_poly(Ipmax)*intang;
    Qw_max = Qw_max_grad/(CRevCiclo/v.n(i)/NPC);
    clear Qh
    % Determines Pmax and Vmin angle
    angPmax = ang_poly(Ipmax);
    angVmin = ang_poly(Ivolmin);
    
    % Calculates thermal phase
    alpha_geom(i,1) = angVmin-angPmax;
    
    %% Hohenberg
    lambda = Engine.LM / Engine.LB;
    %     R = Rg(Ipmax,i);
    k1 = (Engine.VD / 2) * (1 + lambda);
    % Main calculation
    W = 2 * pi * v.n(i);
    RO = pmax / (Rgmax * Tmax);
    [Cv,~,~,~] = C_v(Tmax,1,0,0,0,0);
    % Cv = CVa * (1 - YqRCA) + CVf * 0 + CVq * YqRCA;
    gamma = 1 + Rgmax / Cv;
    fiq = (Qw_max * Rgmax) / ((Cv + Rgmax) * pmax * k1 * W); %perdidas por calor
    fiq = fiq * 180 / pi;
    
    pcri = pmax * (2 / (gamma + 1)) ^ (gamma / (gamma - 1));
    FI = (pcri / pmax) ^ (2 / gamma) - (pcri / pmax) ^ ((gamma + 1) / gamma);
    FI = FI * (gamma / (gamma - 1)) * pmax / (pmax - pcri);
    FI = FI ^ 0.5 ;%coeficiente  de compresibilidad
    fil = v.CBB(i) * Engine.CFBB * Engine.D * FI * (2 * (pmax - pcri) / RO) ^ 0.5;  %coef_bb
    fil = fil / (W * k1) ;   %perdidas por masa
    fil = fil * 180 / pi ;   %pasar a grados
    alpha_Hoh(i,1) = fiq+fil;
    
    % Nuevo desfase
    alpha(i,1) = alpha0+angPmax+alpha_Hoh(i,1);
    
    error(i,1) = sqrt((alpha(i,1)-alpha0)/alpha0)^2;
end

% %% Plot results

% speed = v.n.*60;
%
% figure
% hold on
% grid on
% title('Thermodynamic phase')
% plot(speed,alpha_in,'ok','MarkerFaceColor','k')
% plot(speed,alpha_ad,'sr','MarkerFaceColor','r')
% plot(speed,alpha_in_Hoh,'ok')
% plot(speed,alpha_ad_Hoh,'sr')
% xlabel('Speed [rpm]')
% ylabel('\Delta \alpha_T [CAD]')
% legend('Initial','Adjusted','Initial Hohenberg','Adjusted Hohenberg')
% hold off
%
% figure
% hold on
% grid on
% title('Thermodynamic phase (Adjusted)')
% plot(speed,alpha_ad,'ok')
% plot(speed,alpha_ad_Hoh,'or')
% plot(speed,alpha_ad-alpha_ad_Hoh,'sb','MarkerSize',5,'MarkerFaceColor','b')
% xlabel('Speed [rpm]')
% ylabel('\Delta \alpha_T [CAD]')
% legend('Comparison','Hohenberg','Comparison-Hohenberg')
% hold off
%
% figure
% hold on
% grid on
% title('Thermodynamic phase (P_{max} Vs V_{min})')
% plot(speed,alpha_in,'ok')
% plot(speed,alpha_ad,'or')
% plot(speed,alpha_ad-alpha_in,'sb','MarkerSize',5,'MarkerFaceColor','b')
% xlabel('Speed [rpm]')
% ylabel('\Delta \alpha_T [CAD]')
% legend('Initial','Adjusted','Difference')
% hold off
%
% figure
% hold on
% grid on
% title('Thermodynamic phase (Hohenberg)')
% plot(speed,alpha_in_Hoh,'ok')
% plot(speed,alpha_ad_Hoh,'or')
% plot(speed,alpha_ad_Hoh-alpha_in_Hoh,'sb','MarkerSize',5,'MarkerFaceColor','b')
% xlabel('Speed [rpm]')
% ylabel('\Delta \alpha_T [CAD]')
% legend('Initial','Adjusted','Difference')
% hold off
%
