function [ YaRCA,YqRCA,YfRCA,Yaadm,Yqadm,Yfadm,YaAAE,YqAAE,YfAAE,Yaesc,Yqesc,Yfesc ] = calcula_composicion_RCA_AAE( MAADM,Mainya,MBB,megr,MFCC,Mfadm,Mfa,mres,MCC,FE )
%UNTITLED5 Function to estimate composition at RCA
%   It is an adaptation from a CALMEC function, some variables
%   are just renamed in order to maintain the original names and
%   other are imposed as 0 in order to maintain the original code
    
if MCC < 0
    megr = megr - MCC;
    MCC = 0;
end
MACC = MAADM + Mainya;
MRCA = MAADM + Mainya + megr + (Mfadm + Mfa) + mres - MCC;
Msum = MAADM + megr + Mfadm;
MAAE = MACC + megr + MFCC + mres - MBB - MCC;
Mesc = MACC + megr + MFCC - MBB - MCC;
TEGR = megr / (megr + MAADM);
Mesc_corr = MACC + megr + MFCC - MBB - MCC * TEGR;
FR = MFCC / MACC / FE; %dosado relativo aparente: se va a asumir que el dosado relativo real es rico o pobre igual que lo es el aparente

YqAAE = (MFCC + MACC + megr - MCC + MBB / 2 * (mres / MRCA - 1)) - (Mesc / Mesc_corr) * (megr - MCC * TEGR) * (1 - MBB / 2 / MRCA); %denominador
%calculo de las composiciones en función del dosado relativo
if FR == 1 %dosado estequiométrico
    YqAAE = 1;
    Yqesc = YqAAE * Mesc / Mesc_corr;
    if Yqesc > 1
        Yqesc = 1;
    end
    Yqadm = Yqesc * TEGR;
    YqRCA = (Yqesc * (megr - MCC * TEGR) + mres * YqAAE) / MRCA;
    YaAAE = 0;
    Yaesc = (Mesc * YaAAE + MCC * (1 - TEGR)) / Mesc_corr;
    Yaadm = (MAADM + megr * Yaesc) / Msum;
    YaRCA = (MAADM + megr * Yaesc + mres * YaAAE - MCC * Yaadm) / MRCA;
    YfRCA = 1 - YqRCA - YaRCA;
    YfAAE = 0;
    Yfesc = (Mesc * YfAAE + MCC * Mfadm / Msum) / Mesc_corr;
    Yfadm = (Mfadm + megr * Yfesc) / Msum;
elseif FR < 1  %dosado pobre
    YfAAE = 0;
    Yfesc = (Mesc * YfAAE + MCC * Mfadm / Msum) / Mesc_corr;
    Yfadm = (Mfadm + megr * Yfesc) / Msum;
    YqAAE = (1 + 1 / FE) * (MFCC - MCC * Yfadm) / YqAAE;
    if YqAAE > 1  %si hay mucho cortocircuito puede llegar a tener un dosado relativo real>1
        YqAAE = 1;
    end
    YaAAE = 1 - YqAAE - YfAAE;
    Yqesc = YqAAE * Mesc / Mesc_corr;
    if Yqesc > 1
        Yqesc = 1;
    end
    YqRCA = (Yqesc * (megr - MCC * TEGR) + mres * YqAAE) / MRCA;
    YfRCA = ((Mfadm + Mfa) + megr * Yfesc - MCC * Yfadm) / MRCA;
    YaRCA = 1 - YfRCA - YqRCA;
    Yqadm = Yqesc * TEGR;
    Yaadm = 1 - Yfadm - Yqadm;
    Yaesc = (Mesc * YaAAE + MCC * (1 - TEGR)) / Mesc_corr;
    Yaesc = 1 - Yqesc - Yfesc;
else %FR > 1: dosado rico
    YaAAE = 0;
    Yaesc = (Mesc * YaAAE + MCC * (1 - TEGR)) / Mesc_corr;
    Yaadm = (MAADM + megr * Yaesc) / Msum;
    YaRCA = (MAADM + megr * Yaesc + mres * YaAAE - MCC * Yaadm) / MRCA;
    YqAAE = (1 + FE) * (MACC - MCC * Yaadm - MBB / 2 * YaRCA) / YqAAE;
    if YqAAE > 1 %si hay mucho cortocircuito puede llegar a tener un dosado relativo real>1
        YqAAE = 1;
    end
    YfAAE = 1 - YqAAE - YaAAE;
    Yqesc = YqAAE * Mesc / Mesc_corr;
    if Yqesc > 1
        Yqesc = 1;
    end
    Yqadm = Yqesc * TEGR;
    YqRCA = (Yqesc * (megr - MCC * TEGR) + mres * YqAAE) / MRCA;
    YfRCA = 1 - YaRCA - YqRCA;
    Yfesc = (Mesc * YfAAE + MCC * Mfadm / Msum) / Mesc_corr;
    Yfadm = (Mfadm + megr * Yfesc) / Msum;
    
end


end

