function [Adjustment,Imposed,cylinder,PoyEx,Identifier] = charac_conf(conf_file,Current_Cyl,Ident)
%This function creates an estructure with the characterization parameters, read
%from CONFIGURATIONS.xls

[numeric,var_name] = xlsread(conf_file,'Adjustment') ;

% Variable to allow multiple cylinder executions
PoyEx =  var_name(  20,2 ) ;

if strcmp(PoyEx,'yes')
    if Current_Cyl == 1
        cylinder.cil = 'cil1';
    elseif Current_Cyl == 2
        cylinder.cil = 'cil2';
    elseif Current_Cyl == 3
        cylinder.cil = 'cil3';
    elseif Current_Cyl == 4
        cylinder.cil = 'cil4';
    end
    Identifier = [Ident '_' cylinder.cil];
else
    cylinder.cil  =   var_name(  19,2 ) ;
    Identifier = Ident;
end


if strcmp(cylinder.cil,'cil1')
    Adjustment.	CW1	        =	numeric	(	1,1	) ;     % Coeficiente Woschni 1
    Adjustment.	CW2	        =	numeric	(	1,1	)/1.7 ; % Coeficiente Woschni 2
    Adjustment.	rcoffset	=	numeric	(	2,1	) ;     % Relacion de compresión offset
    Adjustment.	desfasetot	=	numeric	(	3,1	) ;     % Desfase total
    Adjustment.	CDM	        =	numeric	(	4,1	) ;     % Coeficiente de deformaciones mecánicas
    Adjustment.	RPC	        =	numeric	(	5,1	) ;     % Corrección a la presion de referencia
    Adjustment.Iterations   =   numeric	(	6,1 ) ;      % Número de iteraciones mínimo a realizar
    Adjustment.A            =   numeric	(	7,1 ) ;
    Adjustment.debug        =   var_name(	9,2 ) ;      % Factor de Ponderación A=1 solo dFQL y A=0 solo Delta P
    Adjustment.conv         =   numeric	(	9,1 )/100 ; % Factor de convergencia, variación mínima para terminar el ajuste, entre parametros ajustados respecto al anterior valor
    % Imponer Valores de ajuste (1 ajustar, 0 Imponer)
    Imposed.CW1             = numeric   (  11,1  ) ;
    Imposed.rcoffset        = numeric   (  12,1  ) ;
    Imposed.desfasetot      = numeric   (  13,1  ) ;
    Imposed.CDM             = numeric   (  14,1  ) ;
    Imposed.pref0           = numeric   (  15,1  ) ;
    Imposed.pref            = numeric   (  16,1  ) ;
    Imposed.Ajcomb          = var_name  (  21,2  ) ;
