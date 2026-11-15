%% MATCALMEC Graphic V1.1%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
% This script plot the data obtained with CALMEC_CHARAC_V4_1 in the same
% run of the program
%% Data Load
for i =1:num_tests
    
    %     display(files((2*k)+1).name)
    A = importdata([DAT 'Initial_' cell2mat(test_name(i)) '.dat']);
    B = importdata([DAT 'Adjusted_' cell2mat(test_name(i)) '.dat']);
    n = length(A)-2;
%     % Plot dFQL
    NAME = strrep(test_name(i),'_','-');
%     figure
%     hold on
%     title ([char(NAME) ' \epsilon_{RoHR}'])
%     xlabel('CAD')
%     ylabel('J/D')
%     plot(A(1:n,1),A(1:n,15),'-k')
%     plot(B(1:n,1),B(1:n,15),'-r')
%     legend('Initial','Adjusted')
%     hold off
%     % Plot real and simulated pressure
%     figure
%     hold on
%     title ([char(NAME) ' \epsilon_p'])
%     xlabel('CAD')
%     ylabel('bar')
%     plot(A(1:n,1),A(1:n,31),'-k')
%     plot(B(1:n,1),B(1:n,31),'-r')
%     legend('Initial','Adjusted')
%     hold off
    % Plot heat transfer
    figure
    hold on
    title ([char(NAME) ' Adjusted Heat transfer'])
    xlabel('CAD')
    ylabel('bar')
    plot(B(1:n,1),B(1:n,23),'-k')
    plot(B(1:n,1),B(1:n,16),'-r')
    legend('Qn','Qw')
    hold off
    
    clear('NAME')
end





