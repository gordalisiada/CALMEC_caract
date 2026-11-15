function [ status ] = Ejecuta_Tasa( path )
%Ejecuta_Tasa Select the path to execute Tasa
%   Change the folder to where the files are and then run TASA.exe, returns 
% the injection parameters to symulate the instantaneous injection rate

% Save the main path
oldfolder = cd();
% Change to the path where the inputs files are
cd(path)
% Run TASA.exe
status_exe = system('TASA.exe');
% Informs if TASA.exe runs correctly
if status_exe == 0
    status = 'Ok';
else
    status = 'Error';
end
% Returns to main path
cd(oldfolder )

end

