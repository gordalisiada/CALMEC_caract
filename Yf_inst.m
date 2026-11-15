function Yf_instant=Yf_inst(mf,ma,megr,MRESI,MCC,minyacum,mbbacum,fql)
Yf_instant = (minyacum - mf*fql) / (minyacum + ma + megr + MRESI - MCC - mbbacum);
if Yf_instant<0;  %no puede ser negativa
Yf_instant = 0;
end
if Yf_instant > 1;  %no puede ser mayor que uno
Yf_instant = 1;
end
end
