% Script - Dec 23
% Move and rename specified files from separate folder to the Event folder

pattern_csv = 'Ripples-Abs-All.csv';
channel_noise = '000';

labels_S = {'recording','channel_pyr','channel_dg'};    
S = [{'20190225_SD025_P103_R_nlab','023','016'};
    {'20190225_SD025_P201_R_nlab','023','016'};
    {'20190225_SD025_P202_R_nlab','023','016'};
    {'20190226_SD025_P101_R_nlab','023','016'};
    {'20190226_SD025_P102_R_nlab','023','016'};
    {'20190226_SD025_P201_R_nlab','023','016'};
    {'20190226_SD025_P202_R_nlab','023','016'};
    {'20190226_SD025_P301_R_nlab','023','016'};
    {'20190226_SD025_P302_R_nlab','023','016'};
    {'20190226_SD025_P401_R_nlab','023','016'};
    {'20190226_SD025_P402_R_nlab','023','016'};
    {'20190227_SD025_P101_R_nlab','023','016'};
    {'20190227_SD025_P102_R_nlab','023','016'};
    {'20190227_SD025_P201_R_nlab','023','016'};
    {'20190227_SD025_P202_R_nlab','023','016'};
    {'20190227_SD025_P301_R_nlab','023','016'};
    {'20190227_SD025_P302_R_nlab','023','016'};
    {'20190227_SD025_P401_R_nlab','023','016'};
    {'20190227_SD025_P402_R_nlab','023','016'};
    {'20190227_SD025_P501_R_nlab','023','016'};
    {'20190227_SD025_P502_R_nlab','023','016'};
    {'20190228_SD025_P101_R_nlab','023','016'};
    {'20190228_SD025_P102_R_nlab','023','016'};
    {'20190228_SD025_P103_R_nlab','023','016'};
    {'20190304_SD025_P101_R_nlab','023','016'};
    {'20190304_SD025_P201_R_nlab','023','016'};
    {'20190304_SD025_P301_R_nlab','023','016'};
    {'20190305_SD025_P101_R_nlab','023','016'};
    {'20190305_SD025_P201_R_nlab','023','016'};
    {'20190305_SD025_P301_R_nlab','023','016'};
    {'20190305_SD025_P401_R_nlab','023','016'};
    {'20190306_SD025_P101_R_nlab','023','016'};
    {'20190306_SD025_P102_R_nlab','023','016'};
    {'20190306_SD025_P301_R_nlab','023','016'};
    {'20190306_SD025_P401_R_nlab','023','016'};
    {'20190415_SD032_P101_R_nlab','005','015'};
    {'20190415_SD032_P102_R_nlab','005','015'};
    {'20190415_SD032_P103_R_nlab','005','015'};
    {'20190415_SD032_P104_R_nlab','005','015'};
    {'20190415_SD032_P201_R_nlab','005','015'};
    {'20190415_SD032_P202_R_nlab','005','015'};
    {'20190415_SD032_P301_R_nlab','005','015'};
    {'20190415_SD032_P302_R_nlab','005','015'};
    {'20190416_SD032_P101_R_nlab','005','015'};
    {'20190416_SD032_P102_R_nlab','005','015'};
    {'20190416_SD032_P103_R_nlab','005','015'};
    {'20190416_SD032_P201_R_nlab','005','015'};
    {'20190416_SD032_P202_R_nlab','005','015'};
    {'20190416_SD032_P203_R_nlab','005','015'};
    {'20190416_SD032_P301_R_nlab','005','015'};
    {'20190416_SD032_P302_R_nlab','005','015'};
    {'20190416_SD032_P303_R_nlab','005','015'};
    {'20190416_SD032_P401_R_nlab','005','015'};
    {'20190416_SD032_P402_R_nlab','005','015'};
    {'20190417_SD032_P101_R_nlab','005','015'};
    {'20190417_SD032_P102_R_nlab','005','015'};
    {'20190417_SD032_P103_R_nlab','005','015'};
    {'20190417_SD032_P201_R_nlab','005','015'};
    {'20190417_SD032_P202_R_nlab','005','015'};
    {'20190417_SD032_P203_R_nlab','005','015'};
    {'20190417_SD032_P301_R_nlab','005','015'};
    {'20190417_SD032_P302_R_nlab','005','015'};
    {'20190417_SD032_P303_R_nlab','005','015'};
    {'20190417_SD032_P401_R_nlab','005','015'};
    {'20190417_SD032_P402_R_nlab','005','015'};
    {'20190417_SD032_P403_R_nlab','005','015'};
    {'20190418_SD032_P101_R_nlab','005','015'};
    {'20190418_SD032_P102_R_nlab','005','015'};
    {'20190418_SD032_P103_R_nlab','005','015'};
    {'20190418_SD032_P201_R_nlab','005','015'};
    {'20190418_SD032_P202_R_nlab','005','015'};
    {'20190418_SD032_P203_R_nlab','005','015'}];

