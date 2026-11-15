function [presionr,pre_der] = fft_mean_der(Instr,Engine,phase,n,pressure)

%COMPARACIÓN DEL FILTRADO-PROMEDIADO DEL MEGACICLO CON EL PROCEDIMIENTO
%ANTIGUO DE PROMEDIADO+FILTRADO

%% Measurement data
ncl = Instr.nc; % Number of cycles
npc = Instr.npc; % Samples per cycle
n_mega = ncl*npc; % Measurement length
CRevCiclo = Engine.NOS / 2; % Factor of strokes (2(4strokes),1(2strokes)
CGradosCiclo = CRevCiclo * 360; % Degrees per cycle
intang = (CGradosCiclo/npc); % Angular step
n = n*60; % Speed (rpm)
comb = false; % Motored/Combustion
n_vent=5; % Amount of points for windowing
cociente=1/ncl; % Multiplication factor due to points reduction 
%ventana=[linspace(0,1,n_vent)  ones(n_mega-2*n_vent,1)' linspace(1,0,n_vent)]';%ventana
ventana=ones(n_mega,1);% * No windowing 

%% LEEMOS DE FICHERO
% angulo_mega = pressure(1:ncl*npc,1);   % Angle for all cycles(CAD)
pre_mega_OK = pressure(1:ncl*npc,2);   % All unfiltered pressure cycles (pa)

% error=zeros(n_mega,1); %sin error
% pre_mega=pre_mega_OK + error;
pre_mega = pre_mega_OK; % **

%% MEGA-CYCLE SPECTRUM CALCULATION, NEW METHODOLOGY

% Reference to make equidistant the start and the end of the signal (to
% windowing). Take 5 points and start and 5 at end
ref = mean([pre_mega(1:n_vent)' pre_mega(n_mega-n_vent+1:n_mega)']',1);
% Reference is applied on the signal (to windowing)
pre_mega_ref = pre_mega-ref;
% Mega-cycle windowing
pre_mega_vent = ventana.*pre_mega_ref;
% Spectrum complete
espectro_mega = fft(pre_mega_vent); 
% Harmonics of elemental cycle are taken
espectro_mean = contraer(espectro_mega,n_mega,ncl,cociente); 
% Expand spectrum until n_mega=ncl*npc in order to plot
espectro_mean_exp = expandir(espectro_mean,npc,ncl,cociente); 

%% MEAN CYCLE NORMAL AVERAGED (WITH ERROR)

% % Distribute the cycles in  the number of cycles
% todos_ciclos=reshape(pre_mega,npc,ncl);
% % Average each point (ncl points)
% pre_ciclo=sum(todos_ciclos,2)/ncl;
% % Spectrum calculation
% espectro_ciclo=fft(pre_ciclo);
% % Expand spectrum until n_mega=ncl*npc in order to plot
% espectro_ciclo_exp=expandir(espectro_ciclo,npc,ncl,cociente);
% % Calculation of the norm for the complex number
% modulo_ciclo=abs(espectro_ciclo);
% modulo_ciclo_exp=abs(espectro_ciclo_exp);
% % Reconstruction of the averaged pressure signal by means of ifft
% pre_ciclo_recomp=ifft(espectro_ciclo);

%% FILTER

% Create the filter
filtro = filtrar(comb,n,npc)';
%filtro=ones(1,npc);%sin filtrar
% Filter the signals
% espectro_mean_filt = espectro_mean.*filtro;
espectro_mean_filt = espectro_mean;
% espectro_ciclo_filt = espectro_ciclo.*filtro;
% espectro_ciclo_OK_filt = espectro_ciclo_OK.*filtro;
% Calculation of the norm for the complex number
% modulo_mean_filt = abs(espectro_mean_filt);
% modulo_ciclo_filt = abs(espectro_ciclo_filt);
%modulo_ciclo_OK_filt=abs(espectro_ciclo_OK_filt);
% Reconstruction of the averaged pressure signal by means of ifft
pre_mean_filt = ifft(espectro_mean_filt);
% pre_ciclo_filt = ifft(espectro_ciclo_filt);
% pre_ciclo_OK_filt = ifft(espectro_ciclo_OK_filt);

%% DERIVATIVE
clear i
for cont = 1:npc/2
    espectro_ciclo_der(cont) = i*(cont-1)*espectro_mean_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(cont-1)*espectro_ciclo_OK_filt(cont);
end  
for cont = npc/2+1:npc
    espectro_ciclo_der(cont) = -i*(npc-cont+1)*espectro_mean_filt(cont);
%     espectro_ciclo_OK_der(cont)=i*w*(npc-cont+1)*espectro_ciclo_OK_filt(cont);
end 
pre_ciclo_der = ifft(espectro_ciclo_der)';
pre_ciclo_der = pre_ciclo_der/2;
% pre_ciclo_der_KK = diff([pre_ciclo;pre_ciclo(1)])/intang*(180/pi); %****


presion(:,1) = linspace(-phase+180,-phase+180+720,npc);
pre_der(:,1) = presion(:,1);
presion(:,2) = pre_mean_filt;
pre_der(:,2) = pre_ciclo_der;
presionr = set_angle(npc,CGradosCiclo,-phase,presion);
presionr(:,2) = presionr(:,2)-min(presionr(:,2))+1.5; % referencia a 1.5 [bar]
pre_der = set_angle(npc,CGradosCiclo,-phase,pre_der);
pre_der(:,2) = intang*(pi/180)*pre_der(:,2); % derivative in [pa/CAD]

end

% * No se para que crea la ventana si le da valor 1 y no afecta los
% calculos

% ** Es redundante, no se para que la usa en los calculos si es la misma
% variable

%*** No se que pasa exactamente, no lo he comprobado y creo que al menos
%matematicamente no se esta haciendo nada, debe ser que se uso esta
%operacion para hacer algunas pruebas que ahora estan como comentarios, o
%se borrarian las lineas de codigo que afectaban esto

%****EN TESIS PONE QUE ES POR EL METODO DE LAS DIFERENCIAS CENTRADAS PERO REALMENTE ES MAS CUTRE AUN