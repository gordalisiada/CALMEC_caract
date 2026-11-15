function [ presionr ] = cadPresOrder(NPC,CGradosCiclo,intang, presionr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pos0 = 0;
existeAngMinus360 = 0;
existeAngPlus360 = 0;
existeAng720 = 0;
anguloInicio = 0;% // No hay que cambiar
vectorAngulosAux = presionr(:,1);




vectorAngulos = zeros(NPC,1);
vectorPresiones  = zeros(NPC,1);






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
            pos0 = i;
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
            pos0 = i ;
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
             
              vectorAngulos(i) = presionr(i,1);
          vectorPresiones(i) = presionr(i,2);
        
                   
         end
         
      else
          
         for i=pos0+1:NPC
             
          vectorAngulos(i-pos0) = presionr(i,1);
          vectorPresiones(i-pos0) = presionr(i,2);
       
             
             
         end
      
         for i=1:pos0
             
          vectorAngulos(NPC - pos0 + i) = CGradosCiclo + (presionr(i,1));
          vectorPresiones(NPC - pos0 + i) = presionr(i,2);
       
             
             
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
           
         vectorAngulos(i-pos1) = presionr(i:1) - CGradosCiclo; 
           
       else
           
          vectorAngulos(i-pos1) = presionr(i:1); 
           
       end
       
        vectorPresiones(i-pos1) = presionr(i,2);
       
          
          
      end
      
       for i=1:pos1
             vectorAngulos(NPC - pos1 + i) = presionr(i,1);
          vectorPresiones(NPC - pos1 + i) = presionr(i,2);
        
           
           
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
           
         vectorAngulos(i-pos2) = presionr(i:1) - CGradosCiclo * 2; 
           
       else
           
          vectorAngulos(i-pos2) = presionr(i:1)- CGradosCiclo; 
           
       end
       
        vectorPresiones(i-pos2) = presionr(i,2);
       
          
      end
      
       for i=1:pos2
             vectorAngulos(NPC - pos2 + i) = presionr(i,1);
          vectorPresiones(NPC - pos2 + i) = presionr(i,2);
      
           
           
       end
        

		
        
    otherwise
        
        for i=1:NPC;

          vectorAngulos(i) = presionr(i,1);
          vectorPresiones(i) = presionr(i,2);
        



        end
        
   
   
end

    
presionr(:,1) = vectorAngulos;
presionr(:,2) = vectorPresiones;




end

