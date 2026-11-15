function espectro= contraer(espectro_exp,n_mega,ncl,cociente)

    espectro_mean_izq=espectro_exp(1:ncl:n_mega/2);% *half left of the spectrum 
    espectro_mean_der=espectro_exp(n_mega-(ncl-1):-ncl:n_mega/2);% *half right of the spectrum
    long=length(espectro_mean_der); % Result signal length
    espectro_mean_der=espectro_mean_der(long:-1:1); % Turn back the half right signal (for continuity)
    espectro=[espectro_mean_izq; espectro_mean_der]; % Join together both sides of the spectrum
    espectro=espectro*cociente;

    %OTRA FORMA (OJO PORQUE SALE LA PRESION ESPECULAR, HAY QUE DARLE LA VUELTA)
%     cont=0;
%     for i=1:n_mega
%         if i==(cont*ncl+1)
%             cont=cont+1;
%         elseif i>(cont-1)*ncl+1
%             espectro_exp(i)=0; 
%         end
%     end
%     cont=1;
%     for i=1:n_mega
%         if espectro_exp(i)~=0; 
%            espectro(cont)= espectro_exp(i);
%            cont=cont+1;
%         end
%     end
%     espectro=espectro'*cociente;
return

% * Explanation :  A = B(1:25:100) = 1, 25, 50, 75, 100  This procedure
% takes points between 1 and 100 with a step of 25 from the signal B