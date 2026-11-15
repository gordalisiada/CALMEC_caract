function [Fluid] = fluid_conf(conf_file)
%This function creates an estructure with the fluids parameters, read
%from CONFIGURATIONS.xls

[numeric,var_name] = xlsread(conf_file,'Fluid');

Fluid.	HP	=	numeric	(	1	); % [J/Kg] Fuel heating value 
Fluid.	PMC	=	numeric	(	2	); % [Kg/mol] Fuel molecular weight 
Fluid.	PMA	=	numeric	(	3	); % [Kg/mol] Air molecular weight 
Fluid.	PMQ	=	numeric	(	4	); % [Kg/mol] Molecular weight of stoichiometric burnt products 
Fluid.  CAHFL =   numeric (   5   ); % [] A configuration constant
Fluid.  CBHFL =   numeric (   6   ); % [] B configuration constant
Fluid.	TF	=	numeric	(	7	); % [K] Fuel Temperature 
Fluid.	C_TIY	=	numeric	(	8	); % [K] Fuel temperature increment 
Fluid.	FE	=	numeric	(	9	); % [-] Stoichiometric fuel-air ratio 
Fluid.  RU      =   numeric (   10  ); % [J/Kg] Gas constant 
Fluid.	DENSF	=	numeric	(	11	); % [Kg/m3]Fuel density 



