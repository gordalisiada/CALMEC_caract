function m_resi=Masa_Residual(MFCC,MACC,megr,Fluid,Adjustment,Engine,v_Ta,v_Pa,v_Pe,v_n,FR)

v_Pa=v_Pa/100000;
%Valores del aire
R=287;
cp=(7/2)*R;
cv=(5/2)*R;
gamma=(cp/cv);
%Calculo de la fraccion de combustible quemado durante la compresion v=cte
MFCC_quem=MFCC*0.9;
alpha=MFCC_quem/MFCC;
%Masa en el cilindro sin tomar en cuenta la masa de residuales
mcil=MACC+megr;
%Calculo de la energía gastada en el calculo de la fraccion alpha
beta=(alpha*Fluid.HP*MFCC)/(mcil*cv*(Adjustment.rcoffset^(gamma-1))*v_Ta);
omega=((1-alpha)*MFCC*Fluid.HP)/(mcil*cp*(Adjustment.rcoffset^(gamma-1))*v_Ta);
CR1=-0.00120852;
CR2=1.27691426;
CR3=0.44662694;
%Fraccion de masa de residuales
v_Pe = v_Pe/100000; % Aca v_Pe queda en [bar]
Xr1=(((R*v_Ta)/v_Pe)^0.5);
Xr2=((v_Pe/v_Pa)^((gamma-1)/2*gamma));
Xr3=((Adjustment.rcoffset-1)/Adjustment.rcoffset);
Xr4=(((1+beta)^(((gamma-1)/2*gamma)))/((1+beta+omega)^0.5));
Xr5=sqrt(abs(v_Pe-v_Pa));
Xr6=(Engine.OF/v_n) ;
Xr7=(1/Adjustment.rcoffset)*((v_Pe/v_Pa)^(1/gamma))*(((1+beta)^((gamma-1)/gamma))/(1+beta+omega));
Xr=CR1*(Xr1*Xr2*Xr3*Xr4*Xr5*Xr6)+(CR2+CR3*FR)*Xr7;
m_resi=((Xr*(MACC+megr))/(1-Xr));
v_Pe = v_Pe*100000; % Aca v_Pe regresa a [Pa]
end