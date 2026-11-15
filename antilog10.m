function antilog=antilog10(x)
   ln10=2.302585093;
   serie=0;
   i=1;
   for i=1:1:50
      serie=serie+(((ln10^i)/factorial(i))*(x^i));
   end
   antilog=1+serie;