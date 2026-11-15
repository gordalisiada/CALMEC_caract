function result = set_angle(npc,CGradosCiclo,phase,signal)
%% Create the right angular reference

Angle = signal(:,1)-360;
n = 0;

for i = 1:length(Angle)
    if Angle(i) >= phase+360
        n = n+1;
        if n == 1
            m = i;
        end
    end
end


result(:,1) = linspace(phase,phase+CGradosCiclo,npc);
result(1:npc-m+1,2) = signal(m:npc,2); 
result(npc-m+2:npc,2) = signal(1:m-1,2);
end