function [phase]= Set_Phase(Adjustment)
% Set the phase in the correct value (pre=presionr(i,2), aprox line 207, if
% this correction is not carried on, the npc will be bigger than 3600

if Adjustment.desfasetot <=180
   phase = Adjustment.desfasetot+180;
else
    phase = Adjustment.desfasetot;
end