function []=grabar_inyection_parameters (v,ens)
fid1=fopen('RAM\Tasa\injection_parameters.dat','w');
fprintf(fid1,'PULSO,AV,mfuel,PMI_hp\r\n');
for i=1:v.N_iny(ens)
    if i==1
        fprintf(fid1,'1,');
        fprintf(fid1,'%f,',v.SOI1(ens));
        fprintf(fid1,'%f,',v.MF1(ens));
        fprintf(fid1,'0\r\n');
    elseif i==2
        fprintf(fid1,'2,');
        fprintf(fid1,'%f,',v.SOI2(ens));
        fprintf(fid1,'%f,',v.MF2(ens));
        fprintf(fid1,'0\r\n');
    elseif i==3
        fprintf(fid1,'3,');
        fprintf(fid1,'%f,',v.SOI3(ens));
        fprintf(fid1,'%f,',v.MF3(ens));
        fprintf(fid1,'0\r\n');
    elseif i==4
        fprintf(fid1,'4,');
        fprintf(fid1,'%f,',v.SOI4(ens));
        fprintf(fid1,'%f,',v.MF4(ens));
        fprintf(fid1,'0\r\n');
    elseif i==5
        fprintf(fid1,'5,');
        fprintf(fid1,'%f,',v.SOI5(ens));
        fprintf(fid1,'%f,',v.MF5(ens));
        fprintf(fid1,'0\r\n');
    elseif i==6
        fprintf(fid1,'6,');
        fprintf(fid1,'%f,',v.SOI6(ens));
        fprintf(fid1,'%f,',v.MF6(ens));
        fprintf(fid1,'0\r\n');
    elseif i==7
        fprintf(fid1,'7,');
        fprintf(fid1,'%f,',v.SOI7(ens));
        fprintf(fid1,'%f,',v.MF7(ens));
        fprintf(fid1,'0\r\n');
    elseif i==8
        fprintf(fid1,'8,');
        fprintf(fid1,'%f,',v.SOI8(ens));
        fprintf(fid1,'%f,',v.MF8(ens));
        fprintf(fid1,'0\r\n');
    end
end  
fclose(fid1);
end