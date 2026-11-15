function [ C,D ] = read_data( path )


[A,delimiterOut]=importdata([path 'injection_rate.dat']);
[B,delimiterOut]=importdata([path 'injection_rate_parameters.dat']);
C = A.data;
D = B.data;

end