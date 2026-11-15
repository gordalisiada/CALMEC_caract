function Err0 = calc_error_initial(Engine,v_n,path,saved_path,Engine_Name,Identifier,test_name,num_tests,Iteration,VDcorr)
%calc_err_initial Calculate the initial error before any correction
%   Detailed explanation goes here
for i = 1:num_tests
    % Carga archivos dFQL y deltaP
    Temporal = importdata([path 'Base_0\' cell2mat(test_name(i)) '_' Identifier '_Base_0.dat']);
    AMC_ang(:,i)  = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,1);
    AMC_p(:,i)    = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,2);
    AMC_V(:,i)    = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,3);
    AMC_T(:,i)    = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,8);
    AMC_mbb(:,i)  = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,9);
    AMC_Rg(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,7);
    AMC_Cv(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,29);
    AMC_err(:,i)  = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,15);
    AMC_errp(:,i) = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,31);
    AMC_Qn(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,23);
    AMC_Qw(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,16);
    AMC_pr(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,2);
    AMC_ps(:,i)   = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,27);
    AMC_fql(:,i)  = Temporal(VDcorr(i,1)+3:VDcorr(i,1)+VDcorr(i,2)-3,18);
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
    % Max Qn y Qw en el PMS
    short_ang = linspace(-10,10,1000);
    short_p = interp1(AMC_ang(:,i),AMC_p(:,i),short_ang,'spline');
    short_Qw = interp1(AMC_ang(:,i),AMC_Qw(:,i),short_ang,'spline');
    short_Qn = interp1(AMC_ang(:,i),AMC_Qn(:,i),short_ang,'spline');
    short_T = interp1(AMC_ang(:,i),AMC_T(:,i),short_ang,'spline');
    short_mbb = interp1(AMC_ang(:,i),AMC_mbb(:,i),short_ang,'spline');
    short_Rg = interp1(AMC_ang(:,i),AMC_Rg(:,i),short_ang,'spline');
    short_Cv = interp1(AMC_ang(:,i),AMC_Cv(:,i),short_ang,'spline');
    
    [pmaxbar,I] = max(short_p);
    QF(i,7) = -short_ang(I); % Desfase P-V, se pone (-) ya que esta antes del PMS
    QwI = short_Qw(I)*180/pi(); % J/rad
    QnI = short_Qn(I)*180/pi(); % J/rad
    QnI_pico = max(short_Qn)*180/pi(); % J/rad
 
    pmax = pmaxbar*100000; % Pa 
    TI =  short_T(I); % K
    mbbI = short_mbb(I); % kg/s
    RgI =  short_Rg(I); % J/kgK
    CpI =  short_Cv(I) +  RgI; % J/kgK
    N = v_n(i)*60; % rpm
    K1 = (pi*Engine.D^2*Engine.LM/4)*(1+Engine.LM/Engine.LB); % m^3/rad^2
    
    QF(i,8) = ((QwI*RgI/CpI/pmax/K1)+(60*mbbI*RgI*TI/2/pi/N/pmax/K1))*180/pi; % Desfase termodinámico º 
    QF(i,9) = ((QnI*RgI/CpI/pmax/K1)+(60*mbbI*RgI*TI/2/pi/N/pmax/K1))*180/pi; % Desfase termodinámico º
    QF(i,10) = ((QnI_pico*RgI/CpI/pmax/K1)+(60*mbbI*RgI*TI/2/pi/N/pmax/K1))*180/pi; % Desfase termodinámico º
  
    % Error desfase termodinámico
    QF(i,11) = QF(i,8)-QF(i,7);
    QF(i,12) = QF(i,9)-QF(i,7);
    QF(i,13) = QF(i,10)-QF(i,7);
    % Borra las variables usadas
    clear ('pmaxbar','pmax','I','QnI','QnI_pico','QwI','TI','mbb','RgI','CpI','N','K1',...
        'short_ang','short_p','short_Qw','short_Qn','short_T','short_mbb',...
        'short_Rg','short_Cv')

end

% Crea matriz de RMSE para guardar en Excel
headers_Error = {'Measurement name','QF RoHR','QF P','QF Pmax','%E RoHR',...
    '%E P','%E Pmax','RMSE(RoHR)','Max HR','Min HR','Phase','Phase Qw',...
    'Phase Qn','Phase Qn max','Err Phase Qw','Err Phase Qn','Err Phase Qn max'};
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
cell_RMSE(:,11) = num2cell(QF(:,7));
cell_RMSE(:,12) = num2cell(QF(:,8));
cell_RMSE(:,13) = num2cell(QF(:,9));
cell_RMSE(:,14) = num2cell(QF(:,10));
cell_RMSE(:,15) = num2cell(QF(:,11));
cell_RMSE(:,16) = num2cell(QF(:,12));
cell_RMSE(:,17) = num2cell(QF(:,13));
cell_RMSE = [headers_Error;cell_RMSE];

if Iteration == 1
    xlswrite([saved_path Engine_Name '\' Identifier '_Adjustment.xls'],cell_RMSE,'Quality_0');
else
    xlswrite([saved_path Engine_Name '\' Identifier '_Adjustment.xls'],cell_RMSE,'Quality_Final');
end
Err0 = 'True'; % Do nothing!!
end

