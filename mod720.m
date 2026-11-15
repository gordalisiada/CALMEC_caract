function angle=mod720(desfase,CGradosCiclo)
if and(desfase>=-(CGradosCiclo / 2),desfase < (CGradosCiclo / 2));
    angle=desfase;  
end
if desfase >= CGradosCiclo / 2;
    angle = desfase - CGradosCiclo;
end
if desfase < -(CGradosCiclo / 2);
    angle = desfase + CGradosCiclo;
end
end


