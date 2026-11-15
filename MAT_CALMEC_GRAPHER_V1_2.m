%% MATCALMEC Graphic V1.1%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
% This script plot the data obtained with CALMEC_CHARAC_V4_1 in the same
% run of the program
%% Data Load
keep_graph = 'y';
while strcmp(keep_graph,'y')
    
    Graph_cil = input('Input the cylinder number to graph [1 to 4]:', 's');
    % cilnum = str2num(Graph_cil);
    DAT = ['Save_Data\DAT\' Engine_Name '\' Ident '_cil' Graph_cil '\'];
    for i =1:num_tests
        %     display(files((2*k)+1).name)
        A = importdata([DAT 'Initial_' cell2mat(test_name(i)) '.dat']);
        B = importdata([DAT 'Adjusted_' cell2mat(test_name(i)) '.dat']);
        n = length(A)-2;
        % Plot dFQL
        NAME = strrep(test_name(i),'_','-');
        figure
        hold on
        title ([char(NAME) ' \epsilon_{RoHR}' ' cil' Graph_cil])
        xlabel('CAD')
        ylabel('J/D')
        plot(A(1:n,1),A(1:n,15),'-k')
        plot(B(1:n,1),B(1:n,15),'-r')
        legend('Initial','Adjusted')
        hold off
        % Plot real and simulated pressure
        figure
        hold on
        title ([char(NAME) ' \epsilon_p' ' cil' Graph_cil])
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
        End = ['Screen results of cil ' Graph_cil] 
    end
    
    clear Graph_cil
end




