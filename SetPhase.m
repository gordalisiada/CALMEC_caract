% In this scripst, the files results from CALMEC are setted in the
% same first angle.

clear all
close all
clc

path = 'Instantaneous_CALMEC\';
mkdir('Instantaneous')
save_path = 'Instantaneous\';
ang0 = -116.94;
angf = 242.81;
step = 0.25;
npp = 1440;
npc = 180;

Archivos = dir(path);
Archivos (1:2) = [];
%% Mallll
for i = 1 : length(Archivos)
    A = importdata([path Archivos(i,1).name]);
    B = zeros(npp,2);
    B(1:npc,:) = A(npp-npc+1:npp,:);
    B(npc+1:npp,:) = A(1:npp-npc,:);
    pressure(:,1) = [ang0-npc*step : step : angf-npc*step];
    pressure(:,2) = B(:,2);
%     if i == 7
%         figure
%         hold on
%         plot(pressure(:,1),pressure(:,2),'r')
%         plot(A(:,1),A(:,2),'k')
%         title(Archivos(i,1).name);
%     end
    
    save([save_path Archivos(i,1).name],'pressure','-ASCII');
end

