function [ test,test_name,num_files ] = test_load(mean_var_file,Imposed,cil,type)
% This function creates an estructure with the mean parameters from all tests,
% for a variable distribution engine
% read from Mean_variables.xls

% MEAN VARIABLES FROM ALL TESTS ARE LOADED AND CONVERTED TO IS UNITS
[numeric,var_name] = xlsread(mean_var_file,'Mean');

k = size(var_name);
num_files = k(1)-2;
test_name = var_name(3:k(1),1);

test.Pc     = numeric(:,1)*100;     % Atmospheric pressure [Pa]
test.Tatm   = numeric(:,2)+273.15;  % Atmospheric temperature [K]
test.n      = numeric(:,4)/60;      % Speed [rev/s]
test.MEN    = numeric(:,5);         % Torque [N*m]
test.Pa     = numeric(:,6)*100000;  % Inlet pressure [Pa]
test.Ta     = numeric(:,7)+273.15;  % Inlet temperature [K]
test.Pe     = numeric(:,8)*100000;  % Exhaust pressure [Pa]
test.Te     = numeric(:,9)+273.15;  % Exhaust temperature [K]
test.GA     = numeric(:,10)/1000;   % Air mass flow [kg/s]
test.GF     = numeric(:,11)/1000;   % Fuel mass flow [kg/s]
test.Tf     = numeric(:,12)+273.15;   % Fuel temperature [K]
test.Tref   = numeric(:,13);        % Outlet water temperature [K]
% test.TF     = numeric(:,15);        % Fuel temperature [K]
test.GBLBY  = numeric(:,17);
test.GEGR   = numeric(:,18)/1000;   % EGR mass flow [kg/s]
test.AAA    = numeric(:,27);
test.RCA    = numeric(:,28);
test.AAE    = numeric(:,29);
test.RCE    = numeric(:,30);
test.PCR    = numeric(:,31);        % *100000 Common rail pressure [Pa]
test.N_iny  = numeric(:,32);        % Number of injections [-]


% If retarded combustion
if strcmp(Imposed.Ajcomb,'yes')
   test.AAE  = numeric(:,33);
end

%Injection setting
if type == 1 
    test.SOI1 = numeric(:,33);        % Start Of Energizing time [cad]
    test.MF1 = numeric(:,34);%*1e-6;    % Injection #1 fuel mass per cycle [g] (activate *1e-6 to [kg])
    test.SOI2 = numeric(:,35);
    test.MF2 = numeric(:,36);%*1e-6;
    test.SOI3 = numeric(:,37);
    test.MF3 = numeric(:,38);%*1e-6;
    test.SOI4 = numeric(:,39);
    test.MF4 = numeric(:,40);%*1e-6;
    test.SOI5 = numeric(:,41);
    test.MF5 = numeric(:,42);%*1e-6;
    test.SOI6 = numeric(:,43);
    test.MF6 = numeric(:,44);%*1e-6;
    test.SOI7 = numeric(:,45);
    test.MF7 = numeric(:,46);%*1e-6;
    test.SOI8 = numeric(:,47);
    test.MF8 = numeric(:,48);%*1e-6;  
end
% Select the cylinder execution
if strcmp(cil,'cil1')
    test.mrca     = numeric(:,49)/1000;    % IVC mass [kg]
    test.mbbcalc  = numeric(:,50)/1000000; % Blow By mass [kg]
    test.CBB      = numeric(:,51);         % Blow By coefficient [-]
    test.Tpis     = numeric(:,52)+273.15;  % Piston mean temperature [K]
    test.Tcul     = numeric(:,53)+273.15;  % Cilinder head mean temperature [K]
    test.Tcil     = numeric(:,54)+273.15;  % Cilinder mean temperature [K]
    test.RendRet  = numeric(:,55);
    test.mresi    = numeric(:,56);
    test.vmed     = numeric(:,57);
    % Trapping ratio
elseif strcmp(cil,'cil2')
    test.mrca     = numeric(:,58)/1000;    % IVC mass [kg]
    test.mbbcalc  = numeric(:,59)/1000000; % Blow By mass [kg]
    test.CBB      = numeric(:,60);         % Blow By coefficient [-]
    test.Tpis     = numeric(:,61)+273.15;  % Piston mean temperature [K]
    test.Tcul     = numeric(:,62)+273.15;  % Cilinder head mean temperature [K]
    test.Tcil     = numeric(:,63)+273.15;  % Cilinder mean temperature [K]
    test.RendRet  = numeric(:,64);
    test.mresi    = numeric(:,65);
    test.vmed     = numeric(:,66);
    % Trapping ratio
elseif strcmp(cil,'cil3')
    test.mrca     = numeric(:,67)/1000;    % IVC mass [kg]
    test.mbbcalc  = numeric(:,68)/1000000; % Blow By mass [kg]
    test.CBB      = numeric(:,69);         % Blow By coefficient [-]
    test.Tpis     = numeric(:,70)+273.15;  % Piston mean temperature [K]
    test.Tcul     = numeric(:,71)+273.15;  % Cilinder head mean temperature [K]
    test.Tcil     = numeric(:,72)+273.15;  % Cilinder mean temperature [K]
    test.RendRet  = numeric(:,73);
    test.mresi    = numeric(:,74);
    test.vmed     = numeric(:,75);
    % Trapping ratio   
elseif strcmp(cil,'cil4')
    test.mrca     = numeric(:,76)/1000;    % IVC mass [kg]
    test.mbbcalc  = numeric(:,77)/1000000; % Blow By mass [kg]
    test.CBB      = numeric(:,78);         % Blow By coefficient [-]
    test.Tpis     = numeric(:,79)+273.15;  % Piston mean temperature [K]
    test.Tcul     = numeric(:,80)+273.15;  % Cilinder head mean temperature [K]
    test.Tcil     = numeric(:,81)+273.15;  % Cilinder mean temperature [K]
    test.RendRet  = numeric(:,82);
    test.mresi    = numeric(:,83);
    test.vmed     = numeric(:,84);
    % Trapping ratio
end





