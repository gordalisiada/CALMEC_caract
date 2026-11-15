function [K,Adjustment,VES_n,END] = Adjusterf(path,saved_path,Engine_Name,Identifier,test_name,num_tests,Adjustment,Imposed,VES,Iteration,VDcorr)
% Función para ajustar los parametros de caracterización del motor

% Ángulo de apertura del escape comun (mínimo) para asegurar igualdad de
% puntos en la matriz
% aae = npcc-VDcorr(:,1)-VDcorr(:,2);
% Crea variable para guardar resultados de RMSE
% RMSE = zeros (num_tests,2);
% Se cargan ficheros de dFQL y Presión para el ajuste 

for i = 1:num_tests
    % Carga archivos dFQL y deltaP
    Temporal = importdata([path 'Base\' cell2mat(test_name(i)) '_' Identifier '_Base.dat']);
    AMC_err(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_errp(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    AMC_Qn(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,23);
    AMC_Qw(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,16);
    AMC_pr(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,2);
    AMC_ps(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,27);
    AMC_fql(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,18);
    clear Temporal
    Temporal = importdata([path 'RCO\' cell2mat(test_name(i)) '_' Identifier '_VRCO.dat']);
    AMC_rc(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_rcp(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    clear Temporal
    Temporal = importdata([path 'CDM\' cell2mat(test_name(i)) '_' Identifier '_VCDM.dat']);
    AMC_kdef(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_kdefp(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    clear Temporal
    Temporal = importdata([path 'CW1\' cell2mat(test_name(i)) '_' Identifier '_VCW1.dat']);
    AMC_cw1(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_cw1p(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    clear Temporal
    Temporal = importdata([path 'alpha\' cell2mat(test_name(i)) '_' Identifier '_Valpha.dat']);
    AMC_alpha(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_alphap(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    clear Temporal
    Temporal = importdata([path 'Final\' cell2mat(test_name(i)) '_' Identifier '_Final.dat']);
    AMC_All(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_Allp(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    clear Temporal  
    
    % Calculo del error medio cuadrado de cada ensayo
    QF(i,1) = sum(AMC_Qn(:,i))/sqrt(sum((AMC_Qn(:,i)-AMC_Qw(:,i)).^2));
    QF(i,2) = sum(AMC_pr(:,i))/sqrt(sum((AMC_pr(:,i)-AMC_ps(:,i)).^2));
    % Cálculo del error en la Pmax
    QF(i,3) = ((max(AMC_pr)-max(AMC_ps))/max(AMC_pr))*100;
    % Cálculo del RMSE
    QF(i,4) = sqrt((sum((AMC_Qw(:,i)-AMC_Qn(:,i)).^2))/length(AMC_Qw));
    % FQL máxima y mínima
    QF(i,5) = max(AMC_fql(:,i));
    QF(i,6) = min(AMC_fql(:,i));
end

% Crea matriz de RMSE para guardar en Excel
headers_Error = {'Measurement name','QF RoHR','QF P','QF Pmax','%E RoHR',...
    '%E P','%E Pmax','RMSE(RoHR)','Max HR','Min HR'};
cell_RMSE(:,1) = test_name;
cell_RMSE(:,2) = num2cell(QF(:,1));
cell_RMSE(:,3) = num2cell(QF(:,2));
cell_RMSE(:,4) = num2cell(QF(:,3));
cell_RMSE(:,5) = num2cell((1./QF(:,1)).*100);
cell_RMSE(:,6) = num2cell((1./QF(:,2)).*100);
cell_RMSE(:,7) = num2cell(QF(:,3));
cell_RMSE(:,8) = num2cell(QF(:,4));
cell_RMSE(:,9) = num2cell(QF(:,5));
cell_RMSE(:,10) = num2cell(QF(:,6));
cell_RMSE = [headers_Error;cell_RMSE];

% VDcorr =VDcorr.*0;
% Variation of parameters are loaded with the Variable VES   
% VES(1) Vrc
% VES(2) VCDM
% VES(3) VCW
% VES(4) Valpha 
Adjustment_in = Adjustment;
% Se carga el factor de ponderación
A = Adjustment.A;
B = 1-A;
% Se calculan las tendencia del estudio de sensibilidad
% dFQL

err = AMC_err;
eff_rc = AMC_rc;
eff_kdef = AMC_kdef;
eff_cw1 = AMC_cw1;
eff_alpha = AMC_alpha;

rc = eff_rc-err;
rc = sum(rc,2).*Imposed.rcoffset;
kdef = eff_kdef-err;
kdef = sum(kdef,2).*Imposed.CDM;
cw1 = eff_cw1-err;
cw1 = sum(cw1,2).*Imposed.CW1;
alpha = eff_alpha-err;
alpha = sum(alpha,2).*Imposed.desfasetot;

% Pressure
errp = AMC_errp;
eff_rcp = AMC_rcp;
eff_kdefp = AMC_kdefp;
eff_cw1p = AMC_cw1p;
eff_alphap = AMC_alphap;

rcp = eff_rcp-errp;
rcp = sum(rcp,2).*Imposed.rcoffset;
kdefp = eff_kdefp-errp;
kdefp = sum(kdefp,2).*Imposed.CDM;
cw1p = eff_cw1p-errp;
cw1p = sum(cw1p,2).*Imposed.CW1;
alphap = eff_alphap-errp;
alphap = sum(alphap,2).*Imposed.desfasetot;

% Se calcula la matriz de efectos  para  dFQL y P
DA = [rc kdef cw1 alpha];
DAp = [rcp kdefp cw1p alphap]; 
m = 4;
% Si hay valores impuestos, elimina las columnas del ajuste
while m ~= 0
    if DA (:,m) == 0
        DA(:,m) = [];
        DAp(:,m) = [];
        m = m-1;   
    elseif m ~= 0
             m = m-1;
    end   
end
         
% Se calcula la matriz de errores iniciales en la dFQL y en la Presión
err_dFQL = sum(err,2);
err_pressure = sum(errp,2);
At = err_dFQL;  
Atp = err_pressure;

% Solución al sistema de ecuaciones y determinación de los factores K y Kp

% Este bucle esta hecho para darle un poco de rapidez al programa y no
% tener que calcular los factores de corrección si no se van a usar
if A == 1
    % Solo dFQL
    E = -1.*At;
    K = (DA'*DA)\(DA'*E); % Recomienda en vez de K = inv(DA'*DA)*DA'*E;
    K = K';
    Kp = 0.*K;
elseif A == 0
    % Solo Presión
    Ep = -1.*Atp;
    Kp =(DAp'*DAp)\(DAp'*Ep); % Recomienda en vez de Kp = inv(DAp'*DAp)*DAp'*Ep;
    Kp = Kp';
    K = 0.*Kp;
else
    % para 0<A<1 (considera dFQL y P)
    E = -1.*At;
    K = (DA'*DA)\(DA'*E);
    K = K';
    Ep = -1.*Atp;
    Kp =(DAp'*DAp)\(DAp'*Ep);
    Kp = Kp';    
end

% Corrección en dFQL del ajuste para siguiente iteración para K y Kp
% OJO, el orden en el que se ejecuta es importante, primero rcoffset,
% segundo CDM, tercero CW1 y cuarto desfasetot
m = 1;
if Imposed.rcoffset == 1
    rcoffset = Adjustment.rcoffset + (VES(1)*K(m));
    rcoffsetp = Adjustment.rcoffset + (VES(1)*Kp(m));
    m = m+1;
else
    rcoffset = Adjustment.rcoffset;
    rcoffsetp = Adjustment.rcoffset;
end

if Imposed.CDM == 1   
    CDM = Adjustment.CDM + (VES(2)*K(m));
    CDMp = Adjustment.CDM + (VES(2)*Kp(m));
    m = m+1;
else
    CDM = Adjustment.CDM;
    CDMp = Adjustment.CDM;
end
 
if Imposed.CW1 == 1
    CW1 = Adjustment.CW1 + (VES(3)*K(m));
    CW1p = Adjustment.CW1 + (VES(3)*Kp(m));
    m = m+1;
else
    CW1 = Adjustment.CW1;
    CW1p = Adjustment.CW1;
end

if Imposed.desfasetot == 1
    desfasetot = Adjustment.desfasetot + (VES(4)*K(m));
    desfasetotp = Adjustment.desfasetot + (VES(4)*Kp(m));
    m = m+1;
else
    desfasetot = Adjustment.desfasetot;
    desfasetotp = Adjustment.desfasetot;
end

% Se reconstruye vector K y Kp para evitar cambiar el codigo posterior y el
% archivo excel, Kt es la variable temporal para reorganizar K
m = 1;
if Imposed.rcoffset == 1
    Kt(1) = K(m);
    Ktp(1) = Kp(m);
    m = m+1;
else
    Kt(1) = 0;
    Ktp(1)= 0;
end

if Imposed.CDM == 1   
    Kt(2) = K(m);
    Ktp(2) = Kp(m);
    m = m+1;
else
    Kt(2) = 0;
    Ktp(2) = 0;
end
 
if Imposed.CW1 == 1
    Kt(3) = K(m);
    Ktp(3) = Kp(m);
    m = m+1;
else
    Kt(3) = 0;
    Ktp(3) = 0;
end

if Imposed.desfasetot == 1
    Kt(4) = K(m);
    Ktp(4) = Kp(m);
    m = m+1;
else
    Kt(4) = 0;
    Ktp(4) = 0;
end

clear('K','Kp')
K = Kt;
Kp = Ktp;

% Se pondera el ajuste
Adjustment.rcoffset = A.*rcoffset + B.*rcoffsetp;
Adjustment.CDM = A*CDM + B*CDMp;
Adjustment.CW1 = A*CW1 + B*CW1p;
Adjustment.CW2 = Adjustment.CW1/1.7;
Adjustment.desfasetot = A.*desfasetot + B.*desfasetotp;


% Variable a guardar en archivo Excel con resultados de la ultima ejecución
% que se calculará (siguiente en ciclo principal)

%     if Iteration == Adjustment.Iterations-1   
        ADJ(1,1) = Adjustment.rcoffset;
        ADJ(1,2) = Adjustment.CDM;
        ADJ(1,3) = Adjustment.CW1;
        ADJ(1,4) = Adjustment.desfasetot;        
        ADJ(1,5) = Adjustment_in.rcoffset - Adjustment.rcoffset; % Woschni coefficient variation
        Error_end(1,1) = abs(ADJ(1,5))/Adjustment.rcoffset;
        ADJ(1,6) = Adjustment_in.CDM - Adjustment.CDM; % Compression ratio variation
        Error_end(1,2) = abs(ADJ(1,6))/Adjustment.CDM;
        ADJ(1,7) = Adjustment_in.CW1 - Adjustment.CW1; % Phase variation
        Error_end(1,3) = abs(ADJ(1,7))/Adjustment.CW1;
        ADJ(1,8) = Adjustment_in.desfasetot - Adjustment.desfasetot; % Deformation coefficient variation
        Error_end(1,4) = abs(ADJ(1,8))/Adjustment.desfasetot;
        VES_n = ADJ(1,5:8)./2;
        headers = {'RCO','CDM','CW1','alpha','Vrc','VCDM','VCW1','Vphase'};
        if A == 1
            K(1,5:8) = VES';
            cell_values = [K;ADJ];
        elseif B == 1
            Kp(1,5:8) = VES';
            cell_values = [Kp;ADJ];
        else          
            Kcomp = A*K + B*Kp;
            Kcomp(1,5:8) = VES';
            cell_values = [Kcomp;ADJ];
        end
        cell_values = num2cell(cell_values);
        cell = [headers;cell_values];
        xlswrite([saved_path Engine_Name '\' Identifier '_Adjustment.xls'],cell_RMSE,['Quality' num2str(Iteration)]);
        xlswrite([saved_path Engine_Name '\' Identifier '_Adjustment.xls'],cell,['Characterization' num2str(Iteration)]);

%     end

% Variable para determinar cuando salir del bucle principal (Error en
% parámetros menor al 1% y la iteracición es la 3ra mínimo
if Error_end(1,1) > Adjustment.conv || Error_end(1,2) > Adjustment.conv || Error_end(1,3) > Adjustment.conv || Error_end(1,4) > Adjustment.conv || Iteration < Adjustment.Iterations
    END = 'False';
else
    END = 'True';
end
end