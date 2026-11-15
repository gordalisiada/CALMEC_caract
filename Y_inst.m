function [ Ya,Yq,Yf ] = Y_inst( MCC,megr,MAADM,MFCC,fql_ang,Yqesc,MRESI,YqAAE,MBB,YqRCA,mfinyacum,mainyacum,FE,HP )
% Y_inst Calculate the instantaneous fractions of air,
% burned gases and fuel

fql = fql_ang/(MFCC*HP);

if MCC < 0
    megr = megr - MCC;
    MCC = 0;
end

TEGR = megr / (MAADM + megr);
% Yq = (MFCC + MFCC / FE) * fql + (megr + MRESI) * Yq2 - (MCC + mbbacum / 2) * yq0
Yq = (MFCC + MFCC / FE) * fql + (megr - MCC * TEGR) * Yqesc + MRESI * YqAAE - (MBB / 2) * YqRCA;
Yq = Yq / (mfinyacum + mainyacum + MAADM + megr + MRESI - MCC - MBB / 2);
if Yq < 0
    Yq = 0; % no puede ser negativa
elseif Yq > 1
    Yq = 1; % no puede ser mayor que uno
end

Yf = (mfinyacum - MFCC * fql) / (mfinyacum + mainyacum + MAADM + megr + MRESI - MCC - MBB);
if Yf < 0
    Yf = 0; % no puede ser negativa
elseif Yf > 1
    Yf = 1; % no puede ser mayor que uno
end

Ya = 1 - Yq - Yf;  %Calcula la fraccion de aire
if Ya < 0
    Ya = 0;
    Yf = Yf / (Yf + Yq);
    Yq = Yq / (Yf + Yq);
end

end

