function [ output_args ] = Calcula_MCC_y_MRESI( MAADM,MAINYCC,megr,MFCC,Msum,MCAaj )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% OJO cuando las variables Ajuste... son true NO se ha impuesto en la ventana de ajuste manual

% if e.ConfiguracionMotor.MotorAuxiliar.inyeccion.TIPO_INYECCION = "N" And e.tipo_ensayo = "C"  % inyeccion neumática
%     MAINYCC = v.GAINY / (v.Z * (v.n / e.ConfiguracionMotor.motorbase.CRevCiclo));
% else
%     MAINYCC = 0;
% end

MACC = MAADM + MAINYCC;

% Para definir las masas/composiciones es necesario saber 2 de los datos (mres, mcc, mrca,rendret o yrca)
% Si la masa MRCA proviene del ajuste del cuasiestacionario se conocerá también MRESI y MCC por lo que no hay que hacer nada
% ModoAjusteMRCA=0 (cuasiestacionario), =1 (ajuste termodinamico)


if ((AjusteYqRCA && AjusteRendRet) && (AjusteMRCA = False Or ModoAjusteMRCA))
    opcion_calculo = '1'; % Se impone MRCA solamente(bien desde la pantalla de imponer parametros o desde el ajuste termodinamico),Yrca y Rendret se calculan.
elseif AjusteYqRCA &&~ AjusteRendRet %Se impone rendret (mcc) y MCAaj, que se obtiene con cuasi, se impone o se ajuste termodinamicamente (la composición al cierre se calcula)
    opcion_calculo = '2'; % Se impone Rendret  y la composición al cierre se calcula
elseif (~ AjusteYqRCA && AjusteRendRet) || (~ AjusteYqRCA && Not AjusteRendRet) 
    opcion_calculo = '3'; % Se impone Yrca y no Rendret (mrca disponible porque se ha impuesto, calculado con cuasi o termodinamicamente), o bien se imponen ambas (mrca se habra obtenido con cuasi o termodinamicamente pero no se usa -no deja que se impongan 3 parametros-)
end


    if strcmp(opcion_calculo,'1')
        if MCAaj > Msum 
            MCC = 0;
            MRESI = MCAaj - Msum - Mfa;
        else
            MRESI = 0;
            MCC = Msum + Mfa - MCAaj;
        end 
    elseif strcmp(opcion_calculo,'2')
        MCC = Msum * (1 - RendRetaj);
        MRESI = MCAaj - Msum - Mfa + MCC;
    elseif strcmp(opcion_calculo,'3')
        delta = 0.1;
        YqRCA_ant = -1;
        YqRCA_aux = YqRCAaj;
        rend_barr = 0.8; % masa retenida/masa al RCA (valor inicial)
        % RendRetaj = 0.65 'masa retenida/masa suministrada
    
%         Do
            MRESI = MCAaj * (1 - rend_barr);
            if (~ AjusteYqRCA && ~ AjusteRendRet) % se impone Yrca y Rendret por lo que la mrca se reajusta
                MCC = Msum * (1 - RendRetaj);
                MCAaj = Msum + Mfa + MRESI - MCC;
            else % mRCA vale (venga de donde venga) y solo se ha impuesto Yrca (Rend ret se ajusta)
                MCC = MRESI - MCAaj + Msum;
            end 
            
            Mret = rend_barr * MCAaj;
            
            [ ~,YqRCA,~,~,~,~,~,~,~,~,~,~ ] = calcula_composicion_RCA_AAE( MAADM,Mainya,MBB,megr,MFCC,Mfadm,Mfa,mres,MCC,FE );
            if YqRCA_ant == -1 % es la primera iteración
                YqRCA_ant = YqRCA;
                rend_barr_ant = rend_barr;
                rend_barr = rend_barr + delta;
            else % al menos es la segunda iteración
                if (Abs(YqRCA - CDbl(YqRCA_aux)) > 0.0001)
                    if ((YqRCA_ant - CDbl(YqRCA_aux)) * (YqRCA - CDbl(YqRCA_aux))) > 0 % no cambia de signo
                        if Abs(YqRCA_ant - CDbl(YqRCA_aux)) > Abs(YqRCA - CDbl(YqRCA_aux)) % la variación del rendimiento va en el sentido correcto
                            YqRCA_ant = YqRCA;
                            rend_barr_ant = rend_barr;
                            signo = 1;
                            modulo = 1;
                        else % la variación del rendimiento va en el sentido contrario
                            YqRCA_ant = YqRCA_ant;
                            rend_barr = rend_barr_ant;
                            signo = -1;
                            modulo = 1;
                        end 
                    else % cambia de signo
                        YqRCA_ant = YqRCA_ant;
                        rend_barr = rend_barr_ant;
                        signo = 1;
                        modulo = 0.5;
                    end 
                else % Ya se ha llegado a la Yrca deseada
%                     Exit Do
                end 
                delta = signo * modulo * delta;
                rend_barr_ant = rend_barr;
                rend_barr = rend_barr + delta;
            end 
    end
%         Loop

end

