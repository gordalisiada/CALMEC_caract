function [P] = pressure2(inst_signals_path,test_name,Instr,Adjustment,v_n)
%This function reads the binary files, phase them and correct the offset.

% Load the signal pressure (with noise, offset and no angle reference)
% NF means no filtered
P=bin2pressure([inst_signals_path test_name],Instr);

% % The offset is corrected if the pressure has no reference
if Instr.Pr_adm ~= 0  
  offset = Instr.Pr_adm - min(P);  
  P = P+offset;
end
num_tests = 1;
% Filter
%___________________________________________________
%PRESSURE SIGNALS ARE AVERAGED AND FILTERED % modificado prueba
% [P_f,p]=filtering(P,num_tests,Instr,v_n);%p_nc_fil is filtered, p is filtered and averaged


% Averaged, phased and angle reference created
%___________________________________________________

% Mean pressure signal over angle is then calculated
Pmean = zeros(Instr.npc,1);
for i = 1:Instr.npc
    Pacc = 0;
    
    for n=1:Instr.nc
        Ptemp = Pacc+P(i);
        Pacc = Ptemp;
    end
    
    Pmean(i) = Pacc/Instr.nc;
end

% The angle reference is created
desfase = (round((Adjustment.desfasetot)*10))/10; % Just 1 decimal
crank_angle = zeros(Instr.npc,1);

% The quadrant of the phase has to be determined in order to create the
% angle reference correctly
if desfase > 180
    crank_angle(1,1) = -desfase-360;
    desfase180 = 1;
else
    crank_angle(1,1) = -desfase;
    desfase180 = 0;
end

% The angle reference is created
for i = 1:Instr.npc-1
crank_angle(i+1,1) = crank_angle(i)+720/Instr.npc;
end

% Mean pressure signal over angle
clear P
% TDC is now in zero
P(:,1) = crank_angle; 
P(:,2) = Pmean;
% The signal must beginn at "-Adjustment.desfasetot"
% The signal beggining should be corrected
if desfase180 == 1;
    for i = 1:Instr.npc
         if P(i,1)<=-desfase
              m = n+1;
              n = m;
         end
    end
         Ptempi = P(n+1:Instr.npc,2);
         Ptempf = P(1:n,2);
         clear P
         P(:,1) = crank_angle+360;
    
%  If the phase is after TDC (In the signal graph)
else
    for i = 1:Instr.npc
         if P(i,1)>=-desfase+540
              m = n+1;
              n = m;
         end
         Ptempi = P(Instr.npc-n:Instr.npc,2);
         Ptempf = P(1:Instr.npc-(n+1),2);
         
    end  
         clear P
         P(:,1) = crank_angle-180;
end

P(:,2) = [Ptempi;Ptempf];

