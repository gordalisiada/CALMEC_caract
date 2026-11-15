function [ status,SOI,EOI,inject_rate,masa_total_inj] = Ejecutar_Tasa( v,ens,n_ens,path,inj_rate,presionr,intang,MFCC )
%Ejecuta_Tasa Select the path to execute Tasa
%   Change the folder to where the files are and then run TASA.exe, returns
% the injection parameters to symulate the instantaneous injection rate

% Delete temporary files from last execution
delete('RAM\Tasa\injection_system_parameters.dat')
delete('RAM\Tasa\injection_parameters.dat')
delete('RAM\Tasa\test_variables.dat')
delete('RAM\Tasa\injection_rate_parameters.dat')
delete('RAM\Tasa\injection_rate.dat')

grabar_system_parameters
grabar_inyection_parameters(v,ens)
grabar_test_variables(v,ens,n_ens)

% Save the main path
oldfolder = cd();
% Change to the path where the inputs files are
cd(path)
% Run TASA.exe
status_exe = system('TASA.exe');
% Informs if TASA.exe runs correctly
if status_exe == 0
    status = 'Ok';
else
    status = 'Error';
end
% Returns to main path
cd(oldfolder )

% Load the injection parameters (SOI and EOI) and create the simulated
% injection rate
[injection_rate,delimiterOut]=importdata([path 'injection_rate.dat']);
[injection_rate_parameters,delimiterOut]=importdata([path 'injection_rate_parameters.dat']);

% Simulate injection rate

x1=inj_rate(:,1);
y1=inj_rate(:,2);
x2=presionr(:,1);
y2=interp1(x1,y1,x2);
y2(isnan(y2))=0;
inject_rate(:,1)=x2;
inject_rate(:,2)=y2;

% Create SOI and EOI variables
SOI = zeros(v.N_iny(ens),1);
EOI = zeros(v.N_iny(ens),1);

n = 1;
for i = 1 : v.N_iny(ens)
    SOI(i,1) = injection_rate_parameters.data(1,n+1);
    EOI(i,1) = injection_rate_parameters.data(1,n+2);
    n = n+2;
end

% Integrates total mass injection 
a=inject_rate(:,2);
masa_total_inj=sum(a)*intang;

%Correction of total mass injection

kconv=MFCC/masa_total_inj;
tasa_real_nc=inj_rate(:,2)*kconv;
acumulada=sum(tasa_real_nc);
k=MFCC/acumulada;  %salen números desproporcionados. Revisar unidades!!!!
% tasa_real=tasa_real_nc*k;
end

