function [ Tumble ] = load_tumble( conf_file )
%load_tumble Load the Tumble parameters necessary for the heat transfer
%calculation in Calcula_Calor_Woschni_T
%   Requires the path where the configuration file is

[numeric,~] = xlsread(conf_file,'Tumble');

Tumble.a1         = numeric(1);% Start of tumble discipation
Tumble.a2         = numeric(2);% End of tumble discipation
Tumble.c1         = numeric(3);% End of tumble discipation
Tumble.c2         = numeric(4);% End of tumble discipation
Tumble.Ct2        = numeric(5);% Mean piston speed proportionality
Tumble.rt         = numeric(6);% Mean intake flow proportionality
end

