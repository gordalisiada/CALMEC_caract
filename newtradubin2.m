
clc;
clear;
fid = fopen('1200_1f_000CH3_P_esc17_22.bin');
% almo=char(35)
c = fread(fid,20, 'uint8=>char')'
pos1=strfind(c,'#');
form=strcat('%*',num2str(pos1,'%d'),'c%d%s');
c=sscanf(c,form);
c=c(1)
Bytes=num2str(c);
Bytes=Bytes(2:length(Bytes))
pos2=(pos1+length(c))*2+1;
fseek(fid,pos2-20,'cof');
test=fread(fid,	1,'uint8=>char')'
fseek(fid,-1,'cof');
datos = fread(fid,str2num(Bytes)/2, 'int16', 'b')';
resto=fread(fid,500,'uint8=>char')';
resto=strrep(resto, ',', '.');
resto=strrep(resto, '#', '');
resto=sscanf(resto,'%f;%f;%f;%f;%f;');
vrange=resto(1)/2400;
offset=resto(2);
incr=resto(3);
coefcalib_a=resto(4);
coefcalib_b=resto(5);
datos_V=datos.*vrange+offset;
datos_ph=datos_V.*coefcalib_a+coefcalib_b;
fclose(fid);