S = [{'20201019_SD092_P102_R_nlab','013','006'};
    {'20201019_SD092_P103_R_nlab','013','006'};
    {'20201020_SD092_P104_R_nlab','013','006'};
    {'20201020_SD092_P105_R_nlab','013','006'};
    {'20201020_SD092_P106_R_nlab','013','006'};
    {'20201020_SD092_P110_R_nlab','013','006'};
    {'20201020_SD092_P111_R_nlab','013','006'};
    {'20201020_SD092_P112_R_nlab','013','006'};
    {'20201022_SD092_P101_R_nlab','013','006'};
    {'20201022_SD092_P102_R_nlab','013','006'};
    {'20201022_SD092_P103_R_nlab','013','006'};
    {'20201022_SD092_P107_R_nlab','013','006'};
    {'20201022_SD092_P108_R_nlab','013','006'};
    {'20201022_SD092_P109_R_nlab','013','006'};
    {'20201023_SD092_P102_R_nlab','013','006'};
    {'20201023_SD092_P104_R_nlab','013','006'};
    {'20201024_SD092_P101_R_nlab','013','006'};
    {'20201024_SD092_P103_R_nlab','013','006'};
    {'20201024_SD092_P105_R_nlab','013','006'};
    {'20201025_SD093_P101_R_nlab','005','017'};
    {'20201025_SD093_P103_R_nlab','005','017'};
    {'20201026_SD092_P102_R_nlab','013','006'};
    {'20201026_SD092_P104_R_nlab','013','006'};
    {'20201027_SD092_P101_R_nlab','013','006'};
    {'20201027_SD092_P103_R_nlab','013','006'};
    {'20201028_SD093_P102_R_nlab','005','017'};
    {'20201028_SD093_P104_R_nlab','005','017'};
    {'20201029_SD093_P101_R_nlab','005','017'};
    {'20201029_SD093_P103_R_nlab','005','017'};
    {'20201030_SD093_P102_R_nlab','005','017'};
    {'20201030_SD093_P104_R_nlab','005','017'};
    {'20201207_SD113_P101_R_nlab','009','027'};
    {'20201207_SD113_P103_R_nlab','009','027'};
    {'20201208_SD113_P102_R_nlab','009','027'};
    {'20201208_SD113_P104_R_nlab','009','027'};
    {'20201209_SD113_P101_R_nlab','009','027'};
    {'20201209_SD113_P103_R_nlab','009','027'};
    {'20201210_SD113_P102_R_nlab','009','027'};
    {'20201210_SD113_P104_R_nlab','009','027'};
    {'20201211_SD111_P102_R_nlab','021','013'};
    {'20201211_SD111_P104_R_nlab','021','013'};
    {'20201212_SD111_P101_R_nlab','021','013'};
    {'20201212_SD111_P103_R_nlab','021','013'};
    {'20201213_SD111_P102_R_nlab','021','013'};
    {'20201213_SD111_P104_R_nlab','021','013'};
    {'20201214_SD111_P101_R_nlab','021','013'};
    {'20201214_SD111_P103_R_nlab','021','013'};
    {'20201215_SD111_P102_R_nlab','021','013'};
    {'20201215_SD111_P104_R_nlab','021','013'};
    {'20201216_SD113_P102_R_nlab','009','027'};
    {'20201216_SD113_P104_R_nlab','009','027'};
    {'20201217_SD113_P101_R_nlab','009','027'};
    {'20201217_SD113_P103_R_nlab','009','027'};
    {'20201218_SD111_P101_R_nlab','021','013'};
    {'20201218_SD111_P103_R_nlab','021','013'};
    {'20210119_SD123_P102_R_nlab','021','009'};
    {'20210120_SD121_P102_R_nlab','013','021'};
    {'20210120_SD121_P104_R_nlab','013','021'};
    {'20210121_SD121_P101_R_nlab','013','021'};
    {'20210121_SD121_P103_R_nlab','013','021'};
    {'20210122_SD121_P102_R_nlab','013','021'};
    {'20210122_SD121_P104_R_nlab','013','021'};
    {'20210123_SD123_P101_R_nlab','021','009'};
    {'20210124_SD122_P102_R_nlab','025','013'};
    {'20210124_SD122_P104_R_nlab','025','013'};
    {'20210125_SD121_P101_R_nlab','013','021'};
    {'20210125_SD121_P103_R_nlab','013','021'};
    {'20210125_SD121_P105_R_nlab','013','021'};
    {'20210126_SD121_P102_R_nlab','013','021'};
    {'20210126_SD121_P104_R_nlab','013','021'};
    {'20210128_SD121_P101_R_nlab','013','021'};
    {'20210128_SD121_P103_R_nlab','013','021'};
    {'20210128_SD121_P105_R_nlab','013','021'};
    {'20210129_SD122_P101_R_nlab','025','013'};
    {'20210129_SD122_P103_R_nlab','025','013'};
    {'20210129_SD122_P106_R_nlab','025','013'};
    {'20210208_SD132_P102_R_nlab','025','023'};
    {'20210208_SD132_P104_R_nlab','025','023'};
    {'20210209_SD131_P101_R_nlab','013','021'};
    {'20210209_SD131_P103_R_nlab','013','021'};
    {'20210209_SD132_P101_R_nlab','025','023'};
    {'20210209_SD132_P103_R_nlab','025','023'};
    {'20210210_SD131_P101_R_nlab','013','021'};
    {'20210210_SD131_P103_R_nlab','013','021'};
    {'20210210_SD132_P102_R_nlab','025','023'};
    {'20210210_SD132_P104_R_nlab','025','023'};
    {'20210211_SD131_P101_R_nlab','013','021'};
    {'20210211_SD131_P103_R_nlab','013','021'};
    {'20210212_SD131_P101_R_nlab','013','021'};
    {'20210212_SD131_P103_R_nlab','013','021'};
    {'20210212_SD132_P101_R_nlab','025','023'};
    {'20210212_SD132_P103_R_nlab','025','023'};
    {'20210214_SD131_P102_R_nlab','013','021'};
    {'20210214_SD131_P104_R_nlab','013','021'};
    {'20210214_SD132_P102_R_nlab','025','023'};
    {'20210214_SD132_P104_R_nlab','025','023'};
    {'20210215_SD131_P101_R_nlab','013','021'};
    {'20210215_SD131_P103_R_nlab','013','021'};
    {'20210215_SD132_P102_R_nlab','025','023'};
    {'20210215_SD132_P104_R_nlab','025','023'};
    {'20210216_SD131_P104_R_nlab','013','021'};
    {'20210216_SD132_P102_R_nlab','025','023'};
    {'20210216_SD132_P104_R_nlab','025','023'};
    {'20210217_SD131_P102_R_nlab','013','021'};
    {'20210217_SD131_P104_R_nlab','013','021'};
    {'20210218_SD131_P101_R_nlab','013','021'};
    {'20210218_SD131_P103_R_nlab','013','021'};
    {'20210218_SD132_P101_R_nlab','025','023'};
    {'20210218_SD132_P103_R_nlab','025','023'};
    {'20210219_SD132_P101_R_nlab','025','023'};
    {'20210220_SD132_P101_R_nlab','025','023'};
    {'20210220_SD132_P103_R_nlab','025','023'};
    {'20210222_SD132_P102_R_nlab','025','023'};
    {'20210222_SD132_P104_R_nlab','025','023'};
    {'20210223_SD132_P102_R_nlab','025','023'};
    {'20210223_SD132_P104_R_nlab','025','023'};
    {'20210224_SD132_P104_R_nlab','025','023'};];

