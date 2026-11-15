
function [signal_filt,p]=filtering(p_nc,num_tests,inst,rps)
%This function calculates the filtered averaged signal (p) and the filtered
%signal (signal_filt)

nc=inst.nc;
npc=inst.npc;
numcham=1;
delta=5;%Transition zone length of the filter 
                
fft_nc=fft(p_nc); %Discrete Fourier Transform is calculated for all tests

[fft_signal j_fix j_adap]=get_signal_armonics(fft_nc,npc,nc,num_tests,numcham,rps);%Cuttoff armonics and the FFT of the averaged signal are obtained 

%Cutoff armonic is choosen between the fixed and the adaptive type ones
%j_cutoff=j_fix; 
j_cutoff=j_adap;

p=filt_apply(fft_signal,j_cutoff,npc,num_tests,nc,delta);

signal_filt=filt_apply(fft_nc,j_cutoff*nc,npc*nc,num_tests,1,delta*nc);