elseif strcmp(cylinder.cil,'cil2')
    Adjustment.	CW1	        =	numeric	(	1,2	) ;     % Coeficiente Woschni 1
    Adjustment.	CW2	        =	numeric	(	1,2	)/1.7 ; % Coeficiente Woschni 2
    Adjustment.	rcoffset	=	numeric	(	2,2	) ;     % Relacion de compresión offset
    Adjustment.	desfasetot	=	numeric	(	3,2	) ;     % Desfase total
    Adjustment.	CDM	        =	numeric	(	4,2	) ;     % Coeficiente de deformaciones mecánicas
    Adjustment.	RPC	        =	numeric	(	5,2	) ;     % Corrección a la presion de referencia
    Adjustment.Iterations   =   numeric	(	6,1 ) ;      % Número de iteraciones mínimo a realizar
    Adjustment.A            =   numeric	(	7,1 ) ;
    Adjustment.debug        =   var_name(	9,2 ) ;      % Factor de Ponderación A=1 solo dFQL y A=0 solo Delta P
    Adjustment.conv         =   numeric	(	9,1 )/100 ; % Factor de convergencia, variación mínima para terminar el ajuste, entre parametros ajustados respecto al anterior valor
    % Imponer Valores de ajuste (1 ajustar, 0 Imponer)
    Imposed.CW1             = numeric   (  11,1  ) ;
    Imposed.rcoffset        = numeric   (  12,1  ) ;
    Imposed.desfasetot      = numeric   (  13,1  ) ;
    Imposed.CDM             = numeric   (  14,1  ) ;
    Imposed.pref0           = numeric   (  15,1  ) ;
    Imposed.pref            = numeric   (  16,1  ) ;
    Imposed.Ajcomb          = var_name  (  21,2  ) ;
    % Parameters for each cilinder
    elseif strcmp(cylinder.cil,'cil3')
    Adjustment.	CW1	        =	numeric	(	1,3	) ;     % Coeficiente Woschni 1
    Adjustment.	CW2	        =	numeric	(	1,3	)/1.7 ; % Coeficiente Woschni 2
    Adjustment.	rcoffset	=	numeric	(	2,3	) ;     % Relacion de compresión offset
    Adjustment.	desfasetot	=	numeric	(	3,3	) ;     % Desfase total
    Adjustment.	CDM	        =	numeric	(	4,3	) ;     % Coeficiente de deformaciones mecánicas
    Adjustment.	RPC	        =	numeric	(	5,3	) ;     % Corrección a la presion de referencia
    Adjustment.Iterations   =   numeric	(	6,1 ) ;      % Número de iteraciones mínimo a realizar
    Adjustment.A            =   numeric	(	7,1 ) ;
    Adjustment.debug        =   var_name(	9,2 ) ;      % Factor de Ponderación A=1 solo dFQL y A=0 solo Delta P
    Adjustment.conv         =   numeric	(	9,1 )/100 ; % Factor de convergencia, variación mínima para terminar el ajuste, entre parametros ajustados respecto al anterior valor
    % Imponer Valores de ajuste (1 ajustar, 0 Imponer)
    Imposed.CW1             = numeric   (  11,1  ) ;
    Imposed.rcoffset        = numeric   (  12,1  ) ;
    Imposed.desfasetot      = numeric   (  13,1  ) ;
    Imposed.CDM             = numeric   (  14,1  ) ;
    Imposed.pref0           = numeric   (  15,1  ) ;
    Imposed.pref            = numeric   (  16,1  ) ;
    Imposed.Ajcomb          = var_name  (  21,2  ) ;
    % Parameters for each cilinder
    elseif strcmp(cylinder.cil,'cil4')
    Adjustment.	CW1	        =	numeric	(	1,4	) ;     % Coeficiente Woschni 1
    Adjustment.	CW2	        =	numeric	(	1,4	)/1.7 ; % Coeficiente Woschni 2
    Adjustment.	rcoffset	=	numeric	(	2,4	) ;     % Relacion de compresión offset
    Adjustment.	desfasetot	=	numeric	(	3,4	) ;     % Desfase total
    Adjustment.	CDM	        =	numeric	(	4,4	) ;     % Coeficiente de deformaciones mecánicas
    Adjustment.	RPC	        =	numeric	(	5,4	) ;     % Corrección a la presion de referencia
    Adjustment.Iterations   =   numeric	(	6,1 ) ;      % Número de iteraciones mínimo a realizar
    Adjustment.A            =   numeric	(	7,1 ) ;
    Adjustment.debug        =   var_name(	9,2 ) ;      % Factor de Ponderación A=1 solo dFQL y A=0 solo Delta P
    Adjustment.conv         =   numeric	(	9,1 )/100 ; % Factor de convergencia, variación mínima para terminar el ajuste, entre parametros ajustados respecto al anterior valor
    % Imponer Valores de ajuste (1 ajustar, 0 Imponer)
    Imposed.CW1             = numeric   (  11,1  ) ;
    Imposed.rcoffset        = numeric   (  12,1  ) ;
    Imposed.desfasetot      = numeric   (  13,1  ) ;
    Imposed.CDM             = numeric   (  14,1  ) ;
    Imposed.pref0           = numeric   (  15,1  ) ;
    Imposed.pref            = numeric   (  16,1  ) ;
    Imposed.Ajcomb          = var_name  (  21,2  ) ;
    % Parameters for each cilinder
end
Adjustment.b  = numeric (  22,1  );
Adjustment.C2 = numeric (  23,1  );
Adjustment.C  = numeric (  24,1  );
Adjustment.Model  = var_name (  26,2  );


