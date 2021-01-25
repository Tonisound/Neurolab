% Correlation movies
% folder_in = 'I:\NEUROLAB\NLab_Figures\fUS_Correlation\2020*\STABLE\Ref-SPEED\*.mp4';
% folder_out = 'C:\Users\Antoine\Desktop\fUS_Correlation\STABLE';

% PeriEvent Regression
% folder_in = 'I:\NEUROLAB\NLab_Figures\fUS_PeriEventHistogram\*\RUN\2015*Regression*';
% folder_out = 'C:\Users\Antoine\Desktop\fUS_PeriEvent\Regression2';

% % PeriEvent Peak-to-Peak
% folder_in = 'I:\NEUROLAB\NLab_Figures\fUS_PeriEventHistogram\*\RUN\2015*Peak-to-Peak*';
% folder_out = 'C:\Users\Antoine\Desktop\fUS_PeriEvent\Peak-to-Peak2';

% % Atlas
% folder_in = 'D:\NEUROLAB\NLab_DATA\*\Atlas.mat';
% folder_out = 'C:\Users\Antoine\Desktop\Atlas';

% % fUS_Correlation
% folder_in = 'I:\NEUROLAB\NLab_Figures\Cross_Correlation\2020*\*fUS-Synthesis_STABLE*';
% folder_out = 'C:\Users\Antoine\Desktop\Cross_Correlation';

% fUS_Episode_Statistics
folder_in = 'F:\SHARED_DATASET\NEUROLAB\NLab_Figures\fUS_Statistics\*\*fUS_Statistics_Groups_BoxPlot.jpg';
folder_out = 'C:\Users\Antoine\Desktop\fUS_Statistics';

d = dir(folder_in);
for i=1:length(d)
    %temp = regexp(d(i).folder,filesep,'split');
    %fname = strcat(char(temp(end)),'.mat');
    %copyfile(fullfile(d(i).folder,d(i).name),fullfile(folder_out,fname));
    copyfile(fullfile(d(i).folder,d(i).name),fullfile(folder_out,d(i).name));
    fprintf('File [%s] => [%s].\n',char(d(i).name),folder_out);
end

% Time_Reference.mat
folder_in = 'F:\BACKUP_ToniHD2\NEUROLAB\NLab_DATA\';
folder_out = 'C:\Users\Antoine\Desktop\Time_Reference';
d = dir(folder_in);
for i=1:length(FILES)
    %temp = regexp(d(i).folder,filesep,'split');
    %fname = strcat(char(temp(end)),'.mat');
    %copyfile(fullfile(d(i).folder,d(i).name),fullfile(folder_out,fname));
    copyfile(fullfile(folder_in,FILES(i).nlab,'Time_Reference.mat'),fullfile(folder_out,strcat(strrep(FILES(i).nlab,'_nlab','-'),'Time_Reference.mat')));
    fprintf('File [%s] => [%s].\n',fullfile(folder_in,FILES(i).nlab,'Time_Reference.mat'),fullfile(folder_out,strcat(FILES(i).nlab,'Time_Reference.mat')));
end