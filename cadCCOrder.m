function [ CC ] = cadCCOrder(CGradosCiclo,intang, CC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pos0 = 0;
existeAngMinus360 = 0;
existeAngPlus360 = 0;
existeAng720 = 0;
anguloInicio = 0;% // No hay que cambiar


%hay que rellenar primero a CC




vectorAngulosAux = CC(:,1);

NPC = length(CC(:,1));

vectorAngulos = zeros(NPC,1);

vectorTemperaturas= zeros(NPC,1);
vectorYa= zeros(NPC,1);
vectorYf= zeros(NPC,1);
vectorYq= zeros(NPC,1);





for i=1:NPC
    if i == 1
        
        if vectorAngulosAux(i) == (-CGradosCiclo / 2 )
            pos0 = 1;
            existeAngMinus360 = 1;
            	break;
            
        end
    end
    
    if i > 1
        
        if vectorAngulosAux(i) >= -CGradosCiclo / 2 && vectorAngulosAux(i) < -CGradosCiclo / 2 + intang - 0.0001
            pos0 = i ;
            existeAngMinus360 = 1;
            	break;
            
        end
    end
    
end
for i=1:NPC
    if i == 1
        
        if vectorAngulosAux(i) == CGradosCiclo / 2
            pos0 = 1;
            existeAngPlus360 = 1;
            	break;
            
        end
    end
    
    if i > 1
        
        if vectorAngulosAux(i) >= CGradosCiclo / 2 && vectorAngulosAux(i) < CGradosCiclo / 2 + intang - 0.0001
            pos0 = i;
            existeAngPlus360 = 1;
            	break;
            
        end
    end
    
end
for i=1:NPC
    if i == 1
        
        if vectorAngulosAux(i) == CGradosCiclo 
          
            existeAng720 = 1;
            	break;
            
        end
    end
    
    if i > 1
        
        if vectorAngulosAux(i) >= CGradosCiclo  && vectorAngulosAux(i) < CGradosCiclo  + intang - 0.0001
         
            existeAng720 = 1;
            	break;
            
        end
    end
    
end

if existeAngMinus360 == 1

        anguloInicio = 1;

    elseif existeAngPlus360 == 1

        anguloInicio = 2;

    elseif existeAng720 == 1

        anguloInicio = 3;

    else
        anguloInicio = 0;

end

switch(anguloInicio)
    
    case 1
        
      if pos0 == 1
          
         for i=1:pos0
             
              vectorAngulos(i) = CC(i,1);
        
          vectorTemperaturas(i) = CC(i,2);
          vectorYa(i) = CC(i,3);
          vectorYf(i) = CC(i,4);
          vectorYq(i) = CC(i,5);
                   
         end
         
      else
          
         for i=pos0+1:NPC
             
          vectorAngulos(i-pos0) = CC(i,1);
        
          vectorTemperaturas(i-pos0) = CC(i,2);
          vectorYa(i-pos0) = CC(i,3);
          vectorYf(i-pos0) = CC(i,4);
          vectorYq(i-pos0) = CC(i,5);
             
             
         end
      
         for i=1:pos0
             
         vectorAngulos(NPC - pos0 + i) = CGradosCiclo + (CC(i,1));
         
          vectorTemperaturas(NPC - pos0 + i) = CC(i,2);
          vectorYa(NPC - pos0 + i) = CC(i,3);
          vectorYf(NPC - pos0 + i) = CC(i,4);
          vectorYq(NPC - pos0 + i) = CC(i,5);
             
             
         end
         
      end
      
   
        
    case 2
        
      pos1 = 1;
      
      for i=1:NPC
          
         if vectorAngulosAux(i) >= CGradosCiclo / 2 && vectorAngulosAux(i) < CGradosCiclo / 2 + intang - 0.0001 
          
             pos1 = i -1;
            break; 
         end
          
          
      end
        
      for i=pos1+1:NPC
          
       if fabs(vectorAngulosAux(i)) > CGradosCiclo / 2
           
         vectorAngulos(i-pos1) = CC(i:1) - CGradosCiclo; 
           
       else
           
          vectorAngulos(i-pos1) = CC(i:1); 
           
       end
       
       
          vectorTemperaturas(i-pos1) = CC(i,2);
          vectorYa(i-pos1) = CC(i,3);
          vectorYf(i-pos1) = CC(i,4);
          vectorYq(i-pos1) = CC(i,5);
          
          
      end
      
       for i=1:pos1
             vectorAngulos(NPC - pos1 + i) = CC(i,1);
         
          vectorTemperaturas(NPC - pos1 + i) = CC(i,2);
          vectorYa(NPC - pos1 + i) = CC(i,3);
          vectorYf(NPC - pos1 + i) = CC(i,4);
          vectorYq(NPC - pos1 + i) = CC(i,5);
           
           
       end
      

        
    case 3
        
         pos2 = 1;
      
      for i=1:NPC
          
         if vectorAngulosAux(i) >= CGradosCiclo && vectorAngulosAux(i) < CGradosCiclo  + intang - 0.0001 
          
             pos2 = i -1;
            break; 
         end
          
          
      end
        
     for i=pos2+1:NPC
          
       if fabs(vectorAngulosAux(i)) > CGradosCiclo * 2
           
         vectorAngulos(i-pos2) = CC(i:1) - CGradosCiclo * 2; 
           
       else
           
          vectorAngulos(i-pos2) = CC(i:1)- CGradosCiclo; 
           
       end
       
       
          vectorTemperaturas(i-pos2) = CC(i,2);
          vectorYa(i-pos2) = CC(i,3);
          vectorYf(i-pos2) = CC(i,4);
          vectorYq(i-pos2) = CC(i,5);
          
          
      end
      
       for i=1:pos2
             vectorAngulos(NPC - pos2 + i) = CC(i,1);
    
          vectorTemperaturas(NPC - pos2 + i) = CC(i,2);
          vectorYa(NPC - pos2 + i) = CC(i,3);
          vectorYf(NPC - pos2 + i) = CC(i,4);
          vectorYq(NPC - pos2 + i) = CC(i,5);
           
           
       end
        

		
        
    otherwise
        
        for i=1:NPC;

          vectorAngulos(i) = CC(i,1);
         
          vectorTemperaturas(i) = CC(i,2);
          vectorYa(i) = CC(i,3);
          vectorYf(i) = CC(i,4);
          vectorYq(i) = CC(i,5);



        end
        
   
   
end

    

CC(:,1) = vectorAngulos(:,1);
CC(:,2) = vectorTemperaturas(:,1);
CC(:,3) = vectorYa(:,1);
CC(:,4) = vectorYf(:,1);
CC(:,5) = vectorYq(:,1);



end

