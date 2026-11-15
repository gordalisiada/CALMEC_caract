function [fft_signal j_fix j_adap]=get_signal_armonics(fft_nc,npc,nc,num_tests,numcham,rps);
%This function calculates the averaged signal (fft_signal) and the cutoff armonics (j_fix,j_adap) in two ways: 
%   1.Using noise information (mean noise)  
%   2.Using angular velocity (rps)

%CALCULATION OF AVERAGED SIGNAL
fft_res=reshape(fft_nc,nc,npc*numcham,num_tests);

%Ordering in this way the first row is the averaged signal
fft_signal=fft_res(1,:,:);
fft_signal=reshape(fft_signal,npc,numcham,num_tests);%Averaged signal for each chamber

%CALCULATION OF CUTOFF ARMONICS USING NOISE INFORMATION
fft_res_abs=abs(fft_res);%Noise and signal module are calculated
mean_noise=mean(fft_res_abs(2:nc,:,:));%Noise mean is calculated
c=2;%Max ratio noise-signal
mid=fix(npc/2);%Due to symmetry, only half is calculated

[i,j,k]=ind2sub( [1 mid num_tests] , find(fft_res_abs(1,1:mid,:)<c*mean_noise(1,1:mid,:)));%When c*noise>signal, all the espectrum is noise
k=diff(k);
j_adap(:,1)=j([1; find(k==1)+1]);%Cutoff frecuency for the chamber 1 in each test

[i,j,k]=ind2sub( [1 mid num_tests] , find(fft_res_abs(1,npc+1:npc+mid,:)<c*mean_noise(1,npc+1:npc+mid,:)));
k=diff(k);
j_adap(:,2)=j([1; find(k==1)+1]);%Cutoff frecuency for the chamber 2 in each test

[i,j,k]=ind2sub( [1 mid num_tests] , find(fft_res_abs(1,2*npc+1:2*npc+mid,:)<c*mean_noise(1,2*npc+1:2*npc+mid,:)));
k=diff(k);
j_adap(:,3)=j([1; find(k==1)+1]);%Cutoff frecuency for the chamber 3 in each test


%CALCULATION OF CUTOFF ARMONICS USING ANGULAR VELOCITY

rpm=60*rps; %Revolutions per minute

j_fix(find(rpm<=1250))=240;
j_fix(find(rpm>=4000))=144;
j_fix(find(and(rpm>1250,rpm<4000)))=round((144-240)*(rpm-1250)/(4000-1250)+240)-30;

j_fix=round((j_fix+60)/2);

j_fix=[j_fix' j_fix' j_fix'];%Cutoff armonics are the same for all chambers












