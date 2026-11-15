function [hdr,offset,rank,str_type] = hdr_read(P)

header = P(1:45);

if header(30) == 13
    hdr = 31;
    offset = 0;
    rank = str2num(char(P(24:29)'));
    str_type = 'CYokoAR1100';    
    if header(15)==44
        hdr=35;
        offset=0;
        rank=str2num(char(P(27:32)'));
        str_type='CYokoORM1200';
    else
        pos=find(P==35);
        if pos>0
            k1=find(header==59);
            k2=find(header==35);
            hdr=k2+10;
            rank=str2num(char(P(1:(k1-1))'));
            offset=str2num(char(P((k1+1):(k2-1))'));
            str_type='CYokoDL708';
        else
            cad_rank=char(header((37:42)));
            switch cad_rank
                case '50mV  '
                    rango=0.05;
                case '100mV '
                    rango=0.1;
                case '200mV '
                    rango=0.2;
                case '500mV '
                    rango=0.5;
                case '1V    '
                    rango=1;
                case '2V    '
                    rango=2;
                case '5V    '
                    rango=5;
                case '10V   '
                    rango=10;
                case '20V   '
                    rango=20;
                case '50V   '
                    rango=50;
                case '100V  '
                    rango=100;
                case '200V  '
                    rango=200;
                case '500V  '
                    rango=500;
            end
            offset=0;
            hdr=45;
            str_type='CYokoOR1400';
        end
    end
else
    hdr = 48;
    pie = P(end-45:end);
    rank = str2num(char(pie(1:8)'));
    offset = str2num(char(pie(10:17)'));
    str_type = 'CYkDL850V';
end