global DIR_SAVE;
for i=1:size(S,1)
    cur_recording = S{i,1};
    channel_rip = S{i,2};
    pattern_csv_out = '[Pyr]Ripples-Abs-All.csv';
    str_csv = sprintf('[%s-%s]%s',channel_rip,channel_noise,pattern_csv);
    d_csv = dir(fullfile(DIR_SAVE,cur_recording,'Events',channel_rip,strcat('*',str_csv,'*')));
    if length(d_csv)==1
        copyfile(fullfile(d_csv.folder,d_csv.name),fullfile(DIR_SAVE,cur_recording,'Events',pattern_csv_out));
        fprintf('[%s]--->[%s].\n',d_csv.name,fullfile(DIR_SAVE,cur_recording,'Events',pattern_csv_out));
    end
    
    channel_dg = S{i,3};
    pattern_csv_out = '[Gyr]Ripples-Abs-All.csv';
    str_csv = sprintf('[%s-%s]%s',channel_dg,channel_noise,pattern_csv);
    d_csv = dir(fullfile(DIR_SAVE,cur_recording,'Events',channel_dg,strcat('*',str_csv,'*')));
    if length(d_csv)==1
        copyfile(fullfile(d_csv.folder,d_csv.name),fullfile(DIR_SAVE,cur_recording,'Events',pattern_csv_out));
        fprintf('[%s]--->[%s].\n',d_csv.name,fullfile(DIR_SAVE,cur_recording,'Events',pattern_csv_out));
    end
end

% Uncomment if needed
% Clean Events folder
global DIR_SAVE;
pattern_clean = {'Ripples-Abs-All.csv';'Ripples-Merged-All.csv';'Ripples-Sqrt-All.csv'};
for i = 1:length(pattern_clean)
    cur_clean = char(pattern_clean{i});
    d_clean = dir(fullfile(DIR_SAVE,'*','Events',cur_clean));
    for j = 1:length(d_clean)
        delete(fullfile(d_clean(j).folder,d_clean(j).name));
        fprintf('File deleted [%s].\n',fullfile(d_clean(j).folder,d_clean(j).name));
    end
end

% Uncomment if needed
% % Modifies event files name
% global DIR_SAVE;
% d_csv = dir(fullfile(DIR_SAVE,'*','Events','*','*.csv'));
% 
% for i=1:length(d_csv)
%     old_csv = char(d_csv(i).name);
%     new_csv = strrep(old_csv,']Ripples','-000]Ripples');
%     movefile(fullfile(d_csv(i).folder,old_csv),fullfile(d_csv(i).folder,new_csv));
%     fprintf('%d/%d.\n',i,length(d_csv));
% end
