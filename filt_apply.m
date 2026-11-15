function signal_filt=filt_apply(fft_signal,j_cutoff,npc,num_tests,nc,delta)


filt=cos_fil(j_cutoff,npc,num_tests,delta);

signal_filt=real(ifft(fft_signal.*filt));

signal_filt=signal_filt/nc;