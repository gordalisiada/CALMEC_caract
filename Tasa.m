function [ Inj_Rate,SOI,EOI,masa_total_inj ] = Tasa( Adjustment,intang,SOI1,SOI2,SOI3,SOI4,SOI5,SOI6,SOI7,SOI8,PCR,v_n,N_iny,MF1,MF2,MF3,MF4,MF5,MF6,MF7,MF8,NPC,Inj_saved_path,test_name )
% Tasa Simulates the injection rate and the total injected mass by means of
% the SOI information from ECU


CAI = NPC;
if N_iny < 1
    Injection_rate_vector(1,1) = -Adjustment.desfasetot;
    Injection_rate_vector(1,2) = 0;
   for n=2:CAI
    Injection_rate_vector(n,1) = Injection_rate_vector(n-1,1)+(2*(360/(CAI)));
    Injection_rate_vector(n,2) = 0;
   end 
else
    
%Initialize variables
A0 = 4523.3;
A1 = 55.161;
B0 = 7.2756;
B1 = 0.0113;
C0 = -4523.3;
C1 = -55.161;
D0 = 0.000228;
D1 = 0.0000000316;
SOP(1,1) = SOI1;
SOP(2,1) = SOI2;
SOP(3,1) = SOI3;
SOP(4,1) = SOI4;
SOP(5,1) = SOI5;
SOP(6,1) = SOI6;
SOP(7,1) = SOI7;
SOP(8,1) = SOI8;
IN = N_iny;
speed = v_n*60;
MFI(1,1) = MF1;
MFI(2,1) = MF2;
MFI(3,1) = MF3;
MFI(4,1) = MF4;
MFI(5,1) = MF5;
MFI(6,1) = MF6;
MFI(7,1) = MF7;
MFI(8,1) = MF8;

CAD_injection_rate(1,1) = -Adjustment.desfasetot;

    for counter=2:CAI
        CAD_injection_rate(counter,1) = CAD_injection_rate(counter-1,1)+intang;
        if CAD_injection_rate <= SOP(1,1);
            k1 = counter;
        elseif CAD_injection_rate <= SOP(2,1);
            k2 = counter;
        elseif CAD_injection_rate <= SOP(3,1);
            k3 = counter;
        end
    
        counter = counter+1;
    end

    
%Inyection rate Calculation
a = (A1*PCR+A0)*1e3;
b = (B1*PCR+B0)*1e3;
c = (C1*PCR+C0)*1e3;

%Definition of inyection rate of each injection
mftopemini = 1/2*((b/a)+(b/-c))*b;

for j = 1:IN
    
    SOI(j,1) = SOP(j,1)+(D1*PCR+D0)*(6*speed);
    %Total fuel mass injected
    if MFI(j,1) >= mftopemini
        DLM = (MFI(j,1)-mftopemini)/b;
        for k = 1:CAI
            
            %time between SOI and current point
            time = (CAD_injection_rate(k,1)-SOI(j,1))/(6*speed);
            %Calculation of injection rate
            if and(time>0,time<=b/a)
                injection_rate(k,1) = time*a;
            elseif and(time>b/a,time<=b/a+DLM)
                injection_rate(k,1) = b;
            elseif and(time>b/a+DLM,time<=b/a+DLM+b/-c)
                injection_rate(k,1) = b+((time-b/a-DLM)*c);
                l=k;
            
            end
            k=k+1;
        end
                %Calculatiton of end of injection
            EOI(j,1) = SOI(j,1)+(b/a+DLM+b/-c)*6*speed;
    else
        levmaxi = ((2*MFI(j,1))/(1/a+1/-c))^0.5;
        DTL = levmaxi/a;
        DTB = levmaxi/-c;
    
        for k=1:CAI
            
            %time between SOI and current point
            time = (CAD_injection_rate(k,1)-SOI(j,1))/(6*speed);
            if and(time>0,time<=DTL)
                injection_rate(k,1) = time*a;
            elseif and(time>DTL,time<=DTL+DTB)
                injection_rate(k,1) = levmaxi+(time-DTL)*c;
            end
            k=k+1;
        end
    
    %Calculation of end of injection
    EOI(j,1) = SOI(j,1)+(DTL+DTB)*6*speed;
    end
    j = j+1;
end
%Filling vector with zero
for m = l:CAI
    injection_rate(m,1) = 0;
end


%Converts mg/s to g/s
for k = 1:CAI
    injection_rate(k,1) = (injection_rate(k,1)/1000);
    k = k+1;
end
masa_total_inj = 0;
for n = 1:CAI
    Injection_rate_vector(n,1) = CAD_injection_rate(n,1);
    Injection_rate_vector(n,2) = injection_rate(n,1);
    masa_total_inj = masa_total_inj+Injection_rate_vector(n,2);
end
masa_total_inj = masa_total_inj*intang;



end
% figure
% hold on
% title('Injection Rate for CALMEC LAB');
% plot(Injection_rate_vector(1:CAI,1),Injection_rate_vector(1:CAI,2));
% xlabel('[º]');
% ylabel('[g/s]');
%save injection rate file on .dat format
save([Inj_saved_path cell2mat(test_name) '_Injection_rate.dat'],'Injection_rate_vector','-ASCII');
Inj_Rate = Injection_rate_vector(:,:);
SOI = SOI(:,:);
EOI = EOI(:,:);
end                