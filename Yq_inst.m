function Yq_instant=Yq_inst(ma,mf,megr,MRESI,MCC,mbbacum,minyacum,Fluid,fql,yq2,yq0)

Yq = (mf + mf / Fluid.FE) * fql + (megr + MRESI) * yq2 - (MCC + mbbacum / 2) * yq0;
Yq_instant= Yq/(minyacum + ma + megr + MRESI - MCC - mbbacum / 2);
if Yq_instant<0; %no puede ser negativa
Yq_instant = 0; 
end
if Yq_instant>1; %no puede ser mayor que uno
Yq_instant=1; 
end
end
