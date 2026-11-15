%% CALMEC_CHARAC V7_2%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
clear; clc
%_______INFO_______________________________________________________________
close all
clear all
clc
set(0,'DefaultFigureWindowStyle','docked')
run Clear_RAM
format long g
name = 'CALMEC_CHARAC V7_2'
%% Data to be introduced by the user

% Introduce the name of the xlsx and instantaneous folder where the
% configuration and the pressure signals are
% Engine_Name = 'DW12_V4';
Engine_Name = 'Powerful_2015';
% Introduce the name to the saved data, if you don't change the name the
% previous file will be replaced
Identifier = 'TEST_2026'; %'CHAR06';
% Calculation Options
Type = '.dat'; % Allows '.bin' , '.dat' or 'txt' files
%% Paths

% Load the CONFIGURATION. xlsx file with the required information
file = [Engine_Name '.xlsx'];
conf_file = ['Configuration\' file];
inst_signals_path = ['Instantaneous\' Engine_Name '\'];
saved_path = 'Save_Data\';

%% Start of execution

% If policylinder execution, Ident is the name of the test
Ident = Identifier;

% Load configuration parameters
for Current_Cyl = 1 : 4
    [Adjustment,Imposed,cylinder,PolyEx,Identifier] = charac_conf(conf_file,Current_Cyl,Ident);
    Adjustment_original = Adjustment;
    mkdir(['Save_Data\' 'DAT'])
    mkdir(['Save_Data\DAT\' Engine_Name])
    mkdir(['Save_Data\DAT\' Engine_Name '\' Identifier])
    mkdir(['Save_Data\DAT\' Engine_Name '\' Identifier '\Injection'])
    mkdir(['Save_Data\' Engine_Name])
    mkdir(['Save_Data\' Engine_Name '\' Identifier])
    saved_folder = [saved_path Engine_Name '\' Identifier '\'];
    % ENGINE PARAMETERS ARE LOADED
    Engine = engine_conf(conf_file);
    
    % FLUIDS PARAMETERS ARE LOADED
    Fluid = fluid_conf(conf_file);
    
    % INSTRUMENTATION PARAMETERS ARE LOADED
    Instr = Instr_conf(conf_file,cylinder.cil);
    
    % LOAD TUMBLE PARAMETERS
    if strcmp(Adjustment.Model,'T')
        Tumble = load_tumble(conf_file);
    end
    
    % MEAN VARIABLES FROM ALL TESTS ARE LOADED AND CONVERTED TO IS UNITS
    [v,test_name,num_tests] = test_load(conf_file,Imposed,cylinder.cil,Engine.Type);
    

    % Initial Values
    % End adjustment
    END = 'False';
    % Last run of the cycle
    OUT = 'False';
    % Last phase adjustment (no other parameters are adjusted)
    END_ant = 'False';
    % Motored/Combustion---false is Motored
    if Engine.Type == 0 || Engine.Type == 2
        comb = false;
    elseif Engine.Type == 1
        comb = true;
    end
    
    % Sensitivity study
%     initial_phase = 161.25;
    initial_phase = Adjustment.desfasetot; % Initial phase, must be the first value of all signals
%     if strcmp(cylinder.cil,'cil1') || strcmp(cylinder.cil,'cil4')
%         initial_phase = 369.94;
%     elseif strcmp(cylinder.cil,'cil2') || strcmp(cylinder.cil,'cil3')
%         initial_phase = 549.94;
%     end
    % initial_phase = 369.94; % DV6_mono
    % initial_phase = 346.38; % VOLVO_MD11
    Vcw1 = 2; % Woschni coefficient variation of 2
    Vrc = 0.75; % Compression ratio variation of 0.75
    Valpha = 0.5; % Phase variation of 0.5 degree
    Vkdef = 1; % Deformation coefficient variation of 1
    VPref = ones(1,num_tests);
    VPref = 0.1*VPref; % Reference pressure variation of 100 mbar
    RPC = zeros(1,num_tests);
    Kpref = zeros(1,num_tests); % Correction factor for the reference pressure
    VES = [Vrc Vkdef Vcw1 Valpha];
    
    % Nº of revolutions per cycle
    CRevCiclo = Engine.NOS / 2;
    % Nº of revolutions per cycle
    CGradosCiclo = CRevCiclo * 360;
    % Angular increment
    intang = (CGradosCiclo/Instr.npc);
    % Number of point for the close cycle
    npcc = ones(num_tests,1);
    % Variable distribution correction
    % counter of close cycle
    DVcont = ones(num_tests,1);
    % Initialize iteration counter
    Iteration = 0;
    %% Main Process
    
    while strcmp(OUT,'False')
        % Loop control
        clc
        Iteration = Iteration +1;
        if strcmp(END,'True')
            OUT = 'True';
            Status = ['Last run ' num2str(Iteration) ' | ' char(cylinder.cil)]
        else
            OUT = 'False';
            Status = ['Iteration ' num2str(Iteration) ' | ' char(cylinder.cil) ]
        end
        
        % Sensitivity study for the measurement loaded
        for ES = 1 : 10
            
            % Load the parameter for the study
            if ES == 1
                % Initial error
                Pref = 0;
                filename = [Identifier '_Base_0'];
            elseif ES == 2
                % Initial Pref
                Pref = 1;
                filename = [Identifier '_VPref'];
            elseif    ES == 3
                % CW1
                Adjustment.CW1 = Adjustment.CW1+Vcw1;
                Adjustment.CW2 = Adjustment.CW1/1.7;
                filename = [Identifier '_VCW1';];
                Pref = 0;
            elseif ES == 4
                % RCO
                Adjustment.rcoffset = Adjustment.rcoffset+Vrc;
                Adjustment.CW1 = Adjustment.CW1-Vcw1;
                Adjustment.CW2 = Adjustment.CW1/1.7;
                filename = [Identifier '_VRCO';];
                Pref = 0;
            elseif ES == 5
                % Phase
                Adjustment.desfasetot = Adjustment.desfasetot+Valpha;
                Adjustment.rcoffset = Adjustment.rcoffset-Vrc;
                filename = [Identifier '_Valpha'];
                Pref = 0;
            elseif ES == 6
                % CDM
                Adjustment.CDM = Adjustment.CDM+Vkdef;
                Adjustment.desfasetot = Adjustment.desfasetot-Valpha;
                filename = [Identifier '_VCDM'];
                Pref = 0;
            elseif ES == 7
                % All
                Adjustment.CW1 = Adjustment.CW1+Vcw1;
                Adjustment.CW2 = Adjustment.CW1/1.7;
                Adjustment.rcoffset = Adjustment.rcoffset+Vrc;
                Adjustment.desfasetot = Adjustment.desfasetot+Valpha;
                filename = [Identifier '_Final'];
                Pref = 0;
            elseif ES == 8
                % Base
                Adjustment.CW1 = Adjustment.CW1-Vcw1;
                Adjustment.CW2 = Adjustment.CW1/1.7;
                Adjustment.rcoffset = Adjustment.rcoffset-Vrc;
                Adjustment.desfasetot = Adjustment.desfasetot-Valpha;
                Adjustment.CDM = Adjustment.CDM-Vkdef;
                filename = [Identifier '_Base'];
                Pref = 0;
            elseif ES == 9
                % Reference pressure
                Pref = 0;
                filename = [Identifier '_Base_Pref'];
            elseif ES == 10
                % Reference pressure
                Pref = 1;
                filename = [Identifier '_VPref'];
            end
            % Caution: the paths are vinculated with the function adjustment
            % saved_file_path = [saved_path filename];
            
            
            if (Imposed.pref0 == 0 && ES == 2)||(Imposed.pref == 0 && (ES == 9 || ES == 10))
                continue
            end
            
            
            for ens = 1:num_tests
                % INSTANTANEOUS SIGNALS ARE LOADED
                if strcmp(Type,'.bin')
                    % Open binary files
                    pfiles = [cell2mat(test_name(ens)) '.bin'];
                    presionr = pressure([inst_signals_path char(cylinder.cil) '\'],pfiles,Instr,Adjustment,Engine);
                    %                 if ES == 3
                    %                 presionr(:,1) = presionr(:,1)+0.5;
                    %                 end
                elseif strcmp(Type,'.dat')
                    % Open .Dat files
                    pfiles = [cell2mat(test_name(ens)) '.dat'];
                    presionr = importdata([inst_signals_path char(cylinder.cil) '\' pfiles]);
%                     presionr = presionr.data;
                    % Number of points per cycle
                    %                 NPC = length(presionr(:,:)); % read directly from the pressure signal instead of the configuration
                    %                 [presionr] = cadPresOrder(NPC,CGradosCiclo,intang,presionr);
                    if isstruct(presionr) == 1
                        presionr_(:,1) = presionr.data(1:Instr.npc,1)+(initial_phase-Adjustment.desfasetot);
                        presionr_(:,2) = mean(reshape(presionr.data(:,2),[Instr.npc,Instr.nc]),2)+RPC(1,ens); %presionr.data(1:Instr.npc,2)
                        clear presionr
                        presionr = presionr_;
                        clear presionr_
                    else
                        presionr(:,1) = presionr(:,1)+(initial_phase-Adjustment.desfasetot);
                        presionr(:,2) = presionr(:,2)+RPC(1,ens);
                    end
                    if Pref == 1
                        presionr(:,2) = presionr(:,2)+VPref(1,ens);
                    end
                    % presionr(:,2) = (presionr(:,2)+abs(min(presionr(:,2)))*ones(size(Instr.npc))).*100000;% Pressure in Pascales
                    presionr(:,2) = presionr(:,2).*100000;% Pressure in Pascales
                    n_ens = v.n(ens)*60;

                    % Filtrado de la presion
                    % Fcutrel = 0.3;
                    % order = 50;
                    % d = fdesign.lowpass('N,Fc',order,Fcutrel,1);
                    % Hd = design(d);
                    % presionr(:,3) = filtfilt(Hd.numerator,1,presionr(:,2));

                    % P_smooth = sgolayfilt(presionr(:,2),3,41);
                    % P_res = presionr(:,2) - P_smooth;
                    % 
                    % plot(presionr(:,1),presionr(:,2),'b')
                    % hold on
                    % plot(presionr(:,1),P_smooth,'r','LineWidth',2)
                    % legend('Original','Smooth')
                    % grid on
                    % 
                    % figure
                    % plot(presionr(:,1),P_res)
                    % grid on
                    % 
                    % Fs = 1/0.5; % muestras por CAD
                    % L = length(P_res);
                    % Y = fft(P_res-mean(P_res));
                    % f = Fs*(0:L/2)/L;
                    % A = abs(Y(1:L/2+1));
                    % figure
                    % plot(f,A)
                    % grid on
                    % xlabel('Cycles/CAD')
                    % ylabel('Amplitude')
                    
                    pre_derivative = derivate(presionr(:,2),Instr.npc,comb,n_ens,CRevCiclo);
                    pre_derivative = intang.*(pi/180).*pre_derivative; % pasa datos a pre_der
                elseif strcmp(Type,'.txt')
                    % Open txt files
                    pfiles = [cell2mat(test_name(ens)) '.txt']; %acá faltaba el (ens)
                    presionr = importdata([inst_signals_path char(cylinder.cil) '\' pfiles]);
                    presionr = presionr.data;
                    presionr(:,1) = presionr(:,1)+(initial_phase-Adjustment.desfasetot);
                    presionr(:,2) = presionr(:,2)+RPC(1,ens);
                    if Pref == 1
                        presionr(:,2) = presionr(:,2)+VPref(1,ens);
                    end
                    presionr(:,2) = presionr(:,2).*100000;% Pressure in Pascales
                    n_ens = v.n(ens)*60;
                    pre_derivative = derivate(presionr(:,2),Instr.npc,comb,n_ens,CRevCiclo);
                    pre_derivative = intang.*(pi/180).*pre_derivative; % pasa datos a pre_der
%                     presionr = importdata([inst_signals_path pfiles]);
                    %                 if ES == 3
                    %                     presionr(:,1) = presionr(:,1)+0.5;
                    %                 end
                end
                
                % PRESSURE SIGNALS ARE AVERAGED AND FILTERED % modificado prueba
                %            num_test=1;
                %            P_fil=filtering(presionr(:,1),Instr,v.n(ens));%p_nc_fil is filtered, p is filtered and averaged
                % Set the phase in the right quadrant, the phase will change (add 360º)
                %            phase = Set_Phase(Adjustment);
                %            Adjustment.desfasetot = phase;

                
                %% Calculations and initialize variables
                
                % Fuel air ratio
                Fa = v.GF(ens)/v.GA(ens);
                FE = Fluid.FE;
                % Fuel air equivalence ratio
                FR = Fa/FE;
                % Blow By flow
                mbbcalc = (v.GBLBY(ens)/1000)*(v.Pc(ens)/((Fluid.RU / Fluid.PMA)*v.Tatm(ens)));
                MBB_exp = mbbcalc/(Engine.Z*(v.n(ens) /CRevCiclo)); % Masa blow by
                % Number of points per cycle
                NPC = length(presionr(:,:)); % read directly from the pressure signal instead of the configuration
                % Air mass per cylinder and cycle
                Mainya = 0; % Injected air
                Mfadm = 0; % Fuel at admission
                Mfa = 0;
                MAADM = v.GA(ens)/(Engine.Z*(v.n(ens)/CRevCiclo));
                MACC = MAADM + Mainya;
                % EGR mass per cylinder and cycle
                megr = v.GEGR(ens)/(Engine.Z*(v.n(ens)/CRevCiclo));
                % Fuel mass per cylinder and cycle
                if Engine.Type == 0
                    MFCC = 0;
                elseif Engine.Type == 1
                    MFCC = v.GF(ens)/(Engine.Z*(v.n(ens)/CRevCiclo));
                elseif Engine.Type == 2
                    if strcmp(Imposed.Ajcomb,'yes')
                        MFCC = (v.GF(ens)) / (Engine.Z * (v.n(ens) / CRevCiclo));
                    else
                        MFCC = (v.GF(ens)) / (Engine.Z * (v.n(ens) / CRevCiclo)) * (Instr.NCARR + Instr.NCCOMB ) / Instr.NCCOMB;
                    end
                end
                % Total mass flow at admission
                
                Msum = MACC + megr;
                % Calculation of residual mass
                
                % Function Calcula_MCC_y_MRESI needs more work
                
                if v.RendRet(ens) == 0 && v.mresi(ens) == 0
                    if v.mrca(ens) > Msum
                        MCC = 0;
                        MRESI = v.mrca(ens) - Msum - Mfa;
                    else
                        MRESI = 0;
                        MCC = Msum + Mfa - v.mrca(ens);
                    end
                elseif v.RendRet(ens) ~= 0
                    MCC = Msum * (1 - v.RendRet(ens));
                    MRESI = v.mrca(ens) - Msum - Mfa + MCC;
                elseif v.mresi(ens) ~= 0
                    MRESI = v.mresi(ens);
                    %                 MCC = Msum + Mfa +v.mresi(ens) - v.mrca(ens);
                    MCC = 0;
                end
                
                % Calculation of composition
                [YaRCA,YqRCA,YfRCA,Yaadm,Yqadm,Yfadm,YaAAE,YqAAE,YfAAE,Yaesc,Yqesc,Yfesc] = calcula_composicion_RCA_AAE(MAADM,Mainya,MBB_exp,megr,MFCC,Mfadm,Mfa,MRESI,MCC,Fluid.FE);
                
                %             MRESI = Masa_Residual(MFCC,MACC,megr,Fluid,Adjustment,Engine,v.Ta(ens),v.Pa(ens),v.Pe(ens),v.n(ens),FR);
                
                % Mass fraction of burned gases at exhaust. Blow-By is neglected,
                % short circuit, residuals mass and recirculation
                %             X_q = Fa*(Fluid.FE+1)/(Fluid.FE*(Fa+1)); %BORRAR
                %             if X_q>1
                %                 X_q=1;
                %             end
                % RU calculation
                r_adm = Fluid.RU / Fluid.PMA * Yaadm + Fluid.RU / Fluid.PMQ * Yqadm + Fluid.RU / Fluid.PMC * Yfadm;
                
                % Angular velocity calculation
                vel_ang = 2*pi*v.n(ens);
                % "Significative mass" for deformations model
                masa_total = 1*(Engine.MALP+Engine.MB/3);
                % Just left multiply for pressure--> deformation due to pressure
                factp = Adjustment.CDM / Engine.C_EAC * (Engine.D / Engine.DBL)^2 * (Engine.HPI + Engine.LB + Engine.LM);
                % Just left multiply for acceleration--> deformation due to inertia
                facti = Adjustment.CDM / Engine.C_EAC * masa_total / (Engine.DBL^2 * pi / 4) * (Engine.HPI + Engine.LB + Engine.LM);
                % Cylinder head area
                areacul = pi*(Engine.D^2/4);
                % Angular step
                inc = CRevCiclo/(v.n(ens)*NPC);% Angular step in time [s]
                % Duration of an angular increase
                wa = 2*pi*v.n(ens);
                % Combustion chamber volume
                vcc = Engine.VD/(Adjustment.rcoffset-1);
                % Air density at admision. Ideal gas law at admision
                dencarga = v.Pa(ens)/(r_adm*v.Ta(ens));
                % Mean effective pressure
                PME = (v.MEN(ens)*wa)/(Engine.VDT*v.n(ens)/CRevCiclo);
                % Exhaust valve opening
                if strcmp(Imposed.Ajcomb,'yes')
                    AAE = v.AAE(ens);
                else
                    AAE = 180-v.AAE(ens);
                end
                % Intake valvel closing
                RCA = -180+v.RCA(ens);
                % Constants of specific species of the mixture
                rf = Fluid.RU/Fluid.PMC;
                ra = Fluid.RU/Fluid.PMA;
                rq = Fluid.RU/Fluid.PMQ;
                % Calculated from heat of combustion
                qt = MFCC*Fluid.HP;
                % Burned mass fractions at start and end
                %             Y_q2total = 1 + 1 / Fa - ((MCC + mbbcalc / 2) / MFCC) * (1 / (1 + (megr + MRESI) / (MACC - MCC)));
                %             Y_q2 = (1+(1/Fluid.FE))/Y_q2total;
                %             Y_q0 = Y_q2 / (1 + ((MACC - MCC) / (megr + MRESI)));
                % Calculation of mean indicated pressure and mean brake pressure
                [PMI,PMB] = calculo_PMI_PMB(Adjustment,CGradosCiclo,CRevCiclo,presionr,intang,NPC,Engine,v.n(ens),factp,facti,vcc);
                WB = PMB*Engine.VD;
                WI = PMI*Engine.VD;
                % Fuel enthalpy
                ecl = Fluid.CAHFL + Fluid.CBHFL * (Fluid.TF + Fluid.C_TIY);
                % Wall temperature calculation
%                 [TPIS,TCUL,TCIL] = Correlaciones_temperaturas(Engine,v.n(ens),dencarga,PME,v.Tref(ens));
                TPIS = v.Tpis(ens);
                TCUL = v.Tcul(ens);
                TCIL = v.Tcil(ens);
                %% Initialize variables
                
                % Residual flow
                gresi = MRESI*Engine.Z*(v.n(ens)/2);
                % Real fuel air ratio
                %             FAR = v.GF(ens)/(v.GA(ens)+(v.GEGR(ens)+gresi)*(1-X_q));
                FAR = v.GF(ens) / (v.GA(ens) + (v.GEGR(ens) + gresi) * YaAAE);
                % Real fuel air equivalence ratio
                FRR = FAR/Fluid.FE;
                % Some variables to use in the program
                wt = 0;
                QW = 0;      % Heat tranfer Woschni
                TMAX = 0;    % Max temperature
                PMAX = 0;    % Max pressure
                DFQLMAX = 0; % Max derivate of heat fraction release
                dfql = 0;    % Derivate f heat fraction release
                GRAP = 0;
                AGRAP = 0;
                cont = 0;
                mbbacum = 0; % Blow by accumulated
                minyacum = 0;
                mfinyacum = Mfa + Mfadm; % Initial fuel injected
                mainyacum = 0; % Initial injected air (Neumatic injection)
                fql = 0;     % Heat fraction release
                Yf = 0;      % Fuel mass fraction
                hacum = 0;
                NQCILHP = 0; % Mean heat flux in the cylinder in W (close cycle)
                NQCULHP = 0; % Mean heat flux in the cylinder head in W (close cycle)
                NQPISHP = 0; % Mean heat flux in the piston in W (close cycle)
                %             masacil = MACC+megr+MRESI-MCC; % Mass for start at RCA
                masacil = v.mrca(ens);
                MCA = masacil; % Mass at RCA
                MBB = 0; % Initial Blow By mass
                Gamma = 1.4;   % Isentropic exponent
                %             p_interval = 100/Instr.npc;
                %             presionr(:,2) = presionr(:,2)*100000; % Pressure in [bar]
                
                % Injection rate calculation
                if Engine.Type ==  1
                    % Creates three input files to execute TASA.exe
                    grabar_system_parameters;
                    grabar_inyection_parameters(v,ens);
                    grabar_test_variables(v,ens,n_ens);
                    status_tasa = Ejecuta_Tasa('RAM\Tasa\');
                    % Saves the output files from TASA.exe
                    [inj_rate,inj_rate_param] = read_data('RAM\Tasa\');
                    Inj_saved_path = [saved_path 'DAT\' Engine_Name '\' Identifier '\Injection\'];
                    [status,SOI,EOI,injection_rate,masa_total_inj] = Ejecutar_Tasa( v,ens,n_ens,'RAM\Tasa\',inj_rate,presionr,intang,MFCC );
                    % Calculates the evaporated mass
                    mevap = modelo_evaporacion(MFCC,Engine,v.N_iny(ens),SOI,EOI,CGradosCiclo,CRevCiclo,v.n(ens),intang,injection_rate,NPC,presionr,factp,facti,vcc,masa_total_inj,Fluid,masacil);
                else
                    mevap = 0;
                end
                hi_Inst = zeros(NPC,1);
                volume = zeros(NPC,1);
                for l = 1 : NPC
                    [hi_Inst(l,1),volume(l,1)] = DistPistonCulataDef(intang,NPC,presionr(l,1),Engine,v.n(ens),presionr(l,2),factp,facti,vcc,CRevCiclo);
                end
                vol_derivative = derivate(volume,Instr.npc,comb,n_ens,CRevCiclo);
                vol_derivative = intang*(pi/180)*vol_derivative;
                clear l
                %% Principal cycle
                
                Ang = mod720(-Adjustment.desfasetot,CGradosCiclo);
                i = 1;
                % Close cycle length and points determination
                while not(and((Ang>=RCA),(Ang-intang)<RCA))
                    Ang = mod720(Ang+intang,CGradosCiclo);
                    i=i+1;
                    if ES == 1 && Iteration == 1
                        DVcont(ens,1) = DVcont(ens,1)+1;
                        % The counting is exceeded for one intang, It menas
                        % if RCA : -135 and intang : 0.2 then Ang : -134.8
                    end
                end
                Ang_f = Ang;
                while not(and((Ang_f>=AAE),(Ang_f-intang)<AAE))
                    Ang_f = mod720(Ang_f+intang,CGradosCiclo);
                    if ES == 1 && Iteration == 1
                        npcc(ens,1) = npcc(ens,1)+1;
                    end
                end
                k=0;
                %                         i=i-1; % Correction for the intang exceeded
                %                         npcc(ens,1)=npcc(ens,1)-1;% Correction for the intang exceeded
                
                % Create variables which chance size every loop
                resul_graf = zeros(npcc(ens,1),33);
                TGAS = zeros (npcc(ens,1),1);
                volumen = zeros(npcc(ens,1),1);
                
                %% CLOSE CYCLE CALCULATION
                while not(and((Ang>=AAE),(Ang-intang)<AAE)) %&& (i <= Instr.npc)
                    k=k+1; % Close cycle counter (sample counter)
                    
                    % Initialize variables
                    pre = presionr(i,2);
                    pre_ant = presionr(i-1,2);
                    pre_der = pre_derivative(i,1);
                    vol = volume(i,1);
                    vol_ant = volume(i-1,1);
                    vol_der = vol_derivative(i,1);
                    hi = hi_Inst(i,1);
                    
                    if Engine.Type ==  1
                        MEVAP = mevap(i,2);
                        In_rate = Injection_rate(i,2);
                    elseif Engine.Type ==  0 || Engine.Type ==  2
                        MEVAP = 0;
                        In_rate = 0;
                    end
                    i=i+1;
                    
                    resul_graf(k,1)=Ang;
                    resul_graf(k,2)=pre/100000;
                    resul_graf(k,3)=vol;
                    CAD(k,1) = Ang;
                    % Dynamic compression ratio
                    rel=Obtener_Rc_Dinamica(Ang,Engine,vcc,vol);
                    % Calculation of instantaneous fuel, burned gases
                    % and air fractions
                    if Engine.Type == 0 % Motored
                        Yf = 0;
                        Yq = 0;
                        Ya = YaRCA;
                    elseif Engine.Type == 1 % Combustion
                        %                     minyacum = minyacum + mevap(i,2);
                        mfinyacum = mfinyacum + mevap(i,2);
                        if mfinyacum ~= 0
                            AAAA = 1;
                        end
                        [Ya,Yq,Yf] = Y_inst(MCC,megr,MAADM,MFCC,fql,Yqesc,MRESI,YqAAE,MBB,YqRCA,mfinyacum,mainyacum,FE,Fluid.HP);
                        %                     if minyacum>0;
                        %                         Yf=Yf_inst(MFCC,MACC,megr,MRESI,MCC,minyacum,mbbacum,fql/qt);
                        %                     end
                        %                     Yq = Yq_inst(MACC,MFCC,megr,MRESI,MCC,mbbacum,minyacum,Fluid,fql/qt,Y_q2,Y_q0);
                        %                     Ya = 1 - Yq - Yf; %Calculate the air mass fraction
                        %                     if Ya < 0; % Air cannot be a negative value
                        %                         Ya = 0;
                        %                         Yf = Yf / (Yf + Yq);
                        %                         Yq = Yq / (Yf + Yq);
                        %                     end
                    elseif Engine.Type == 2 % Skip fire (Pseudoarrastre)
                        Yf = YfRCA;
                        Yq = YqRCA;
                        Ya = YaRCA;
                    end
                    
                    resul_graf(k,4)=Yf;
                    resul_graf(k,5)=Yq;
                    resul_graf(k,6)=Ya;
                    r = ra * Ya + rf * Yf + rq * Yq;
                    resul_graf(k,7)=r;
                    temp = pre * vol / r / masacil; %Calculation of gas temperature
                    TGAS(k,1)=temp;
                    resul_graf(k,8)=temp;
                    if k==1
                        temp_RCA = temp;
                        Temp_ant = temp; % To start Siciclo
                        vol_RCA = vol;
                        pre_RCA = pre;
                        Presion_ant = pre; % To start Siciclo
                        Ang=Ang+intang;
                        continue
                    end
                    
                    if pre_ant > PMAX
                        PMAX=pre_ant;
                        APMAX=Ang-intang;
                        indice_pmax=k-1;
                    end
                    temp_ant=TGAS(k-1,1);
                    % Check the max temperature and max temperature angle
                    if temp_ant > TMAX
                        TMAX=temp_ant;
                        ATMAX=Ang-intang;
                        indice_tmax=k-1;
                    end
                    volumen(1,1)=vol_RCA;
                    volumen(k,1)=vol;
                    % Calculation of volume variations (used in work calculation)
                    vol_delta = -(vol_ant-vol);
                    % Calculation of mean pressure (aproximation for work calculation)
                    pm = (pre_ant + pre) / 2;
                    % Initialize variables for heat transfer due to blow by calculation
                    temperatura_bb=(TPIS+TCIL)/2; %Temperatura where the blow by occurs
                    [cv_bb,~,~,~] = C_v (temperatura_bb,Ya,Yf,Yq,Engine.FUELT,Engine.COMBT);
                    Gamma_bb = 1 + r / cv_bb;
                    % Calculation of blow by mass
                    MBB = Calcula_Blow_By(CRevCiclo,v.Pc(ens),pre_ant,v.n(ens),NPC,Gamma_bb,v.CBB(ens),Engine,r,temp);
                    resul_graf(k,9)=MBB;
                    % Accumulated blow by mass
                    mbbacum = mbbacum + MBB;
                    resul_graf(k,30) = mbbacum;
                    %                 MEVAP=mevap(i,2);
                    %                 if k == 1
                    %                 Mevap = 0 %%% se impuso por que es arrastre, revisar en
                    %                 codigo de dani
                    %                 end
                    
                    resul_graf(k,10)=MEVAP;
                    % Traped mass
                    %                 masacil_siciclo = masacil;
                    masacil = masacil-MBB+MEVAP;
                    resul_graf(k,11) = masacil;
                    
                    % Heat tranfer by means of Woschni model
                    
                    if strcmp(Adjustment.Model,'S')
                        [h,QW] = Calcula_Calor_Woschni(Engine,Ang,v.n(ens),Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,temp,hi,TCUL,TPIS,TCIL,inc);
                    elseif strcmp(Adjustment.Model,'T')
                        [h,QW] = Calcula_Calor_Woschni_T(Engine,Ang,v.n(ens),v.vmed(ens),Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,temp,hi,TCUL,TPIS,TCIL,inc,CGradosCiclo,Tumble);
                    end
                    %                 [h,QW]=Calcula_Calor_Woschni_T(Engine,Ang,v.n(ens),Adjustment,pre,pre_RCA,vol_RCA,temp_RCA,vol,temp,hi,TCUL,TPIS,TCIL,inc,CGradosCiclo);
                    % Gas properties
                    [cv,cv_a,cv_f,cv_q]= C_v (temp_ant,Ya,Yf,Yq,Engine.FUELT,Engine.COMBT);
                    Gamma=1+r/cv;
                    % polytropic exponent calculation
                    expol =-((vol*(pre_der))/(pre*(vol_der)));
                    Qn_total = (pre*(vol_der)*((expol-Gamma)/(Gamma-1)));
                    Qn_bb =((r+cv_bb)*temp*MBB);
                    Qn = Qn_total - Qn_bb;
                    
                    % Calculation of temperature variation
                    der_temp = -(temp_ant-temp);
                    u = masacil*cv*(der_temp);
                    
                    resul_graf(k,12) = u;
                    % Work calculation
                    W = -pm*(vol_delta);
                    resul_graf(k,13)=-W;
                    % Accumulated work
                    wt=wt+W;
                    % Blow by lost energy
                    ebb=r*(temp_ant+temp)/2*MBB;
                    % Internal energy calculation
                    [Ua,Uf,Uq]=En_int(temp);
                    resul_graf(k,14)=Uf;
                    % Evaporated fuel energy
                    efg=-(ecl-Uf)*MEVAP;
                    % Simulated cycle calculation "SICICLO"masacil
                    Qn_bb_siciclo =((r)*temp_ant*MBB); % From dFQL equation (energy balance, be careful)
                    Temp = Temp_ant+(-(Presion_ant*(vol_delta))-QW-Qn_bb_siciclo)/(masacil*cv);
                    Presion = masacil * r * Temp/vol; % The mass is not anymore constant between points (¿?)
                    Temp_ant = Temp;% Update variables
                    Presion_ant = Presion;% Update variables
                    % Heat release variation
                    dfql=u-W+QW+ebb+efg;
                    % Heat release
                    fql = fql + dfql;
                    resul_graf(k,18)=fql;
                    resul_graf(k,17)=ebb;
                    % Angle for the new loop
                    Ang=Ang+intang;
                    % Add the interesting variables to resul_graf to save in Excel
                    resul_graf(k,15) = dfql/intang;
                    resul_graf(k,16) = QW/intang;
                    resul_graf(k,19) = expol;
                    resul_graf(k,20) = Gamma;
                    resul_graf(k,21) = Qn_total/intang;
                    resul_graf(k,22) = Qn_bb/intang;
                    resul_graf(k,23) = Qn/intang;
                    resul_graf(k,24) = (vol_der)/intang;
                    resul_graf(k,25) = (pre_der)/intang;
                    resul_graf(k,26) = (temp-temp_ant)/intang;
                    resul_graf(k,27) = Presion/100000;
                    resul_graf(k,28) = h;
                    resul_graf(k,29) = cv;
                    resul_graf(k,31) = (Presion-pre)/100000;
                    resul_graf(k,32) = In_rate;
                    resul_graf(k,33) = r;
                end
                
                %% Save results
             if ~isreal(resul_graf)
                 pause;
             end
                % Folder to save temporal data
                RAM = 'RAM\';
                % Folder to save dat files used in MAT_CALMEC_GRAPHER_V1_1
                DAT = [saved_path 'DAT\' Engine_Name '\' Identifier '\'];
                % Save the results in the RAM folder to be used by Adjuster
                test = [cell2mat(test_name(ens)) '_'];
                if ES == 1
                    save([RAM 'Base_0\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 2
                    save([RAM 'Pref0\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 3
                    save([RAM 'CW1\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 4
                    save([RAM 'RCO\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 5
                    save([RAM 'alpha\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 6
                    save([RAM 'CDM\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 7
                    save([RAM 'Final\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 8
                    save([RAM 'Base\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 9
                    save([RAM 'Base_Pref\' test filename '.dat'],'resul_graf','-ASCII');
                elseif ES == 10
                    save([RAM 'Pref\' test filename '.dat'],'resul_graf','-ASCII');
                end
                
                % If the first iteration, save the initial values with initial Adjustment
                if Iteration == 1 && ES == 1
                    % Create a cell structure in order to save in Excel
                    Results = res2struct(resul_graf);
                    headers = {'Crank Angle','Pressure','Volume','Yf','Yq','Ya','Rgas',...
                        'Gas temperature','Blow by mass','Evaporated mass','Intake mass',...
                        'Internal energy','Work','Fuel Internal energy',...
                        'RoHR','Qw','ebb','HR','expol','Gamma','Qn total','Qn BB','Qn',...
                        'dV','dP','dT','P simulada','h','cv','mbb acumulated','Psim-Preal',...
                        'Injection Rate','Gas constant'};
                    Units = {'º','Pa','m^3','-','-','-','J/kg*K','K','kg',...
                        'kg','kg','J','J','J','J/CAD','J/CAD','J','J'...
                        '-','-','J/CAD','J/CAD','J/CAD','m^3/CAD','Pa/CAD','K/CAD','Pa',...
                        'W/m^2K','J/kgK','Kg','bar','g/s','Pa*m^3/kg*K'};
                    cell_values = num2cell(resul_graf);
                    cell = [headers;Units;cell_values];
                    if strcmp(Adjustment.debug,'yes')
                        xlswrite([saved_folder Identifier '_' cell2mat(test_name(ens)) '.xls'],cell,'Initial');
                    end
                    save([DAT 'Initial_' cell2mat(test_name(ens)) '.dat'],'resul_graf','-ASCII');
                elseif strcmp(OUT,'True') && ES == 1
                    Results = res2struct(resul_graf);
                    headers = {'Crank Angle','Pressure','Volume','Yf','Yq','Ya','Rgas',...
                        'Gas temperature','Blow by mass','Evaporated mass','Intake mass',...
                        'Internal energy','Work','Fuel Internal energy',...
                        'RoHR','Qw','ebb','HR','expol','Gamma','Qn total','Qn BB','Qn',...
                        'dV','dP','dT','P simulada','h','cv','mbb acumulated','Psim-Preal',...
                        'Injection Rate','Gas constant'};
                    Units = {'º','Pa','m^3','-','-','-','J/kg*K','K','kg/s',...
                        'kg','kg','J','J','J','J/CAD','J/CAD','J','J'...
                        '-','-','J/CAD','J/CAD','J/CAD','m^3/CAD','Pa/CAD','K/CAD','Pa',...
                        'W/m^2K','J/kgK','Kg','bar','g/s','Pa*m^3/kg*K'};
                    cell_values = num2cell(resul_graf);
                    cell = [headers;Units;cell_values];
                    if strcmp(Adjustment.debug,'yes')
                        xlswrite([saved_folder Identifier '_' cell2mat(test_name(ens)) '.xls'],cell,'Adjusted');
                    end
                    save([DAT 'Adjusted_' cell2mat(test_name(ens)) '.dat'],'resul_graf','-ASCII');
                end
            end
            %% Adjustment
            
            % Calculates the error in the first and the last iteration
            if ES == 1 && Iteration == 1 && Engine.Type ~= 1 % Initial error
                VDcorr(:,1) = max(DVcont) - DVcont; % Reference RCA to max RCA
                VDcorr(:,2) = npcc-VDcorr(:,1); % Reference AAE to max RCA
                VDcorr(:,2) = VDcorr(:,2)-min( VDcorr(:,2));
                VDcorr(:,2) = npcc-VDcorr(:,1)-VDcorr(:,2); % All values must be the same
                Err0 = calc_error_initial(Engine,v.n,RAM,saved_path,Engine_Name,Identifier,test_name,num_tests,Iteration,VDcorr);
                clear VDcorr
            elseif ES == 1 && strcmp(OUT,'True') && Engine.Type ~= 1 % Final error
                VDcorr(:,1) = max(DVcont) - DVcont; % Reference RCA to max RCA
                VDcorr(:,2) = npcc-VDcorr(:,1); % Reference AAE to max RCA
                VDcorr(:,2) = VDcorr(:,2)-min( VDcorr(:,2));
                VDcorr(:,2) = npcc-VDcorr(:,1)-VDcorr(:,2); % All values must be the same    
                Err0 = calc_error_initial(Engine,v.n,RAM,saved_path,Engine_Name,Identifier,test_name,num_tests,Iteration,VDcorr);
                clear VDcorr
                break
            end
            
            % Adjustment
            if strcmp(END_ant,'True') && strcmp(END,'False') && ES == 8 && Engine.Type ~= 1 % Is the last phase adjustment
                VDcorr(:,1) = max(DVcont) - DVcont; % Reference RCA to max RCA
                VDcorr(:,2) = npcc-VDcorr(:,1); % Reference AAE to max RCA
                VDcorr(:,2) = VDcorr(:,2)-min( VDcorr(:,2));
                VDcorr(:,2) = npcc-VDcorr(:,1)-VDcorr(:,2); % All values must be the same
%                 [alpha,alpha_geom,alpha_Hoh,~] = Hohenberg (resul_graf(:,1),resul_graf(:,2),resul_graf(:,3),resul_graf(:,8),resul_graf(:,9),resul_graf(:,16),Engine,resul_graf(:,33),num_tests,CRevCiclo,NPC,intang,v,Adjustment.desfasetot);
%                 Adjustment.desfasetot = mean(alpha);
                % Adjustment of the phase
                if Imposed.desfasetot == 1
                    % Impose the parameters (only adjust phase)
                    Imposed.CW1 = 0;
                    Imposed.rcoffset = 0;
                    Imposed.CDM = 0;
                    % Set the initial parameter of phase
                    Adjustment_in = Adjustment;
                    % Adjust phase
                    [K,Adjustment,VES,~] = Adjuster(RAM,saved_path,Engine_Name,Identifier,test_name,num_tests,Adjustment,Imposed,VES,Iteration,VDcorr,CRevCiclo,NPC,intang,Engine,v,'Final');
                    if strcmp(END_ant,'True')
                        END = 'True';
                    end
                else % If no phase adjustment, END is set as true
                    END = 'True';
                end
            elseif Imposed.pref == 1 && Imposed.pref0 == 1 && strcmp(OUT,'False') && ES == 2 && Iteration == 1 && Engine.Type ~= 1
                % Adjustment of initial pegging pressure
                VDcorr(:,1) = max(DVcont) - DVcont; % Reference RCA to max RCA
                VDcorr(:,2) = npcc-VDcorr(:,1); % Reference AAE to max RCA
                VDcorr(:,2) = VDcorr(:,2)-min( VDcorr(:,2));
                VDcorr(:,2) = npcc-VDcorr(:,1)-VDcorr(:,2); % All values must be the same
                [Kpref,RPC] = Adjuster_pref_0(RAM,saved_path,test_name,Engine_Name,Identifier,Adjustment,VPref,RPC,Kpref,CAD,Iteration);
                VPref = RPC/2;
                clear VDcorr
            elseif strcmp(END,'False') && ES == 8 && Engine.Type ~= 1
                % Adjustment of thermodynamic model
                Adjustment_in = Adjustment;
                VDcorr(:,1) = max(DVcont) - DVcont; % Reference RCA to max RCA
                VDcorr(:,2) = npcc-VDcorr(:,1); % Reference AAE to max RCA
                VDcorr(:,2) = VDcorr(:,2)-min(VDcorr(:,2));
                VDcorr(:,2) = npcc-VDcorr(:,1)-VDcorr(:,2); % All values must be the same
                % Adjuster gives also the END parameter value
                [K,Adjustment,VES,END_ant] = Adjuster(RAM,saved_path,Engine_Name,Identifier,test_name,num_tests,Adjustment,Imposed,VES,Iteration,VDcorr,CRevCiclo,NPC,intang,Engine,v,'Normal');
% % %        AJUSTE PARAMETROS TUMBLE         
%                 if strcmp(Adjustment.Model,'T')
%                     for i = 1 : 3
%                         if i == 1 && Iteration == 1
%                             C0(1) = Tumble.a1;
%                             C0(2) = Tumble.a2;
% %                           C0(3) = 1;
%                         end
%                         [X] = fminsearch(@(C) RMSE_Calcula_Calor_Woschni_T(RAM,test_name,intang,Identifier,Engine,v.n,v.vmed,Adjustment,v.Tcul,v.Tpis,v.Tcil,inc,Tumble,C),C0);
%                         C0(1) = X(1);
%                         C0(2) = X(2);
% %                         C0(3) = X(3);
%                     end
%                     Tumble.a1 = X(1);
%                     Tumble.a2 = X(2);
%                 end
% % %                 
            elseif Imposed.pref == 1 && strcmp(OUT,'False') && ES == 10 && strcmp(END,'False') && Engine.Type ~= 1
                % Adjustment of Pref
                [Kpref,RPC] = Adjuster_pref(RAM,saved_path,test_name,Engine_Name,Identifier,Adjustment,VPref,RPC,Kpref,CAD,Iteration);
                VPref = RPC/2;
                run Clear_RAM
            end
                        
            %% Clear useles data
            clear ('Ang','k','i','pre','pre_ant','pre_pos','pre_der','hi','vol','vol_ant',...
                'vol_pos','resul_graf','rel''Yf','Yq','Ya','r','temp','TGAS','temp_RCA',...
                'remp_ant','Temp_ant','vol_RCA','pre_RCA','PMAX','APMAX','TMAX','indice_pmax',...
                'indice_tmax','volumen','vol_der','pm','remperatura_bb','cv Gamma','expol',...
                'Qn_total','Qn_bb','Qn','der_temp','u','W','h','QW','wt','ebb','cv',...
                'Ua','Uf','Uq','efg','Qn_bb_siciclo','Temp','Presion','Temp_ant','Presion_ant',...
                'dfql','fql','Results','cv_bb','MBB','mbbacum','MEVAP','masacil','h',...
                'MEVAP','cv_a','cv_f','cv_q','CAD')
            
            %% If combustion test, go out the case
            if Engine.Type == 1
                break
            end
            
        end
        if Engine.Type == 1
            OUT = 'True';
        end
        
    end
    
    %% End notes
    
    % Modificaciones
    
    % 1. Si se cambia el desfase para archivos en los que se usa la señal
    % directamente con referencia angular en el estudio del metodo de ajuste,
    % se debe activar la linea que incluye el desfase en el eje angular de la
    % señal de presión
    
    % 2. vol_der es la forma simplificada Vol antes - Vol despues para que
    % coincida con a forma de calcular con Siciclo, por eso la pequeña
    % diferencia en la dFQL calculada con CALMEC_CHARAC_V3_3
    
    % 3. Se ha incluido una función para el ajuste de los factores globales
    % RCO, CW1, CDM, desfase y 2 funciones para ajustar Pref: la primera solo
    % emplea el criterio de minimizar error en la dFQL (para dar un valor de
    % entrada) y otra con el efecto de dFQL y Psim para afinar. El método se
    % basa en minimizar el error cuadrático.
    
    % 4. Importante corregir la variación del desfase para binarios, ahora
    % mismo calcularía un error
    
    % 5. Solo esta probado para archivos con extension .DAT
    % end
    
    % Note = 'Temperaturas de pared impuestas'
    run Clear_RAM
    close all
    clc
    if strcmp(PolyEx,'yes')
        % Notes
        Note = 'Los modelos de combustion (evaporación) no estan completos'
        End  = ['Final Iteration ' num2str(Iteration) ' | ' cylinder.cil]
    else
        % Notes
        Note = 'Los modelos de combustion (evaporación) no estan completos'
        End  = ['Final Iteration ' num2str(Iteration)]
    end
    
    % Graphics options
    if Iteration ~= 1
        if strcmp(PolyEx,'yes') && Current_Cyl == 4
            Graph = input('do you want to graph ERoHR and Ep for each measurement? yes[y]/no[n]:', 's');
            if strcmp (Graph,'y') && strcmp(PolyEx,'yes')
                run MAT_CALMEC_GRAPHER_V1_2
            end
        elseif strcmp(PolyEx,'no')
            Graph = input('do you want to graph ERoHR and Ep for each measurement? yes[y]/no[n]:', 's');
            if strcmp (Graph,'y')
                run MAT_CALMEC_GRAPHER_V1_1
            end
        else
            Note = 'No graphics were performed'
        end
    end
    
    if strcmp(PolyEx,'yes') == 0
        break
    end
    
end
