function [ C,D ] = read_data( path )

oldfolder = cd();

cd(path)

[A,delimiterOut]=importdata('injection_rate.dat');
[B,delimiterOut]=importdata('injection_rate_parameters.dat');
C=A.data;
D=B.data;
cd(oldfolder )

end