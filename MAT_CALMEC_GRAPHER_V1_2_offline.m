%% MATCALMEC Graphic V1.2_off line%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
% This script plot the data obtained with CALMEC_CHARAC_V4_1 in the same
% run of the program
%% Data Load
% Introduce the name of the xlsx and instantaneous folder where the 
% configuration and the pressure signals are
Engine_Name = 'DV6C_Balances_SOI';
% Introduce the name to the saved data, if you don't change the name the
% previous file will be replaced
Identifier = 'CHARAC';
% Initialize
keep_graph = 'y';
%% Paths

% Load the CONFIGURATION. xlsx file with the required information
file = [Engine_Name '.xlsx'];
conf_file = ['Configuration\' file];
inst_signals_path = ['Instantaneous\' Engine_Name '\'];
saved_path = 'Save_Data\';

% If policylinder execution, Ident is the name of the test
Ident = Identifier;

while strcmp(keep_graph,'y')
    % Load test data
    Current_Cyl = input('Input the cylinder number to graph [1 to 4]:', 's');
    [Adjustment,Imposed,cylinder,PolyEx,Identifier] = charac_conf(conf_file,str2num(Current_Cyl),Ident);
    [v,test_name,num_tests] = test_vd(conf_file,Imposed,cylinder.cil);

    DAT = ['Save_Data\DAT\' Engine_Name '\' Ident '_cil' Current_Cyl '\'];
    for i =1:num_tests
        %     display(files((2*k)+1).name)
        A = importdata([DAT 'Initial_' cell2mat(test_name(i)) '.dat']);
        B = importdata([DAT 'Adjusted_' cell2mat(test_name(i)) '.dat']);
        n = length(A)-2;
        % Plot dFQL
        NAME = strrep(test_name(i),'_','-');
        figure
        hold on
        title ([char(NAME) ' \epsilon_{RoHR}' ' cil' Current_Cyl])
        xlabel('CAD')
        ylabel('J/D')
        plot(A(1:n,1),A(1:n,15),'-k')
        plot(B(1:n,1),B(1:n,15),'-r')
        legend('Initial','Adjusted')
        hold off
        % Plot real and simulated pressure
        figure
        hold on
        title ([char(NAME) ' \epsilon_p' ' cil' Current_Cyl])
        xlabel('CAD')
        ylabel('bar')
        plot(A(1:n,1),A(1:n,31),'-k')
        plot(B(1:n,1),B(1:n,31),'-r')
        legend('Initial','Adjusted')
        hold off
        
        clear('NAME')
    end
    
    keep_graph = input('Do you want to graph other cylinder? yes[y]/no[n]:', 's');
    if strcmp(keep_graph,'y')
        close all
    else
        End = ['Screen results of cil ' Current_Cyl] 
    end
    
    clear Graph_cil
end




