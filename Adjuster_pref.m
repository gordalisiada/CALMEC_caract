function [Kpref,RPC] = Adjuster_pref(path,saved_path,test,Engine_Name,Identifier,Adjustment,VPref,RPC,Kpref,CAD,Iteration)
% Función para ajustar la presión de referencia para cada ensayo

% Se crean los parámetros de corrección para no tenerlos dentro del bucle
% (optimiza velocidad de cálculo)
K = zeros(size(Kpref));
Kp = zeros(size(Kpref));

% Se cargan ficheros de dFQL y Presión para el ajuste 
for i = 1:length(test)
    clear ('AMC_err','AMC_errp','AMC_Pref','AMC_Prefp') 
    % Base Pref
    Temporal = importdata([path 'Base_Pref\' char(test(i,1)) '_' Identifier '_Base_Pref.dat']);
%     Temporal = importdata ([path 'Base_Pref\' cell2mat(test_name(i)) '_' Identifier '_Base.dat']);
    AMC_err = Temporal(:,15);
    AMC_errp = Temporal(:,31);
    clear Temporal
    % Pref
    Temporal = importdata([path 'Pref\' char(test(i,1)) '_' Identifier '_VPref.dat']);
    AMC_Pref = Temporal(:,15);
    AMC_Prefp = Temporal(:,31);
    clear Temporal
  
% Se carga el factor de ponderación
A = Adjustment.A;
B = 1-A;
dim = length(AMC_err);

% Se calculan las tendencia del estudio de sensibilidad

% dFQL
err = AMC_err;
err(1,:) = [];
err([dim-5 ;],:)= [];
dim = length(err);
eff_Pref = AMC_Pref(2:dim+1,1);
Pref = eff_Pref-err;

% Pressure
errp = AMC_errp;
errp(1,:) = [];
errp([dim-5 ;],:)= [];
dim = length(err);
eff_Prefp = AMC_Prefp(2:dim+1,1);
Prefp = eff_Prefp-errp;

% Se calcula la matriz de efectos

DA = Pref;
DAp = Prefp;

% Se calcula la matriz de errores iniciales en la dFQL y en la Presión
At = err;  
Atp = errp;

% Solución al sistema de ecuaciones y determinación de los factores K

    if A == 1
        % Solo dFQL
        E = -1.*At;
        k =(DA'*DA)\(DA'*E);
        K(1,i) = k;
        Kp(1,i) = 0;
    elseif A == 0
        % Solo Presión
        Ep = -1.*Atp;
        kp =(DAp'*DAp)\(DAp'*Ep);
        Kp(1,i) = kp;
        K(1,i) = 0;
    else
        % para 0<A<1 (considera dFQL y P)
        E = -1.*At;
        k =(DA'*DA)\(DA'*E);
        K(1,i) = k;
        Ep = -1.*Atp;
        kp =(DAp'*DAp)\(DAp'*Ep);
        Kp(1,i) = kp;
    end

end

Kpref = A.*K + B.*Kp;

RPC = RPC + (A.*(VPref.*K)+B.*(VPref.*Kp));

% Nombres de los ensayos
headers = cellstr(test');

% Variable a guardar en archivo Excel con resultados de la ultima ejecución
% que se calculará (siguiente en ciclo principal)
%     if Iteration == Adjustment.Iterations-1
        cell_values = [Kpref;RPC];
        cell_values = num2cell(cell_values);
        cell = [headers;cell_values];
        xlswrite([saved_path Engine_Name '\' Identifier '_Adjustment.xls'],cell,['Pref' num2str(Iteration)]);
%     end

end