%% MATCALMEC Graphic V1.1%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% close all
clc
set(0,'DefaultFigureWindowStyle','docked')
% This script plot the data obtained with CALMEC_CHARAC_V4_1 in the same
% run of the program
%% Data Load

Engine_Name = 'Powerful';
file = [Engine_Name '.xlsx'];
conf_file = ['Configuration\' file];
Identifier = 'PAD4';
Ident = Identifier;
dFQL = 'n';
errp = 'n';
Q = 'y';

for Current_Cyl = 1 : 1
    cil = ['cil' num2str(Current_Cyl)];
    DAT = ['Save_Data\DAT\' Engine_Name '\' Identifier '\'];
    Engine = engine_conf(conf_file);
    [~,Imposed,cylinder,PolyEx,Identifier] = charac_conf(conf_file,Current_Cyl,Ident);
    [v,test_name,num_tests] = test_load(conf_file,Imposed,cylinder.cil,Engine.Type);
    for i =1:num_tests
        %     display(files((2*k)+1).name)
        A = importdata([DAT 'Initial_' cell2mat(test_name(i)) '.dat']);
        B = importdata([DAT 'Adjusted_' cell2mat(test_name(i)) '.dat']);
        n = length(A)-2;
        % Plot dFQL
        title_text = cell2mat(test_name(i));
        title_text = strrep(title_text, '_', '-');
        if strcmp(dFQL,'y')
        figure
        hold on
        title ({'dFQL' title_text})
        xlabel('CAD')
        ylabel('J/D')
        plot(A(1:n,1),A(1:n,15),'-k')
        plot(B(1:n,1),B(1:n,15),'-r')
        legend('Initial','Adjusted')
        hold off
        end
        if strcmp(errp,'y')
        % Plot real and simulated pressure
        figure
        hold on
        title ({'Simulated - Real Pressure' title_text})
        xlabel('CAD')
        ylabel('bar')
        plot(A(1:n,1),A(1:n,31),'-k')
        plot(B(1:n,1),B(1:n,31),'-r')
        legend('Initial','Adjusted')
        hold off
        end
        % Plot heat transfer
        if strcmp(Q,'y')
        figure
        hold on
        title ({' Adjusted Heat transfer' title_text})
        xlabel('CAD')
        ylabel('bar')
        plot(B(1:n,1),B(1:n,23),'-k')
        plot(B(1:n,1),B(1:n,16),'-r')
        legend('Qn','Qw')
        hold off
        end
    end
    
end



