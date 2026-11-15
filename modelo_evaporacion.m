function mass_ev = modelo_evaporacion(MFCC,Engine,N_iny,SOI,EOI,CGradosCiclo,CRevCiclo,v_n,intang,injection_rate,NPC,presionr,factp,facti,vcc,masa_total_inj,Fluid,masacil)

    for j=1:N_iny
        for k=1:NPC
            if injection_rate(k,1)<=SOI(j)
                k1(j)=k;
                ang_inj_ini(j)=injection_rate(k1(j),1);
            elseif injection_rate(k,1)<=EOI(j)
                k2(j)=k;
                ang_inj_fin(j)=injection_rate(k2(j),1);
            end
        end
    end
    
    for j=1:N_iny
        masa_total_p_iny(j)=0;
        for l=k1(j):k2(j)
            masa_total_p_iny(j)=masa_total_p_iny(j)+injection_rate(l,2);
        end
        masa_total_p_iny(j)= masa_total_p_iny(j)*intang;
    end
    
    masa_total_inj=0;
    for j=1:N_iny
    masa_total_inj=masa_total_inj+masa_total_p_iny(j);
    end
                
CTasaDesfasada_Delta=0.0000024;
CTasaDesfasada_MaxNumIter=100;
area_orificios = Engine.NORIF * Engine.DORIF ^ 2 * pi / 4; %area total de los orificios

tiempo_atom_evap = 2.41E-6;
for j = 1:N_iny
        t_ant_ant = 0;
        t_ant = 0;
        cont = 1;
 
    
        tiempo_iny(j)=EOI(j)-SOI(j);% Inicio y final de la inyección
        if tiempo_iny(j)<0
            tiempo_iny(j) = tiempo_iny(j) + CGradosCiclo;
        end
            tiempo_iny(j) = tiempo_iny(j) / (CGradosCiclo / 2 * v_n);%Duracion de la inyeccion
            
           for h=1:NPC
                if injection_rate(h,1)<=SOI(j);
                    ini(j)=h;
                end
                if injection_rate(h,1)<=EOI(j);
                    fin(j)=h;
                end
           end

                   if fin(j)<ini(j)
                       fin(j)=fin(j)+NPC;
                   end
                   fin0(j)=fin(j);
                   n_interv_iny = fin0(j) - ini(j);
                   
           %puede ser cero     
            if n_interv_iny < 1  
            n_interv_iny = 1;
            end
   while not(or((or(((abs(t_ant-tiempo_atom_evap))<CTasaDesfasada_Delta),(t_ant_ant - tiempo_atom_evap == 0 ))),cont > CTasaDesfasada_MaxNumIter));         
            t_ant_ant = t_ant;
            t_ant = tiempo_atom_evap;
            p_med = 0;
            v_med = 0;
            %calculo de las presiones medias en el cilindro
           if cont>1
               ent=fix(desfase(j)/intang);
               fin(j)=fin0(j)+ent ;
           end
            
            n_puntos_iny_at_ev = fin(j) - ini(j) + 1;
            
            for i=ini(j):fin(j)
                ciclo_pre=modX(i,NPC);
                p_med = p_med + presionr(ciclo_pre,2);%puntos de presion en la inyeccion + atomización + evaporación j
                [~,vol] = DistPistonCulataDef(intang,NPC,presionr(ciclo_pre,1),Engine,v_n,presionr(ciclo_pre,2),factp,facti,vcc,CRevCiclo);%puntos de volumen en la inyeccion + atomización + evaporación j
                v_med = v_med + vol;
                
            end
            
            p_med = p_med / n_puntos_iny_at_ev; %dividimos por el numero de puntos de la inyeccion j (+ atomización + evaporación)
            v_med = v_med / n_puntos_iny_at_ev; %dividimos por el numero de puntos  de la inyeccion j (+ atomización + evaporación)
            masa_iny(j) = MFCC * (masa_total_p_iny(j) / masa_total_inj);
            u0_med = masa_iny(j) / (n_interv_iny * intang) * (v_n * CGradosCiclo / 2) / Fluid.DENSF/area_orificios;
            temp_med = (p_med * v_med) / (masacil * (Fluid.RU / Fluid.PMA));
            rho_a = p_med / ((Fluid.RU / Fluid.PMA) * temp_med);
            deq_med = Engine.DORIF * sqrt(Fluid.DENSF / rho_a);
            Yfevap = exp(-12.021 - 0.164674 * log(rho_a) + 1.64132 * log(temp_med));
            TM = 0.155 * (rho_a / 45) ^ 0.18;
            tiempo_atom_evap = 1 / (2 * TM) * deq_med / (u0_med * Yfevap ^ 2);
            
            temp = v_n; %revoluciones por segundo
            temp = temp * CGradosCiclo / 2; %grados por segundo
            desfase(j) = temp * tiempo_atom_evap; %[º]
            cont=cont+1;
            
            
   end            

           
           
end
%%
k = MFCC / masa_total_inj; %factor de multiplicacion
    %Desfasamos
 i=1;
 for i=1:N_iny
        
       i_inicio(i)=modX(ini(i),NPC);
       i_fin(i)=modX(fin(i),NPC);
       cont(i)=i_inicio(i);
       
       while not(cont(i)==i_fin(i))
           cont(i)=modX(cont(i),NPC);
           tasa_real(cont(i),2)=injection_rate(cont(i),2)*k;
           cont(i)=cont(i)+1;
           j=cont(i);
       end
 end
 for comp=j:NPC
     tasa_real(comp,2)=0;
 end
 for i=1:N_iny
     inicio_desf(i)=SOI(i)+desfase(i);
     fin_desf(i)=EOI(i)+desfase(i);
     for l=1:NPC
            if injection_rate(l,1)<=inicio_desf(i)
                l1(i)=l;
                ang_inj_ini(i)=injection_rate(l1(i),1);
            elseif injection_rate(l,1)<=fin_desf(i)
                l2(i)=l;
                ang_inj_fin(i)=injection_rate(l2(i),1);
            end
     end
     i_inicio(i)=l1(i);
     i_fin(i)=l2(i);
 end
     %CALCULO DE LA MASA DE FUEL INYECTADA ACUMULADA
    masa_iny_acum = tasa_real(1,2);
    for j = 2:NPC
    masa_iny_acum = masa_iny_acum + tasa_real(j,2);
    end
    
      %ESCALAMOS PARA QUE MASA INYECTADA (YA DEBE ESTAR) Y EVAPORADA COINCIDAN CON MFCC
    if not(masa_iny_acum == MFCC) 
    k = MFCC / masa_iny_acum;
    for j = 2:NPC
        tasa_real_def(j,2) = tasa_real(j-1,2) * k;
    end   
      
  for ii=1:N_iny
       jjj=0;
    for jj=k1(ii):k2(ii)+1
        if tasa_real_def(jj,2)>0
           tasa_real_desf_evap(i_inicio(ii)+jjj,2)=tasa_real_def(jj,2);
           jjj=jjj+1;
        end
    end
    comp=i_inicio(ii)+jjj;
  end
     
  for comp=j:NPC
     tasa_real_desf_evap(comp,2)=0;
  end
  for ang=1:NPC
     tasa_real_desf_evap(ang,1)=injection_rate(ang,1);
  end
  mass_ev=tasa_real_desf_evap;
end
