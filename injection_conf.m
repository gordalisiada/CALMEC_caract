function [Injection] = engine_conf(conf_file)
%This function creates an estructure with the injection information
%from CONFIGURATION.xls

[numeric,var_name] = xlsread(conf_file,'Injection');

Injection.	N_iny	=	numeric	(	1	)	;
Injection.	SOI1	=	numeric	(	2	)	;
Injection.	MF1	=	numeric	(	3	)	;
Injection.	SOI2	=	numeric	(	4	)	;
Injection.	MF2	=	numeric	(	5	)	;
Injection.	SOI3	=	numeric	(	6	)	;
Injection.	MF3	=	numeric	(	7	)	;
Injection.	SOI4	=	numeric	(	8	)	;
Injection.	MF4	=	numeric	(	9	)	;
Injection.	SOI5	=	numeric	(	10	)	;
Injection.	MF5	=	numeric	(	11	)	;
Injection.	SOI6	=	numeric	(	12	)	;
Injection.	MF6	=	numeric	(	13	)	;
Injection.	SOI7	=	numeric	(	14	)	;
Injection.	MF7	=	numeric	(	15	)	;
Injection.	SOI8	=	numeric	(	16	)	;
Injection.	MF8	=	numeric	(	17	)	;
