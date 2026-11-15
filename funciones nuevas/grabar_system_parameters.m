function [] = grabar_system_parameters ()
fid=fopen('RAM\Tasa\injection_system_parameters.dat','w');
fprintf(fid,'A0,A1,B0,B1,C0,C1,D0,D1\r\n');
fprintf(fid,'5277.18,64.35,80,0.71,-5277.18,-64.35,0.000228,3.16E-08');
fclose(fid);
end