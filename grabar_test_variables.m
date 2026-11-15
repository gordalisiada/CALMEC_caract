function []=grabar_test_variables(v,ens,n_ens)
fid2=fopen('RAM\Tasa\test_variables.dat','w');
fprintf(fid2,'speed,mairadm,mairIVC,temperatureIVC,mfuel,PCR,inlet_press,exhaust_press,Cbb,Atmosohere_press,inj_fuel_temp,TCYL_HEAD,TCYL,TPIS,YNOx,YSOOT,YCO,YHC\r\n');
fprintf(fid2,'%f,',n_ens);
fprintf(fid2,'%f,', v.GA(ens));
fprintf(fid2,'0,0,');
mf_cc=10e05*v.GF(ens)*(1/n_ens)*60*2/4;
fprintf(fid2,'%f,',mf_cc);
fprintf(fid2,'%f,',v.PCR(ens));
fprintf(fid2,'%f,',v.Pe(ens));
fprintf(fid2,'%f,',v.Pa(ens));
fprintf(fid2,'0,');
fprintf(fid2,'%f,',v.Pc(ens));
Tfm=v.Tf(ens)+125;
fprintf(fid2,'%f,',Tfm);
fprintf(fid2,'0,0,0,0,0,0,0');
fclose(fid2);
end