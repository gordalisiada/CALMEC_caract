clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked')

%% PATHS AND NAMES DETERMINATION
% Engine name
Engine_Name = 'DV6C_Balances_Arr';
% Identifier
Identifier = 'CHARAC';
% Cilinder
Current_Cyl = 1;
% Select the path where the results are
path = ['Save_Data\DAT\' Engine_Name '\' Identifier '_cil' num2str(Current_Cyl) '\'];


%% LOAD AND INITIALIZE DATA
% Configuration
Ident = Identifier;
file = [Engine_Name '.xlsx'];
conf_file = ['Configuration\' file];
% Mean values of all test are loaded
[Adjustment,Imposed,cylinder,PolyEx,Identifier] = charac_conf(conf_file,Current_Cyl,Ident);
[v,test_name,num_tests] = test_vd(conf_file,Imposed,cylinder.cil);
Engine = engine_conf(conf_file);

% Initialize variables
alpha_in = zeros(num_tests,1);
alpha_ad = zeros(num_tests,1);
alpha_in_Hoh = zeros(num_tests,1);
alpha_ad_Hoh = zeros(num_tests,1);

% Near angle position(+- 15) 
a1 = 241;
a2 = 295;
% Polynomial resolution
res = 1000;
% Speed [rpm]
N = v.n.*60;
% Revolutions per cycle
CRevCiclo = 2;
% Samples per cycle
NPC = 1440;
% Angular step
intang = 0.5;

%% MAIN CALCULATION
for i = 1 : num_tests
    
    % Load instantaneous results
    name_in = ['Initial_' char(test_name(i)) '.dat'];
    DATA_in = importdata([path name_in],' ');
    name_ad = ['Adjusted_' char(test_name(i)) '.dat']; 
    DATA_ad = importdata([path name_ad],' ');
    
    
    %% Initial
    % Load angle
    ang_in = DATA_in(a1:a2,1);
    ang1 = ang_in(1);
    ang2 = ang_in(end);
    ang_in_res(:,1) = linspace(ang1,ang2,res); 
    clear('ang1','ang2')
    % Load pressure
    P0_in = DATA_in(a1:a2,2)*100000;
    Ph = polyfit(ang_in,P0_in,6);
    P_in = Ph(1).*ang_in_res.^6+Ph(2).*ang_in_res.^5+Ph(3).*ang_in_res.^4+Ph(4).*ang_in_res.^3+Ph(5).*ang_in_res.^2+Ph(6).*ang_in_res+Ph(7);
    [Pmax_in,IPmax_in] = max(P_in);
    clear Ph
    % Load volume
    V0_in = DATA_in(a1:a2,3);
    Vh = polyfit(ang_in,V0_in,6);
    V_in = Vh(1).*ang_in_res.^6+Vh(2).*ang_in_res.^5+Vh(3).*ang_in_res.^4+Vh(4).*ang_in_res.^3+Vh(5).*ang_in_res.^2+Vh(6).*ang_in_res+Vh(7);
    [Vmin_in,IVmin_in] = min(V_in);
    clear Vh
    % Load gas temperature
    Tg0_in = DATA_in(a1:a2,8);
    Th = polyfit(ang_in,Tg0_in,6);
    Tg_in = Th(1).*ang_in_res.^6+Th(2).*ang_in_res.^5+Th(3).*ang_in_res.^4+Th(4).*ang_in_res.^3+Th(5).*ang_in_res.^2+Th(6).*ang_in_res+Th(7);
    Tmax_in = Tg_in(IPmax_in);
    clear Th
    % Load gas blow by mass
    mbb0_in = DATA_in(a1:a2,9);
    mh = polyfit(ang_in,mbb0_in,6);
    mbb_in = mh(1).*ang_in_res.^6+mh(2).*ang_in_res.^5+mh(3).*ang_in_res.^4+mh(4).*ang_in_res.^3+mh(5).*ang_in_res.^2+mh(6).*ang_in_res+mh(7);
    mbbmax_in = mbb_in(IPmax_in);
    clear mh
    % Load heat transfer Woschni model
    Qw0_in = DATA_in(a1:a2,16);
    Qh = polyfit(ang_in,Qw0_in,6);
    Qw_in = Qh(1).*ang_in_res.^6+Qh(2).*ang_in_res.^5+Qh(3).*ang_in_res.^4+Qh(4).*ang_in_res.^3+Qh(5).*ang_in_res.^2+Qh(6).*ang_in_res+Qh(7);
%     [Qw_max_grad_in,IQw_max_in] = max(Qw_in); % J/º
    Qw_max_grad_in = Qw_in(IPmax_in)*intang;
    Qw_max_in = Qw_max_grad_in/(CRevCiclo/v.n(i)/NPC);
    clear Qh
    % Determines Pmax and Vmin angle
    angPmax_in = ang_in_res(IPmax_in);
    angVmin_in = ang_in_res(IVmin_in);
    
    % Calculates thermal phase
    alpha_in(i,1) = angVmin_in-angPmax_in;
    
    %% Adjusted
    % Load angle
    ang_ad = DATA_ad(a1:a2,1);
    ang1 = ang_ad(1);
    ang2 = ang_ad(end);
    ang_ad_res(:,1) = linspace(ang1,ang2,res);
    clear('ang1','ang2')
    % Load pressure
    P0_ad = DATA_ad(a1:a2,2)*100000;
    Ph = polyfit(ang_ad,P0_ad,6);
    P_ad = Ph(1).*ang_ad_res.^6+Ph(2).*ang_ad_res.^5+Ph(3).*ang_ad_res.^4+Ph(4).*ang_ad_res.^3+Ph(5).*ang_ad_res.^2+Ph(6).*ang_ad_res+Ph(7);
    [Pmax_ad,IPmax_ad] = max(P_ad);
    clear Ph
    % Load volume
    V0_ad = DATA_ad(a1:a2,3);
    Vh = polyfit(ang_ad,V0_ad,6);
    V_ad = Vh(1).*ang_ad_res.^6+Vh(2).*ang_ad_res.^5+Vh(3).*ang_ad_res.^4+Vh(4).*ang_ad_res.^3+Vh(5).*ang_ad_res.^2+Vh(6).*ang_ad_res+Vh(7);
    [Vmin_ad,IVmin_ad] = min(V_ad);
    clear Vh
    % Load gas temperature
    Tg0_ad = DATA_ad(a1:a2,8);
    Th = polyfit(ang_ad,Tg0_ad,6);
    Tg_ad = Th(1).*ang_ad_res.^6+Th(2).*ang_ad_res.^5+Th(3).*ang_ad_res.^4+Th(4).*ang_ad_res.^3+Th(5).*ang_ad_res.^2+Th(6).*ang_ad_res+Th(7);
    Tmax_ad = Tg_ad(IPmax_ad);
    clear Th
    % Load gas blow by mass
    mbb0_ad = DATA_ad(a1:a2,9);
    mh = polyfit(ang_ad,mbb0_ad,6);
    mbb_ad = mh(1).*ang_ad_res.^6+mh(2).*ang_ad_res.^5+mh(3).*ang_ad_res.^4+mh(4).*ang_ad_res.^3+mh(5).*ang_ad_res.^2+mh(6).*ang_ad_res+mh(7);
    mbbmax_ad = mbb_ad(IPmax_ad);
    clear mh
    % Load heat transfer Woschni model
    Qw0_ad = DATA_in(a1:a2,16);
    Qh = polyfit(ang_ad,Qw0_ad,6);
    Qw_ad = Qh(1).*ang_ad_res.^6+Qh(2).*ang_ad_res.^5+Qh(3).*ang_ad_res.^4+Qh(4).*ang_ad_res.^3+Qh(5).*ang_ad_res.^2+Qh(6).*ang_ad_res+Qh(7);
%     [Qw_max_grad_ad,IQw_max_ad] = max(Qw_ad); % J/º
    Qw_max_grad_ad = Qw_ad(IPmax_ad)*intang;
    Qw_max_ad = Qw_max_grad_ad/(CRevCiclo/v.n(i)/NPC);
    clear Qh
    % Determines Pmax and Vmin angle
    angPmax_ad = ang_ad_res(IPmax_ad);
    angVmin_ad = ang_ad_res(IVmin_ad);
    
    % Calculates thermal phase
    alpha_ad(i,1) = angVmin_ad-angPmax_ad;
    
    %% Hohenberg
    lambda = Engine.LM / Engine.LB;
    % r = (RU / v.PMA);
    r = 287;
    k1 = (Engine.VD / 2) * (1 + lambda);
    
    % Main calculation (Initial)
    W = 2 * pi * v.n(i);
    RO = Pmax_in / (r * Tmax_in);
    [Cv_in,~,~,~] = C_v(Tmax_in,1,0,0,0,0);
    % Cv = CVa * (1 - YqRCA) + CVf * 0 + CVq * YqRCA;
    gamma = 1 + r / Cv_in;
    fiq_in = (Qw_max_in * r) / ((Cv_in + r) * Pmax_in * k1 * W); %perdidas por calor
    fiq_in = fiq_in * 180 / pi;
    
    pcri = Pmax_in * (2 / (gamma + 1)) ^ (gamma / (gamma - 1));
    FI = (pcri / Pmax_in) ^ (2 / gamma) - (pcri / Pmax_in) ^ ((gamma + 1) / gamma);
    FI = FI * (gamma / (gamma - 1)) * Pmax_in / (Pmax_in - pcri);
    FI = FI ^ 0.5 ;%coeficiente  de compresibilidad
    fil_in = v.CBB(i) * Engine.CFBB * Engine.D * FI * (2 * (Pmax_in - pcri) / RO) ^ 0.5;  %coef_bb
    fil_in = fil_in / (W * k1) ;   %perdidas por masa
    fil_in = fil_in * 180 / pi ;   %pasar a grados
    
    % Main calculation (Adjusted)
    W = 2 * pi * v.n(i);
    RO = Pmax_ad / (r * Tmax_ad);
    [Cv_ad,~,~,~] = C_v(Tmax_ad,1,0,0,0,0);
    % Cv = CVa * (1 - YqRCA) + CVf * 0 + CVq * YqRCA;
    gamma = 1 + r / Cv_ad;
    fiq_ad = (Qw_max_ad * r) / ((Cv_ad + r) * Pmax_ad * k1 * W); %perdidas por calor
    fiq_ad = fiq_ad * 180 / pi;
    
    pcri = Pmax_ad * (2 / (gamma + 1)) ^ (gamma / (gamma - 1));
    FI = (pcri / Pmax_ad) ^ (2 / gamma) - (pcri / Pmax_ad) ^ ((gamma + 1) / gamma);
    FI = FI * (gamma / (gamma - 1)) * Pmax_ad / (Pmax_ad - pcri);
    FI = FI ^ 0.5 ;%coeficiente  de compresibilidad
    fil_ad = v.CBB(i) * Engine.CFBB * Engine.D * FI * (2 * (Pmax_ad - pcri) / RO) ^ 0.5;  %coef_bb
    fil_ad = fil_ad / (W * k1);   %perdidas por masa
    fil_ad = fil_ad * 180 / pi;   %pasar a grados
    
    alpha_in_Hoh(i,1) = fiq_in+fil_in;
    alpha_ad_Hoh(i,1) = fiq_ad+fil_ad;
end

%% Plot results

speed = v.n.*60;

figure
hold on
grid on
title('Thermodynamic phase')
plot(speed,alpha_in,'ok','MarkerFaceColor','k')
plot(speed,alpha_ad,'sr','MarkerFaceColor','r')
plot(speed,alpha_in_Hoh,'ok')
plot(speed,alpha_ad_Hoh,'sr')
xlabel('Speed [rpm]')
ylabel('\Delta \alpha_T [CAD]')
legend('Initial','Adjusted','Initial Hohenberg','Adjusted Hohenberg')
hold off

figure
hold on
grid on
title('Thermodynamic phase (Adjusted)')
plot(speed,alpha_ad,'ok')
plot(speed,alpha_ad_Hoh,'or')
plot(speed,alpha_ad-alpha_ad_Hoh,'sb','MarkerSize',5,'MarkerFaceColor','b')
xlabel('Speed [rpm]')
ylabel('\Delta \alpha_T [CAD]')
legend('Comparison','Hohenberg','Comparison-Hohenberg')
hold off

figure
hold on
grid on
title('Thermodynamic phase (P_{max} Vs V_{min})')
plot(speed,alpha_in,'ok')
plot(speed,alpha_ad,'or')
plot(speed,alpha_ad-alpha_in,'sb','MarkerSize',5,'MarkerFaceColor','b')
xlabel('Speed [rpm]')
ylabel('\Delta \alpha_T [CAD]')
legend('Initial','Adjusted','Difference')
hold off

figure
hold on
grid on
title('Thermodynamic phase (Hohenberg)')
plot(speed,alpha_in_Hoh,'ok')
plot(speed,alpha_ad_Hoh,'or')
plot(speed,alpha_ad_Hoh-alpha_in_Hoh,'sb','MarkerSize',5,'MarkerFaceColor','b')
xlabel('Speed [rpm]')
ylabel('\Delta \alpha_T [CAD]')
legend('Initial','Adjusted','Difference')
hold off

