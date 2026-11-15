function [Instr] = Instr_conf(conf_file,cil)
%This function creates an estructure with the characterization parameters, read
%from CONFIGURATIONS.xls

[numeric,var_name] = xlsread(conf_file,'Instr');

Instr.npc         = numeric(1);%Number of samples per cycle [-]
Instr.nc          = numeric(2);%Number of cycles [-]
if strcmp(cil,'cil1')
    Instr.c_capt_1    = numeric(3);%Sensor 1 calibration coefficient [-]
    Instr.offset_c_1  = numeric(4);%Sensor 1 offset [bar]
    Instr.coef_mult_1 = numeric(5);%Sensor 1 bar/volt ratio [bar/v]
elseif strcmp(cil,'cil2')
    Instr.c_capt_2    = numeric(6);%Sensor 2 calibration coefficient [-]
    Instr.offset_c_2  = numeric(7);%Sensor 2 offset [bar]
    Instr.coef_mult_2 = numeric(8);%Sensor 2 bar/volt ratio [bar/v]
elseif strcmp(cil,'cil3')
    Instr.c_capt_3    = numeric(9);%Sensor 3 calibration coefficient [-]
    Instr.offset_c_3  = numeric(10);%Sensor 3 offset [bar]
    Instr.coef_mult_3 = numeric(11);%Sensor 3 bar/volt ratio [bar/v]
elseif strcmp(cil,'cil4')
    Instr.c_capt_4    = numeric(12);%Sensor 4 calibration coefficient [-]
    Instr.offset_c_4  = numeric(13);%Sensor 4 offset [bar]
    Instr.coef_mult_4 = numeric(14);%Sensor 4 bar/volt ratio [bar/v]
end
Instr.Pr_adm      = numeric(15);%Inlet pressure [bar]
Instr.NCCOMB      = numeric(16);%Number of cycles in combustion
Instr.NCARR       = numeric(17);%Number of cycles motored
