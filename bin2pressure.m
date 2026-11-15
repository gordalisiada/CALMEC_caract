function [ P ] = bin2pressure(bin_dir,Instr)

fclose('all');

c_capt = Instr.c_capt_1;
offset_c = Instr.offset_c_1;
coef_mult = Instr.coef_mult_1;

fid = fopen(bin_dir,'r');
P = fread(fid);
fclose(fid);
[hdr,offset,rank,str_type] = hdr_read(P);
% n = length(P);
% length_data = n-hdr;
% par = [1:length_data/2]*2;
% impar = par-1;  

switch str_type
    case 'CYkDL850V'
        n = length(P);        
        length_data = n-hdr-14;        
        par = [1:length_data/2]*2;
        impar = par-1;
        Pdec = P((14):n);
%         Pdec = P((2):n);
        Pdec_impar = Pdec(impar);
        Pdec_par = Pdec(par);
%         P = bin2dec([dec2bin(Pdec_par),dec2bin(Pdec_impar)])-2^16;
        P = bin2dec([dec2bin(Pdec_impar),dec2bin(Pdec_par)])-2^16;
    otherwise
        n = length(P);        
        length_data = n-hdr;        
        par = [1:length_data/2]*2;
        impar = par-1;
        Pdec = P((hdr+1):n);
        Pdec_impar = Pdec(impar);
        Pdec_par = Pdec(par);
        P = bin2dec([dec2bin(Pdec_par),dec2bin(Pdec_impar)])-2^16;
end

a = find(P<(-2^16)/2);

P(a) = P(a)+2^16;

switch str_type   
    case 'CYokoDL708'
        P = rank*P*8/64000+offset; 
    case 'CYkDL850V'
        P = P * rank * 10 / 24000;
        P(:,2) = [];
    otherwise
        P = rank*P/24000;  
end

P = (P*c_capt+offset_c)*coef_mult;



