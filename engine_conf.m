function [Engine] = engine_conf(conf_file)
%This function creates an estructure with the engine configuration, read
%from CONFIGURATION.xls

[numeric,var_name] = xlsread(conf_file,'Engine');

Engine.	C_EAC     =	numeric	(	1	);%	[N/m^2]	Modulo de elasticidad del acero
Engine.	CFBB	  =	numeric	(	2	);%	[-]	    Coef. de seccion de fugas por BlowBy
Engine.	CTM	      =	numeric	(	3	);%	[-]	    Coeficiente de torbellino medio
Engine.	RCA	      =	numeric	(	4	);%	[º]	    Angulo de retraso al cierre de la admisión
Engine.	AAE	      =	numeric	(	5	);%	[º]	    Angulo de avance de la apertura del escape
Engine.	DB	      =	numeric	(	6	);%	[m]	    Diámetro del Bowl
Engine.	AP	      =	numeric	(	7	);%	[m²]    Area de la superficie del pistón
Engine.	AC	      =	numeric	(	8	);%	[m²]    Area de la superficie de la culata
Engine. HLI       = numeric (   9   );% [m]     Altura Libre
Engine.	HPI	      =	numeric	(	10	);%	[m]	    Altura entre el bulón y la cabeza del piston
Engine.	DBL	      =	numeric	(	11	);%	[m]	    Diametro del bulón
Engine.	Z	      =	numeric	(	12	);%	[-]	    nº de cilindros
Engine.	D	      =	numeric	(	13	);%	[m]   	Diámetro del cilindro
Engine.	S	      =	numeric	(	14	);%	[m]	    Carrera
Engine.	LB	      =	numeric	(	15	);%	[m]  	Longitud de la biela
Engine.	LM	      =	numeric	(	16	);%	[m] 	Longitud de la manivela
Engine.	MALP      =	numeric	(	17	);%	[kg]	Masa del conjunto piston-bulón-segmentos
Engine.	MB	      =	numeric	(	18	);%	[kg]	Masa de la biela
Engine.	VD        =	numeric	(	19	);%	[m³]	Volumen desplazado
Engine.	VDT	      =	numeric	(	20	);%	[m³]	Volumen desplazado total
Engine.	desc	  =	numeric	(	21	);%	[m] 	Descentrado
Engine.	NORIF	  =	numeric	(	22	);%	[-] 	Numero de orificios del inyector
Engine.	DORIF	  =	numeric	(	23	);%	[m] 	Diámetro de los orificios del inyector
Engine.	C1pis	  =	numeric	(	24	);%	[-] 	Constante de ajuste para temperatura del piston
Engine.	C2pis	  =	numeric	(	25	);%	[-] 	Constante de ajuste para temperatura del piston
Engine.	C1cul	  =	numeric	(	26	);%	[-] 	Constante de ajuste para temperatura de la culata
Engine.	C2cul	  =	numeric	(	27	);%	[-] 	Constante de ajuste para temperatura de la culata
Engine.	C1cil	  =	numeric	(	28	);%	[-] 	Constante de ajuste para temperatura del cilindro
Engine.	C2cil	  =	numeric	(	29	);%	[-] 	Constante de ajuste para temperatura del cilindro
Engine.	AAA	      =	numeric	(	30	);%	[º] 	Avance de apertura de la admisión 
Engine.	RCE  	  =	numeric	(	31	);%	[º] 	Retraso al cierre del escape
Engine.	LEMA	  =	numeric	(	32	);%	[m] 	Levantamiento máximo de la válvula de admisión
Engine.	LEME	  =	numeric	(	33	);%	[m] 	Levantamiento máximo de la válvula de escape
Engine.	DVA 	  =	numeric	(	34	);%	[m] 	Diametro del asiento de la válvula de admisión
Engine.	DVE       =	numeric	(	35	);%	[m] 	Diametro del asiento de la válvula de escape
Engine. OF        = numeric (   36  );% [-]  Factor de solape
Engine. NOS       = numeric (   37  );% [-]  Especificar tipo de motor: Motor 2T (2) o 4T (4)
Engine. Type      = numeric (   38  );% [-]  Especificar tipo de ensayo, 0 Arrastre, 1 Combustión, 2 Pseudoarrastre
Engine. FUELT     = numeric (   39  );% [-]  Especificar tipo de combustible, 0 Gasoil, 1 Gasolina, 2 Mezcla
Engine. COMBT     = numeric (   40  );% [-]  Especificar Tipo de combustión, 0 Compresión, 1 Provocado

