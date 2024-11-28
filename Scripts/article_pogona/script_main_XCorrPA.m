function script_main_XCorrPA(flag_recompute,flag_savefig,flag_perstate)
% Script written by AB
% Article Pogona
% November 2024
% Browses NLab files
% Computes dynamics XCorr and AutoCorr for LFP channels and fUS regions
% Plots dynamics XCorr and AutoCorr
% Plots mean XCorr and AutoCorr per state

if nargin<1
    flag_recompute = true;     % if True (re)computes dynamic xcorr
end
if nargin<2
    flag_savefig = true;       % if True plots and saves dynamic xcorr
end
if nargin<3
    flag_perstate = true;      % if True (re)computes xcorr per state
end

load('Preferences.mat','GColors');

InfoFilePogo =[{'20190730_P1-003_E_nlab'},{'Power-beta_DVR2'},{'Power-theta_DVR2'};...
    {'20190730_P1-004_E_nlab'},{'Power-beta_DVR2'},{'Power-theta_DVR2'};...
    {'20190731_P1-005_E_nlab'},{'Power-beta_DVR2'},{'Power-theta_DVR2'};...
    {'20190927_P3-016_E_nlab'},{'Power-beta_DVRR4',{'Power-theta_DVR2'}};...
    {'20190927_P3-017_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20190927_P3-018_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20190927_P3-019_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20190930_P3-020_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20190930_P3-021_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20190930_P3-022_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20191003_P3-027_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20191003_P3-028_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20191003_P3-029_E_nlab'},{'Power-beta_DVRR4'},{'Power-theta_DVRR4'};...
    {'20200715_P5-033_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200716_P5-034_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200716_P5-036_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200716_P5-037_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200716_P5-038_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200716_P5-039_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200717_P5-040_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200717_P6-041_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200717_P6-042_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200717_P6-043_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200718_P6-044_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200718_P6-045_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200719_P5-046_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200719_P5-047_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200720_P5-048_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200720_P5-049_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200721_P5-050_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200721_P5-051_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200722_P6-052_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200722_P6-053_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200723_P6-054_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200723_P6-055_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200724_P6-056_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200725_P5-058_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200726_P5-060_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'};...
    {'20200726_P5-061_E_nlab'},{'Power-beta_DVR-PR2'},{'Power-theta_DVR-PR2'}];


InfoFileMouse =[{'20240812_K1653_001_E_nlab'},{'Power-beta_000'},{'Power-theta_000'};...
    {'20240820_K1656_001_E_nlab'},{'Power-beta_000'},{'Power-theta_000'};...
    {'20240820_K1657_001_E_nlab'},{'Power-beta_000'},{'Power-theta_000'}];


InfoFileRat =[{'20190226_SD025_P401_R_nlab'},{'Power-beta_023'},{'Power-theta_023'};...
    {'20190226_SD025_P402_R_nlab'},{'Power-beta_023'},{'Power-theta_023'};...
    {'20190416_SD032_P101_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P102_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P103_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P201_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P202_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P203_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P301_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P302_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P303_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P401_R_nlab'},{'Power-beta_005'},{'Power-theta_005'};...
    {'20190416_SD032_P402_R_nlab'},{'Power-beta_005'},{'Power-theta_005'}];


all_states = {'NREM','REM','AW'};

% Default Parameters
ParamsDefault.all_states = all_states;
ParamsDefault.GColors = GColors;
ParamsDefault.t_smooth = 10;
ParamsDefault.nCol = 10;        % Number Max Columns
ParamsDefault.seed_nlab = '/Users/tonio/Documents/Antoine-fUSDataset/NEUROLAB/NLab_DATA';
ParamsDefault.pattern_compute_channel = {'Power-beta';'Power-theta';'Power-delta'};
ParamsDefault.pattern_compute_region = {'*'};
ParamsDefault.pattern_display_channel = {'Power-beta'};
ParamsDefault.pattern_display_region = {'Whole-reg'};

% Specific Parameters
ParamsPogo = ParamsDefault;
ParamsPogo.Fs = 1;
ParamsPogo.WinSec = 300;
ParamsPogo.StepSec = 10;
ParamsPogo.MaxLagSec = 300;
ParamsPogo.NormWinMin = 3;
ParamsPogo.t_smooth = 10;
ParamsPogo.seed_save = '/Users/tonio/Desktop/XCorrPogo';
ParamsPogo.batchname = 'Pogona';
ParamsPogo.MinGroupDurSec = 300;
ParamsPogo.WinGroupSec = 600;

ParamsMouse= ParamsDefault;
ParamsMouse.Fs = 1;
ParamsMouse.WinSec = 150;
ParamsMouse.StepSec = 5;
ParamsMouse.MaxLagSec = 150;
ParamsMouse.NormWinMin = 1.5;
ParamsMouse.t_smooth = 5;
ParamsMouse.seed_save = '/Users/tonio/Desktop/XCorrMouse';
ParamsMouse.batchname = 'Mouse';
ParamsMouse.MinGroupDurSec = 60;
ParamsMouse.WinGroupSec = 120;
ParamsMouse.pattern_display_channel = {'Power-beta_000';'Power-theta_000'};
ParamsMouse.pattern_display_region = {'Whole-reg';'HPC'};

ParamsRat = ParamsMouse;
ParamsRat.seed_save = '/Users/tonio/Desktop/XCorrRat';
ParamsRat.batchname = 'Rat';
ParamsRat.pattern_display_channel = {'Power-beta'};
ParamsRat.pattern_display_region = {'[SR]'};


% % Compute and Plot Dynamic Xcorr Pogo
% if flag_recompute
%     compute_dynamic_xcorr(ParamsPogo,InfoFilePogo,false);
%     compute_dynamic_xcorr(ParamsPogo,InfoFilePogo,true);
% end
% if flag_savefig
%     plot_dynamic_xcorr(ParamsPogo,InfoFilePogo,false);
%     plot_dynamic_xcorr(ParamsPogo,InfoFilePogo,true);
% end
% if flag_perstate
%     S = plot_xcorr_per_state(ParamsPogo,InfoFilePogo,all_states);
% end

% % Compute and Plot Dynamic Xcorr Rat
% if flag_recompute
%     compute_dynamic_xcorr(ParamsRat,InfoFileRat,false);
%     compute_dynamic_xcorr(ParamsRat,InfoFileRat,true);
% end
% if flag_savefig
%     plot_dynamic_xcorr(ParamsRat,InfoFileRat,false);
%     plot_dynamic_xcorr(ParamsRat,InfoFileRat,true);
% end
% if flag_perstate
%     plot_xcorr_per_state(ParamsRat,InfoFileRat,all_states);
% end


% Compute and Plot Dynamic Xcorr Mouse
if flag_recompute
    compute_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1));
    compute_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,2));
    compute_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,2));
end
if flag_savefig
    plot_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1));
    plot_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,2));
    plot_dynamic_xcorr(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,3));
end
if flag_perstate
    plot_autocorr_per_state(ParamsMouse,InfoFileMouse(:,1));
    plot_autocorr_per_state(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,2));
    plot_autocorr_per_state(ParamsMouse,InfoFileMouse(:,1),InfoFileMouse(:,3));
end

end


function compute_dynamic_xcorr(Params,all_files,all_refs)

if nargin < 3 || isempty(all_refs)
    flag_crosscorr = false;
else
    flag_crosscorr = true;
end

% Parameters
Fs = Params.Fs;
t_smooth = Params.t_smooth;
WinSec = Params.WinSec;
StepSec = Params.StepSec;
MaxLagSec = Params.MaxLagSec;
NormWinMin = Params.NormWinMin;
seed_save = Params.seed_save;
seed_nlab = Params.seed_nlab;

% Gaussian window
w = gausswin(round(2*Fs*t_smooth));
w = (w/sum(w))';

for k=1:length(all_files)

    % Getting file info
    cur_file = char(all_files(k));
    filepath = fullfile(seed_nlab,cur_file);
    temp = regexp(cur_file,'_','split');
    temp2 = regexp(char(temp(2)),'-','split');
    cur_animal = char(temp2(1));
    folder_save = fullfile(seed_save,cur_animal);

    % Getting time
    data_t = load(fullfile(filepath,'Time_Reference.mat'));
    t_start = round(data_t.time_ref.Y(1));
    t_end = round(data_t.time_ref.Y(end));
    TimeData = t_start:1/Fs:t_end;

    % Selecting channels
    % pattern_channel = {'Power-beta';'Power-theta'};
    pattern_channel = Params.pattern_compute_channel;
    if sum(contains(pattern_channel,{'*'}))>0
        d_channels = dir(fullfile(filepath,'Sources_LFP','*.mat'));
    else
        d_channels = [];
        for i=1:length(pattern_channel)
            cur_pattern = char(pattern_channel(i));
            d_channels = [d_channels;dir(fullfile(filepath,'Sources_LFP',sprintf('*%s*.mat',cur_pattern)))];
        end
    end
    d_channels = d_channels(arrayfun(@(x) ~strcmp(x.name(1),'.'),d_channels));
    all_channels = unique({d_channels(:).name}');
    nChannels = size(all_channels,1);

    % Selecting regions
    % pattern_region = {'*'};         % select all regions
    pattern_region = Params.pattern_compute_region;
    if sum(contains(pattern_region,{'*'}))>0
        d_regions = dir(fullfile(filepath,'Sources_fUS','*.mat'));
    else
        d_regions = [];
        for i=1:length(pattern_region)
            cur_pattern = char(pattern_region(i));
            d_regions = [d_regions;dir(fullfile(filepath,'Sources_fUS',sprintf('*%s*.mat',cur_pattern)))];
        end
    end
    d_regions = d_regions(arrayfun(@(x) ~strcmp(x.name(1),'.'),d_regions));
    all_regions = unique({d_regions(:).name}');
    nRegions = size(all_regions,1);
    nTot = nChannels+nRegions;

    % Building DataRef
    if flag_crosscorr
        reference = char(all_refs(k));
        d_ref = dir(fullfile(filepath,'Sources_LFP',[reference,'.mat']));
        % Loading reference for xcorr
        if length(d_ref)==1
            data_ref = load(fullfile(d_ref.folder,d_ref.name));
            v = data_ref.Y(:)';
            x = data_ref.x_start:data_ref.f:data_ref.x_end;
            DataRef = interp1(x,v,TimeData);
            % Smoothing
            DataRef = nanconv(DataRef,w,'same');
        else
            warning('Missing reference channel [%s][%s]',cur_file,reference);
            continue;
        end
    else
        DataRef = [];
        reference = [];
    end


    % Computing xcorr
    % XCorrMat_Channels = NaN(length(TWin),length(2*WinSec+1),nChannels);
    XCorrMat_Channels = [];
    thisPos_Channels = [];
    thisNeg_Channels = [];
    XCorrPeak_Channels = struct('MeanXcorr',[],'Pos',[],'Neg',[]);
    Data_Channels = NaN(nChannels,size(TimeData,2));

    for i=1:nChannels

        % Loading Channel
        channel = char(all_channels(i));
        data_channel = load(fullfile(filepath,'Sources_LFP',channel));
        v = data_channel.Y(:)';
        x = data_channel.x_start:data_channel.f:data_channel.x_end;
        Data = interp1(x,v,TimeData);
        % Smoothing
        DataSmooth = nanconv(Data,w,'same');
        Data2 = [DataSmooth;DataRef];

        [TLag,TWin,XCorrMat,XCorrPeak,thisPos,thisNeg]=XCorrPA(Data2,Fs,WinSec,StepSec,MaxLagSec,NormWinMin);
        if ~flag_crosscorr
            fprintf('AutoCorrelation computed for channel [%s].\n',channel);
        else
            fprintf('Cross-Correlation computed for channel [%s].\n',channel);
        end

        % XCorrMat_Channels(:,:,i) = XCorrMat;
        XCorrMat_Channels = cat(3,XCorrMat_Channels,XCorrMat);
        thisPos_Channels = cat(3,thisPos_Channels,thisPos);
        thisNeg_Channels = cat(3,thisNeg_Channels,thisNeg);
        XCorrPeak_Channels(i) = XCorrPeak;
        Data_Channels(i,:) = DataSmooth;
    end

    % XCorrMat_Regions = NaN(length(TWin),length(2*WinSec+1),nRegions);
    XCorrMat_Regions = [];
    thisPos_Regions = [];
    thisNeg_Regions = [];
    XCorrPeak_Regions = struct('MeanXcorr',[],'Pos',[],'Neg',[]);
    Data_Regions = NaN(nRegions,size(TimeData,2));

    for i=1:nRegions

        % Loading Region
        region=char(all_regions(i));
        data_region = load(fullfile(filepath,'Sources_fUS',region));
        v = data_region.Y(:)';
        x = data_region.X(:)';
        Data = interp1(x,v,TimeData);
        % Smoothing
        DataSmooth = nanconv(Data,w,'same');
        Data2 = [DataSmooth;DataRef];

        [TLag,TWin,XCorrMat,XCorrPeak,thisPos,thisNeg]=XCorrPA(Data2,Fs,WinSec,StepSec,MaxLagSec,NormWinMin);
        if ~flag_crosscorr
            fprintf('AutoCorrelation computed for channel [%s].\n',region);
        else
            fprintf('Cross-Correlation computed for channel [%s].\n',region);
        end

        % XCorrMat_Regions(:,:,nRegions+i) = XCorrMat;
        XCorrMat_Regions = cat(3,XCorrMat_Regions,XCorrMat);
        thisPos_Regions = cat(3,thisPos_Regions,thisPos);
        thisNeg_Regions = cat(3,thisNeg_Regions,thisNeg);
        XCorrPeak_Regions(i)=XCorrPeak;
        Data_Regions(i,:) = DataSmooth;
    end

    % Saving Data
    if ~isfolder(folder_save)
        mkdir(folder_save)
    end
    Params.TLag = TLag;
    Params.TWin = TWin;

    XCorrMat_ydata = (TWin+WinSec/2+TimeData(1));
    XCorrMat_xdata = TLag;

    if ~flag_crosscorr
        mat_name = strcat('[ACorr]',cur_file,'.mat');
    else
        mat_name = strcat('[XCorr]',cur_file,sprintf('[%s].mat',reference));
    end
    fprintf('Saving data [%s]...',fullfile(folder_save,mat_name));
    save(fullfile(folder_save,mat_name),'Params','all_regions','all_channels','reference',...,
        'XCorrMat_Regions','XCorrPeak_Regions','XCorrMat_Channels','XCorrPeak_Channels',...
        'XCorrMat_xdata','XCorrMat_ydata',...
        'thisPos_Channels','thisNeg_Channels','thisPos_Regions','thisNeg_Regions',...
        'TimeData','Data_Channels','Data_Regions','DataRef','-v7.3');
    fprintf(' done.\n');
end

end


function plot_dynamic_xcorr(Params,all_files,all_refs)

if nargin < 3 || isempty(all_refs)
    flag_crosscorr = false;
else
    flag_crosscorr = true;
end

% Parameters
GColors = Params.GColors;
Fs = Params.Fs;
WinSec = Params.WinSec;
% StepSec = Params.StepSec;
MaxLagSec = Params.MaxLagSec;
% NormWinMin = Params.NormWinMin;
seed_save = Params.seed_save;
seed_nlab = Params.seed_nlab;
nCol = Params.nCol; % Number Max Columns
pattern_channel = Params.pattern_display_channel;
pattern_region  = Params.pattern_display_region ;


for k=1:length(all_files)

    % Getting file info
    cur_file = char(all_files(k));
    filepath = fullfile(seed_nlab,cur_file);
    temp = regexp(cur_file,'_','split');
    temp2 = regexp(char(temp(2)),'-','split');
    cur_animal = char(temp2(1));
    folder_save = fullfile(seed_save,cur_animal);

    % Getting time
    data_t = load(fullfile(filepath,'Time_Reference.mat'));
    t_start = round(data_t.time_ref.Y(1));
    t_end = round(data_t.time_ref.Y(end));
    TimeData = t_start:1/Fs:t_end;

    % Getting time groups
    data_tg = load(fullfile(filepath,'Time_Groups.mat'));

    % Selecting channels
    if sum(contains(pattern_channel,{'*'}))>0
        d_channels = dir(fullfile(filepath,'Sources_LFP','*.mat'));
    else
        d_channels = [];
        for i=1:length(pattern_channel)
            cur_pattern = char(pattern_channel(i));
            d_channels = [d_channels;dir(fullfile(filepath,'Sources_LFP',sprintf('*%s*.mat',cur_pattern)))];
        end
    end
    d_channels = d_channels(arrayfun(@(x) ~strcmp(x.name(1),'.'),d_channels));
    ind_channels = 1:length(d_channels);
    %     ind_channels = (1:4);
    all_channels = unique({d_channels(ind_channels).name}');
    nChannels = size(all_channels,1);

    % Selecting regions
    if sum(contains(pattern_region,{'*'}))>0
        d_regions = dir(fullfile(filepath,'Sources_fUS','*.mat'));
    else
        d_regions = [];
        for i=1:length(pattern_region)
            cur_pattern = char(pattern_region(i));
            d_regions = [d_regions;dir(fullfile(filepath,'Sources_fUS',sprintf('*%s*.mat',cur_pattern)))];
        end
    end
    d_regions = d_regions(arrayfun(@(x) ~strcmp(x.name(1),'.'),d_regions));
    ind_regions = 1:length(d_regions);
    % ind_channels = (1:4);
    all_regions = unique({d_regions(ind_regions).name}');
    nRegions = size(all_regions,1);
    nTot = nChannels+nRegions;

    % Selecting reference
    if flag_crosscorr
        reference = char(all_refs(k));
        d_ref = dir(fullfile(filepath,'Sources_LFP',[reference,'.mat']));
        % Loading reference for xcorr
        if length(d_ref)==1
            data_ref = load(fullfile(filepath,'Sources_LFP',d_ref.name));
            v = data_ref.Y(:)';
            x = data_ref.x_start:data_ref.f:data_ref.x_end;
            DataRef = interp1(x,v,TimeData);
        else
            warning('Missing reference channel [%s]',filepath);
            continue;
        end
    else
        DataRef = [];
        reference = [];
    end

    % Saving Figure
    % Locating Data
    if ~flag_crosscorr
        mat_name = strcat('[ACorr]',cur_file,'.mat');
    else
        mat_name = strcat('[XCorr]',cur_file,sprintf('[%s].mat',reference));
    end
    if ~isfile(fullfile(folder_save,mat_name))
        warning('Missing data file [%s]',fullfile(folder_save,mat_name));
        continue;
    else

        % Loading file
        fprintf('Loading data [%s]...',fullfile(folder_save,mat_name));
        data_mat = load(fullfile(folder_save,mat_name));
        %  data_mat = load(fullfile(folder_save,mat_name),'all_regions','all_channels','Params',...
        %      'XCorrMat_all','XCorrPeak_all','Data_all');

        Params = data_mat.Params;
        TLag=Params.TLag;
        TWin=Params.TWin;

        XCorrMat_all = rand(length(TWin),length(TLag),nTot);
        thisPos_all = rand(length(TWin),2,nTot);
        thisNeg_all = rand(length(TWin),2,nTot);
        XCorrPeak_all = struct('MeanXcorr',[],'Pos',[],'Neg',[]);
        Data_Channels = rand(nChannels,length(TimeData));
        for j=1:length(all_channels)
            index_channel = find(strcmp(data_mat.all_channels,all_channels(j))==1);
            XCorrMat_all(:,:,j) = data_mat.XCorrMat_Channels(:,:,index_channel);
            XCorrPeak_all(j) = data_mat.XCorrPeak_Channels(index_channel);
            Data_Channels(j,:) = data_mat.Data_Channels(index_channel,:);
            thisPos_all(:,:,j) = data_mat.thisPos_Channels(:,:,index_channel);
            thisNeg_all(:,:,j) = data_mat.thisNeg_Channels(:,:,index_channel);
        end
        Data_Regions = NaN(nChannels,length(TimeData));
        for j=1:length(all_regions)
            index_region = find(strcmp(data_mat.all_regions,all_regions(j))==1);
            if isempty(index_region)
                warning('Region not found [%s - %s]',char(all_regions(j)),cur_file);
                XCorrPeak_all(nChannels+j).MeanXcorr = rand(1,size(data_mat.XCorrPeak_Regions(1).MeanXcorr,2));
                XCorrPeak_all(nChannels+j).Pos = rand(1,2);
                XCorrPeak_all(nChannels+j).Neg = XCorrPeak_all(nChannels+j).Pos-0.5;
            else
                XCorrMat_all(:,:,nChannels+j) = data_mat.XCorrMat_Regions(:,:,index_region);
                XCorrPeak_all(nChannels+j) = data_mat.XCorrPeak_Regions(index_region);
                Data_Regions(j,:) = data_mat.Data_Regions(index_region,:);
                thisPos_all(:,:,nChannels+j) = data_mat.thisPos_Regions(:,:,index_region);
                thisNeg_all(:,:,nChannels+j) = data_mat.thisNeg_Regions(:,:,index_region);
            end
        end

        Data_all = [Data_Channels;Data_Regions];
        fprintf(' done.\n');
        TimeData = data_mat.TimeData;

        all_labels = [];
        for i=1:nChannels
            channel=char(all_channels(i));
            label = regexprep(channel,'.mat','');
            label = regexprep(label,'_','-');
            all_labels = [all_labels;{label}];
        end
        for i=1:nRegions
            region=char(all_regions(i));
            label = regexprep(region,'.mat','');
            label = regexprep(label,'_','-');
            all_labels = [all_labels;{label}];
        end

        % Saving figure
        if ~isfolder(folder_save)
            mkdir(folder_save)
        end

        % Plotting only if flag_savefig is True
        % Prepare plot
        nFigs = ceil(nTot/nCol);
        all_f = gobjects(nFigs);
        all_ax = gobjects(4,nTot);

        % Figures
        for index_fig = 1:nFigs
            all_f(index_fig) = figure;
            if ~flag_crosscorr
                all_f(index_fig).Name = sprintf('[ACorr]%s-%03d',cur_file,index_fig);
            else
                all_f(index_fig).Name = sprintf('[XCorr]%s[%s]-%03d',cur_file,reference,index_fig);
            end
        end
        count = 1;
        eps = .01;
        % Axes
        for i=1:nTot
            framepos = [(count-1)/nCol+2*eps  .025  1/nCol-eps  .95];
            all_ax(1,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)  framepos(2)+.25  0.75*framepos(3)   .7]);
            all_ax(2,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+0.75*framepos(3)  framepos(2)+.25  0.25*framepos(3)   .7]);
            all_ax(3,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)  framepos(2)+.125  0.75*framepos(3)   .1]);
            all_ax(4,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)  framepos(2)  0.75*framepos(3)   .1]);
            count=mod(count,nCol)+1;
        end

        % plot  map and mean xcorr with peaks
        for i=1:nTot
            label=char(all_labels(i));
            XCorrMat = XCorrMat_all(:,:,i);
            XCorrPeak = XCorrPeak_all(i);
            time_ticks = (900:900:TimeData(end))';
            time_ticks_label = datestr(time_ticks/(24*3600),'HH:MM');

            ax1=all_ax(1,i);
            % p = pcolor(TLag,TWin,XCorrMat,'Parent',ax1);
            % shading(ax1,'flat');
            YTime = (TWin+WinSec/2+TimeData(1));
            imagesc('XData',TLag,'YData',YTime,'CData',XCorrMat,'Parent',ax1);
            % Adding peaks
            line('XData',thisPos_all(:,1,i),'YData',YTime,'LineStyle','none','Parent',ax1,...
                'Marker','o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none');
            line('XData',thisNeg_all(:,1,i),'YData',YTime,'LineStyle','none','Parent',ax1,...
                'Marker','o','MarkerSize',3,'MarkerFaceColor',[.5 .5 .5],'MarkerEdgeColor','none');

            % ax1.YLim = [YTime(1),YTime(end)];
            ax1.YLim = [TimeData(1),TimeData(end)];
            ax1.YDir = 'reverse';
            set(ax1,'YTick',time_ticks,'YTickLabel',time_ticks_label);
            ax1.XLim = [TLag(1),TLag(end)];
            ax1.Title.String = label;

            ax2=all_ax(2,i);
            line('XData',Data_all(i,:),'YData',TimeData,'Parent',ax2);
            if sum(~isnan(Data_all(i,:)))>0
                ax2.XLim = [mean(Data_all(i,:),'omitnan')-1.5*std(Data_all(i,:),[],'omitnan') mean(Data_all(i,:),'omitnan')+3*std(Data_all(i,:),[],'omitnan')];
            else
                ax2.XLim = [-1,1];
            end
            ax2.YLim = [TimeData(1),TimeData(end)];
            ax2.YDir = 'reverse';
            set(ax2,'YTick',time_ticks,'YTickLabel','');

            % Time Patches
            for index = 1:length(GColors.TimeGroups)
                name = char(GColors.TimeGroups(index).Name);
                if sum(strcmp(data_tg.TimeGroups_name,name))>0
                    %create patch
                    index_group = find(strcmp(data_tg.TimeGroups_name,name)==1);
                    a = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,1));
                    b = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,2));
                    ydata = [(a-floor(a))*24*3600,(b-floor(b))*24*3600];
                    for j = 1:size(ydata,1)
                        p = patch('XData',[ax2.XLim(1) ax2.XLim(1) ax2.XLim(2) ax2.XLim(2)],...
                            'YData',[ydata(j,1) ydata(j,2) ydata(j,2) ydata(j,1)],...
                            'Parent',ax2,'Tag','TimePatch');
                        p.EdgeColor = 'none';
                        p.FaceColor = GColors.TimeGroups(index).Color;
                        p.FaceAlpha = GColors.TimeGroups(index).Transparency;
                    end
                end
            end

            % Mean Autocorr
            ax3 = all_ax(3,i);
            grid(ax3,'on');
            line('XData',TLag,'YData',XCorrPeak.MeanXcorr,'Parent',ax3);
            line('XData',XCorrPeak.Pos(1),'YData',XCorrPeak.Pos(2),'Marker','o','Color','r','Parent',ax3);
            line('XData',XCorrPeak.Neg(1),'YData',XCorrPeak.Neg(2),'Marker','x','Color','r','Parent',ax3);
            ax3.YLim = [-.5 1];
            text(-MaxLagSec,ax3.YLim(2)-.25,sprintf('Amp=%.2f',XCorrPeak.Pos(2)-XCorrPeak.Neg(2)),'Parent',ax3);
            text(-MaxLagSec,ax3.YLim(2)-.1,sprintf('Lag=%dsec',XCorrPeak.Pos(1)),'Parent',ax3);

            % Scatter Plot
            ax4 = all_ax(4,i);
            grid(ax4,'on');
            if ~flag_crosscorr
                line('XData',thisPos_all(:,1,i),'YData',thisPos_all(:,2,i)-thisNeg_all(:,2,i),'Parent',ax4,...
                    'LineStyle','none','MarkerFaceColor','k','MarkerEdgeColor','none','Marker','o','MarkerSize',2);
                ax4.YLim = [0 1.5];
            else
                line('XData',thisPos_all(:,1,i),'YData',thisPos_all(:,2,i),'Parent',ax4,...
                    'LineStyle','none','MarkerFaceColor','k','MarkerEdgeColor','none','Marker','o','MarkerSize',2);
                ax4.YLim = [0 1];
            end
            ax4.XLim = [TLag(1) TLag(end)];
            ax4.XLabel.String = 'Lag';
            ax4.YLabel.String = 'XCorr Amp';

            %             linkaxes([ax1;ax3],'x');
            count = count+1;
        end

        % Saving figure
        for index_fig = 1:nFigs
            f = all_f(index_fig);
            f.Units='normalized';
            f.OuterPosition = [0 0 1 1];
            f.PaperPositionMode = 'manual';
            pic_name = strcat(f.Name,'.pdf');
            fprintf('Saving figure [%s]...',fullfile(folder_save,pic_name));
            exportgraphics(f,fullfile(seed_save,pic_name),'ContentType','vector');
            % saveas(f,fullfile(seed_save,pic_name),'pdf');
            fprintf(' done.\n');
            close(f);
        end
    end
end

end


function S = plot_autocorr_per_state(Params,all_files,all_refs)

if nargin < 3 || isempty(all_refs)
    flag_crosscorr = false;
else
    flag_crosscorr = true;
end

% Parameters
% GColors = Params.GColors;
% Fs = Params.Fs;
batchname = Params.batchname;
nCol = Params.nCol;
% WinSec = Params.WinSec;
% StepSec = Params.StepSec;
% MaxLagSec = Params.MaxLagSec;
% NormWinMin = Params.NormWinMin;
MinGroupDurSec = Params.MinGroupDurSec;
WinGroupSec = Params.WinGroupSec;
seed_save = Params.seed_save;
seed_nlab = Params.seed_nlab;
pattern_region = Params.pattern_display_region;
pattern_channel = Params.pattern_display_channel;
all_states = Params.all_states;
nStates = length(all_states);


% Buidling Time_selection
TS = struct('all_times',[],'state',[],'animal',[],'acorr',[]);

for k=1:length(all_files)

    % Getting file info
    cur_file = char(all_files(k));
    filepath = fullfile(seed_nlab,cur_file);
    temp = regexp(cur_file,'_','split');
    temp2 = regexp(char(temp(2)),'-','split');
    cur_animal = char(temp2(1));

    % Getting time groups
    data_tg = load(fullfile(filepath,'Time_Groups.mat'));
    for j=1:length(all_states)
        cur_state = char(all_states(j));
        index_group = find(strcmp(data_tg.TimeGroups_name,cur_state)==1);

        if ~isempty(index_group)
            % Converting times
            a = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,1));
            b = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,2));
            Time_indices = [(a-floor(a))*24*3600,(b-floor(b))*24*3600];

            % Keeping only long bouts
            all_times = [];
            ind_long_bouts = find((Time_indices(:,2)-Time_indices(:,1))>=MinGroupDurSec);
            if isempty(ind_long_bouts)
                continue;
            end
            for l = 1:length(ind_long_bouts)
                times_keep = Time_indices(ind_long_bouts(l),1)+WinGroupSec/2 : WinGroupSec : Time_indices(ind_long_bouts(l),2);
                all_times = [all_times;times_keep(:)];
            end

            TS.all_times = [TS.all_times;all_times];
            TS.state = [TS.state;repmat({cur_state},[size(all_times,1),1])];
            TS.animal = [TS.animal;repmat({cur_animal},[size(all_times,1),1])];
            if ~flag_crosscorr
                mat_name_acorr = strcat('[ACorr]',cur_file,'.mat');
            else
                reference = char(all_refs(k));
                mat_name_acorr = strcat('[XCorr]',cur_file,sprintf('[%s].mat',reference));
            end

            TS.acorr = [TS.acorr;repmat({fullfile(seed_save,cur_animal,mat_name_acorr)},[size(all_times,1),1])];
        end
    end
end

all_animals = unique(TS.animal);
% all_regions = {'Whole.mat'};

S = struct('ACorr',[],'ACorr_Lag',[],'ACorr_Amp',[],...
    'region',[],'channel',[],'trace',[],...
    'state',[],'animal',[],'TLag',[]);


prev_acorr = '';
for k=1:length(TS.all_times)

    cur_time = TS.all_times(k);
    cur_state = char(TS.state(k));
    cur_animal = char(TS.animal(k));
    cur_acorr = char(TS.acorr(k));

    % Loading autocorrelation
    if ~isfile(cur_acorr)
        warning('Impossible to load file [%s].',data_acorr);
        continue;
    else
        if ~strcmp(cur_acorr,prev_acorr)
            data_acorr = load(cur_acorr,...
                'all_regions','all_channels','XCorrMat_ydata','Params',...
                'XCorrMat_Regions','thisPos_Regions','thisNeg_Regions',...
                'XCorrMat_Channels','thisPos_Channels','thisNeg_Channels');
            if ~flag_crosscorr
                fprintf('Auto-correlation file loaded [%s].\n',cur_acorr);
            else
                fprintf('Cross-Correlation file loaded [%s].\n',cur_acorr);
            end
            prev_acorr = cur_acorr;
        end
    end

    % Selecting regions
    if sum(contains(pattern_region,{'*'}))>0
        index_regions = 1:length(data_acorr.all_regions);
    else
        index_regions = [];
        for i =1:length(pattern_region)
            cur_pattern = char(pattern_region(i));
            index_regions = [index_regions;find(contains(data_acorr.all_regions,cur_pattern)==1)];
        end
        index_regions = unique(index_regions);
    end
    % Selecting channels
    if sum(contains(pattern_channel,{'*'}))>0
        index_channels = 1:length(data_acorr.all_channels);
    else
        index_channels = [];
        for i =1:length(pattern_channel)
            cur_pattern = char(pattern_channel(i));
            index_channels = [index_channels;find(contains(data_acorr.all_channels,cur_pattern)==1)];
        end
        index_channels = unique(index_channels);
    end
    nChannels = length(index_channels);
    nRegions = length(index_regions);
    nTot = nChannels+nRegions;

    % Finding row
    [val1,index_min1] = min(abs(data_acorr.XCorrMat_ydata - cur_time));
    if val1>data_acorr.Params.StepSec
        continue;
    else

        % AutoCorr Region
        for i =1:nRegions
            ACorr = data_acorr.XCorrMat_Regions(index_min1,:,index_regions(i));
            if ~flag_crosscorr
                ACorr_Lag = data_acorr.thisPos_Regions(index_min1,1,index_regions(i));
                ACorr_Amp = data_acorr.thisPos_Regions(index_min1,2,index_regions(i))-data_acorr.thisNeg_Regions(index_min1,2,index_regions(i));
            else
                ACorr_Lag = data_acorr.thisPos_Regions(index_min1,1,index_regions(i));
                ACorr_Amp = data_acorr.thisPos_Regions(index_min1,2,index_regions(i));
            end

            % Storing
            S.ACorr = [S.ACorr;ACorr];
            S.ACorr_Lag = [S.ACorr_Lag;ACorr_Lag];
            S.ACorr_Amp = [S.ACorr_Amp;ACorr_Amp];
            S.state = [S.state;{cur_state}];
            S.animal = [S.animal;{cur_animal}];
            S.trace = [S.trace;data_acorr.all_regions(index_regions(i))];
            S.region = [S.region;data_acorr.all_regions(index_regions(i))];
            % S.channel = [S.channel;{''}];
            S.TLag = [S.TLag;data_acorr.Params.TLag];
        end

        % AutoCorr Channel
        for i =1:nChannels
            ACorr = data_acorr.XCorrMat_Channels(index_min1,:,index_channels(i));
            if ~flag_crosscorr
                ACorr_Lag = data_acorr.thisPos_Channels(index_min1,1,index_channels(i));
                ACorr_Amp = data_acorr.thisPos_Channels(index_min1,2,index_channels(i))-data_acorr.thisNeg_Channels(index_min1,2,index_channels(i));
            else
                ACorr_Lag = data_acorr.thisPos_Channels(index_min1,1,index_channels(i));
                ACorr_Amp = data_acorr.thisPos_Channels(index_min1,2,index_channels(i));
            end

            % Storing
            S.ACorr = [S.ACorr;ACorr];
            S.ACorr_Lag = [S.ACorr_Lag;ACorr_Lag];
            S.ACorr_Amp = [S.ACorr_Amp;ACorr_Amp];
            S.state = [S.state;{cur_state}];
            S.animal = [S.animal;{cur_animal}];
            S.trace = [S.trace;data_acorr.all_channels(index_channels(i))];
            % S.region = [S.region;{''}];
            S.channel = [S.channel;data_acorr.all_channels(index_channels(i))];
            S.TLag = [S.TLag;data_acorr.Params.TLag];
        end
    end

end

% all_traces = unique(S.trace);
all_traces = [unique(S.channel);unique(S.region)];
nTraces = length(all_traces);
all_animals = unique(TS.animal);
nAnimals = length(all_animals);
g_colors = get(groot,'defaultAxesColorOrder');

% Prepare plot
nFigs = ceil(nTraces/nCol);
all_f = gobjects(nFigs);
all_ax = gobjects(nTraces,nStates,3);

eps1 = .02;
eps2 = .02;

if nFigs>1
    % Multiple Figures
    for index_fig = 1:nFigs
        all_f(index_fig) = figure;
        if ~flag_crosscorr
            all_f(index_fig).Name = sprintf('AutoCorrelation-per-state[%s-%02d]',batchname,index_fig);
        else
            all_f(index_fig).Name = sprintf('CrossCorrelation-per-state[%s-%s-%02d]',batchname,reference,index_fig);
        end
    end
    count = 1;
    % Axes
    for i=1:nTraces
        for j=1:nStates
            framepos = [(count-1)/nCol+eps1  ((nStates-j)/nStates)+eps1  1/nCol-eps1  (1/nStates)-2*eps1];
            all_ax(i,j,1) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+eps2  framepos(2)+.5*framepos(4)+eps2  framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,2) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+eps2  framepos(2)+eps2  .5*framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,3) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+.5*framepos(3)+eps2  framepos(2)+eps2  .5*framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,1).Title.String = sprintf('Ax%d-%d',i,j);
        end
        count=mod(count,nCol)+1;
    end
else
    % Single Figure
    all_f(1) = figure;
    if ~flag_crosscorr
        all_f(1).Name = sprintf('AutoCorrelation-per-state[%s]',batchname);
    else
        all_f(1).Name = sprintf('CrossCorrelation-per-state[%s-%s]',batchname,reference);
    end
    for i=1:nTraces
        for j=1:nStates
            framepos = [(i-1)/nTraces+eps1  ((nStates-j)/nStates)+eps1  1/nTraces-2*eps1  (1/nStates)-2*eps1];
            all_ax(i,j,1) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+eps2  framepos(2)+.5*framepos(4)+eps2  framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,2) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+eps2  framepos(2)+eps2  .5*framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,3) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+.5*framepos(3)+eps2  framepos(2)+eps2  .5*framepos(3)-eps2   .5*framepos(4)-eps2]);
            all_ax(i,j,1).Title.String = sprintf('Ax%d-%d',i,j);
        end
    end
end


TLag = data_acorr.Params.TLag;
for i = 1:nTraces

    cur_trace = char(all_traces(i));

    for j=1:nStates

        cur_state = char(all_states(j));

        ax1 = all_ax(i,j,1);
        ax1.YLabel.String = cur_state;
        ax1.Title.String = sprintf('AutoCorr[%s]',cur_trace);
        ax1.XLim = [TLag(1) TLag(end)];
        ax1.YLim = [-1 1];
        hold(ax1,'on');
        grid(ax1,'on');

        ax2 = all_ax(i,j,2);
        grid(ax2,"on");
        % l = legend(list_tags);
        ax2.XTick = 1:nAnimals;
        ax2.XTickLabel = all_animals;
        ax2.XLim = [.5,nAnimals+.5];
        ax2.YLim = [0,TLag(end)];
        ax2.YLabel.String = 'Lag(s)';

        ax3 = all_ax(i,j,3);
        grid(ax3,"on");
        % l = legend(list_tags);
        ax3.XTick = 1:nAnimals;
        ax3.XTickLabel = all_animals;
        ax3.XLim = [.5,nAnimals+.5];
        ax3.YLim = [0,1.5];
        ax3.YLabel.String = 'ACorr Amp';

        alpha_value = .5;
        linewidth = 2;
        s_markers = {'o';'+';'.'};

        all_lines =[];
        for k = 1:nAnimals
            cur_animal = char(all_animals(k));

            % Selecting data
            index_keep = find((strcmp(S.state,cur_state).*strcmp(S.animal,cur_animal)).*strcmp(S.trace,cur_trace)==1);
            % Mean AutoCorr
            ACorr_mean = mean(S.ACorr(index_keep,:),1,'omitnan');
            ACorr_std = std(S.ACorr(index_keep,:),[],1,'omitnan');
            nSamples = sum(~isnan(S.ACorr(index_keep,:)),1);
            ACorr_sem = ACorr_std./sqrt(nSamples);
            % Lags
            ACorr_Lag = S.ACorr_Lag(index_keep);
            % XCorrAmp
            ACorr_Amp = S.ACorr_Amp(index_keep);

            % Display Ax1
            px_data = [TLag,fliplr(TLag)];
            py_data = [ACorr_mean+ACorr_sem,fliplr(ACorr_mean-ACorr_sem)];
            patch('XData',px_data,'YData',py_data,'FaceColor',g_colors(k,:),'EdgeColor','none',...
                'Parent',ax1,'Visible','on','FaceAlpha',alpha_value);
            l=line('XData',TLag,'YData',ACorr_mean,'Parent',ax1,'Color',g_colors(k,:),'Linewidth',linewidth,'DisplayName',sprintf('%s[N=%d]',cur_animal,median(nSamples)));
            all_lines =[all_lines;l];

            % Display Ax2
            ydata = ACorr_Lag(:);
            xdata = k*ones(size(ydata))+rand(size(ydata))/10;
            line('XData',xdata(:),'YData',ydata(:),'Color',g_colors(k,:),'LineStyle','none','Parent',ax2,...
                'Marker','o','MarkerEdgeColor',g_colors(k,:),'MarkerFaceColor',g_colors(k,:),'MarkerSize',5);
            n_samples = sum(~isnan(ydata));
            m = mean(ydata,'omitnan');
            line('Xdata',k+.05,'YData',m,'Parent',ax2,'LineStyle','none','LineWidth',2,...
                'Marker','_','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);
            line('Xdata',k+.05,'YData',m+std(ydata,[],'omitnan')/sqrt(n_samples),'Parent',ax2,'LineStyle','none','LineWidth',2,...
                'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);
            line('Xdata',k+.05,'YData',m-std(ydata,[],'omitnan')/sqrt(n_samples),'Parent',ax2,'LineStyle','none','LineWidth',2,...
                'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);

            % Display Ax3
            ydata = ACorr_Amp(:);
            xdata = k*ones(size(ydata))+rand(size(ydata))/10;
            line('XData',xdata(:),'YData',ydata(:),'Color',g_colors(k,:),'LineStyle','none','Parent',ax3,...
                'Marker','o','MarkerEdgeColor',g_colors(k,:),'MarkerFaceColor',g_colors(k,:),'MarkerSize',5);
            n_samples = sum(~isnan(ydata));
            m = mean(ydata,'omitnan');
            line('Xdata',k+.05,'YData',m,'Parent',ax3,'LineStyle','none','LineWidth',2,...
                'Marker','_','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);
            line('Xdata',k+.05,'YData',m+std(ydata,[],'omitnan')/sqrt(n_samples),'Parent',ax3,'LineStyle','none','LineWidth',2,...
                'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);
            line('Xdata',k+.05,'YData',m-std(ydata,[],'omitnan')/sqrt(n_samples),'Parent',ax3,'LineStyle','none','LineWidth',2,...
                'Marker','.','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',10);

        end
        legend(ax1, all_lines);
    end
end

end


% % Keep as control (for comparison)
% function S = plot_xcorr_per_state(InfoFile,Params,all_states)
% 
% all_files = InfoFile(:,1);
% all_refs = InfoFile(:,2);
% nStates = length(all_states);
% 
% % Parameters
% % GColors = Params.GColors;
% % Fs = Params.Fs;
% % WinSec = Params.WinSec;
% % StepSec = Params.StepSec;
% % MaxLagSec = Params.MaxLagSec;
% % NormWinMin = Params.NormWinMin;
% MinGroupDurSec = Params.MinGroupDurSec;
% WinGroupSec = Params.WinGroupSec;
% 
% seed_save = Params.seed_save;
% seed_nlab = Params.seed_nlab;
% 
% 
% % Buidling Time_selection
% TS = struct('all_times',[],'state',[],'animal',[],'acorr',[],'xcorr',[]);
% 
% for k=1:length(all_files)
% 
%     % Getting file info
%     cur_file = char(all_files(k));
%     reference = char(all_refs(k));
%     filepath = fullfile(seed_nlab,cur_file);
%     temp = regexp(cur_file,'_','split');
%     temp2 = regexp(char(temp(2)),'-','split');
%     cur_animal = char(temp2(1));
% 
%     % Getting time groups
%     %     data_tr = load(fullfile(filepath,'Time_Reference.mat'));
%     data_tg = load(fullfile(filepath,'Time_Groups.mat'));
%     for j=1:length(all_states)
%         cur_state = char(all_states(j));
%         index_group = find(strcmp(data_tg.TimeGroups_name,cur_state)==1);
% 
%         if ~isempty(index_group)
%             % Converting times
%             a = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,1));
%             b = datenum(data_tg.TimeGroups_S(index_group).TimeTags_strings(:,2));
%             Time_indices = [(a-floor(a))*24*3600,(b-floor(b))*24*3600];
% 
%             % Keeping only long bouts
%             all_times = [];
%             ind_long_bouts = find((Time_indices(:,2)-Time_indices(:,1))>=MinGroupDurSec);
%             if isempty(ind_long_bouts)
%                 continue;
%             end
%             for l = 1:length(ind_long_bouts)
%                 times_keep = Time_indices(ind_long_bouts(l),1)+WinGroupSec/2 : WinGroupSec : Time_indices(ind_long_bouts(l),2);
%                 all_times = [all_times;times_keep(:)];
%             end
% 
%             TS.all_times = [TS.all_times;all_times];
%             TS.state = [TS.state;repmat({cur_state},[size(all_times,1),1])];
%             TS.animal = [TS.animal;repmat({cur_animal},[size(all_times,1),1])];
% 
%             mat_name_acorr = strcat('[ACorr]',cur_file,'.mat');
%             TS.acorr = [TS.acorr;repmat({fullfile(seed_save,cur_animal,mat_name_acorr)},[size(all_times,1),1])];
%             mat_name_xcorr = strcat('[XCorr]',cur_file,sprintf('[%s].mat',reference));
%             TS.xcorr = [TS.xcorr;repmat({fullfile(seed_save,cur_animal,mat_name_xcorr)},[size(all_times,1),1])];
%         end
%     end
% end
% 
% all_animals = unique(TS.animal);
% % all_regions = {'Whole.mat'};
% 
% S = struct('ACorr',[],'ACorr_Lag',[],'ACorr_Amp',[],...
%     'ACorr2',[],'ACorr_Lag2',[],'ACorr_Amp2',[],...
%     'XCorr',[],'XCorr_Lag',[],'XCorr_Amp',[],...
%     'state',[],'animal',[],'TLag',[]);
% 
% 
% prev_acorr = '';
% prev_xcorr = '';
% for k=1:length(TS.all_times)
% 
%     cur_time = TS.all_times(k);
%     cur_state = char(TS.state(k));
%     cur_animal = char(TS.animal(k));
%     cur_acorr = char(TS.acorr(k));
%     cur_xcorr = char(TS.xcorr(k));
% 
%     % Loading autocorrelation
%     if ~isfile(cur_acorr)
%         warning('Impossible to load file [%s].',data_acorr);
%         continue;
%     else
%         if ~strcmp(cur_acorr,prev_acorr)
%             data_acorr = load(cur_acorr,...
%                 'all_regions','all_channels','XCorrMat_ydata','Params',...
%                 'XCorrMat_Regions','thisPos_Regions','thisNeg_Regions',...
%                 'XCorrMat_Channels','thisPos_Channels','thisNeg_Channels');
%             fprintf('Auto-correlation file loaded [%s].\n',cur_acorr);
%             prev_acorr = cur_acorr;
%         end
%     end
%     % Loading crosscorrelation
%     if ~isfile(cur_xcorr)
%         warning('Impossible to load file [%s].',data_xcorr);
%         continue;
%     else
%         if ~strcmp(cur_xcorr,prev_xcorr)
%             data_xcorr = load(cur_xcorr,...
%                 'all_regions','all_channels','XCorrMat_ydata','Params','reference',...
%                 'XCorrMat_Regions','thisPos_Regions',...
%                 'XCorrMat_Channels','thisPos_Channels');
%             fprintf('Cross-correlation file loaded [%s].\n',cur_xcorr);
%             prev_xcorr = cur_xcorr;
%         end
%     end
% 
%     index_whole = find(strcmp(data_acorr.all_regions,'Whole-reg.mat')==1);
% 
%     if isempty(index_whole)
%         warning('Unable to find [%s] in [%s].','Whole-reg.mat',cur_acorr);
%         continue;
%     end
%     index_ref = find(strcmp(data_acorr.all_channels,[char(data_xcorr.reference),'.mat'])==1);
%     if isempty(index_ref)
%         warning('Unable to find [%s] in [%s].',char(data_xcorr.reference),cur_acorr);
%         continue;
%     end
%     index_whole2 = find(strcmp(data_xcorr.all_regions,'Whole-reg.mat')==1);
% 
%     if isempty(index_whole2)
%         warning('Unable to find [%s] in [%s].','Whole-reg.mat',cur_xcorr);
%         continue;
%     end
% 
%     % Finding row
%     [val1,index_min1] = min(abs(data_acorr.XCorrMat_ydata - cur_time));
%     [val2,index_min2] = min(abs(data_xcorr.XCorrMat_ydata - cur_time));
%     if val1>data_acorr.Params.StepSec || val2>data_xcorr.Params.StepSec
%         continue;
%     else
%         % AutoCorr Region
%         ACorr = data_acorr.XCorrMat_Regions(index_min1,:,index_whole);
%         thisPos = data_acorr.thisPos_Regions(index_min1,:,index_whole);
%         thisNeg = data_acorr.thisNeg_Regions(index_min1,:,index_whole);
%         ACorr_Lag = thisPos(1);
%         ACorr_Amp = thisPos(2)-thisNeg(2);
% 
%         % AutoCorr Channel
%         ACorr2 = data_acorr.XCorrMat_Channels(index_min1,:,index_ref);
%         thisPos = data_acorr.thisPos_Channels(index_min1,:,index_ref);
%         thisNeg = data_acorr.thisNeg_Channels(index_min1,:,index_ref);
%         ACorr_Lag2 = thisPos(1);
%         ACorr_Amp2 = thisPos(2)-thisNeg(2);
% 
%         % CrossCorr Region
%         XCorr = data_xcorr.XCorrMat_Regions(index_min2,:,index_whole2);
%         thisPos = data_xcorr.thisPos_Regions(index_min2,:,index_whole2);
%         XCorr_Lag = thisPos(1);
%         XCorr_Amp = thisPos(2);
%     end
% 
%     S.ACorr = [S.ACorr;ACorr];
%     S.ACorr_Lag = [S.ACorr_Lag;ACorr_Lag];
%     S.ACorr_Amp = [S.ACorr_Amp;ACorr_Amp];
%     S.ACorr2 = [S.ACorr2;ACorr2];
%     S.ACorr_Lag2 = [S.ACorr_Lag2;ACorr_Lag2];
%     S.ACorr_Amp2 = [S.ACorr_Amp2;ACorr_Amp2];
%     S.XCorr = [S.XCorr;XCorr];
%     S.XCorr_Lag = [S.XCorr_Lag;XCorr_Lag];
%     S.XCorr_Amp = [S.XCorr_Amp;XCorr_Amp];
% 
%     S.state = [S.state;{cur_state}];
%     S.animal = [S.animal;{cur_animal}];
%     S.TLag = [S.TLag;data_acorr.Params.TLag];
% 
% end
% 
% all_animals = unique(TS.animal);
% nAnimals = length(all_animals);
% g_colors = get(groot,'defaultAxesColorOrder');
% 
% figure;
% all_axes = gobjects(nStates,3);
% count = 1;
% for i = 1:nStates
%     all_axes(i,1) = subplot(nStates,3,count);
%     all_axes(i,2) = subplot(nStates,3,count+1);
%     all_axes(i,3) = subplot(nStates,3,count+2);
%     count = count+3;
% end
% 
% 
% TLag = data_acorr.Params.TLag;
% for i = 1:nStates
%     cur_state = char(all_states(i));
%     ax1 = all_axes(i,1);
%     ax1.YLabel.String = cur_state;
%     ax1.XLabel.String = 'AutoCorr CBV';
%     ax1.XLim = [TLag(1) TLag(end)];
%     ax1.YLim = [-.5 1];
%     hold(ax1,'on');
%     grid(ax1,'on');
% 
%     ax2 = all_axes(i,2);
%     ax2.YLabel.String = cur_state;
%     ax2.XLabel.String = 'AutoCorr LFP';
%     ax2.XLim = [TLag(1) TLag(end)];
%     ax2.YLim = [-.5 1];
%     grid(ax2,'on');
%     hold(ax2,'on');
% 
%     ax3 = all_axes(i,3);
%     ax3.YLabel.String = cur_state;
%     ax3.XLabel.String = 'CrossCorr LFP-CBV';
%     ax3.XLim = [TLag(1) TLag(end)];
%     ax3.YLim = [-.5 1];
%     grid(ax3,'on');
%     hold(ax3,'on');
% 
%     alpha_value = .5;
%     linewidth = 2;
% 
%     for j = 1:nAnimals
%         cur_animal = char(all_animals(j));
%         % AutoCorr Whole-reg
%         index_keep = find(strcmp(S.state,cur_state).*strcmp(S.animal,cur_animal)==1);
%         ACorr_mean = mean(S.ACorr(index_keep,:),1,'omitnan');
%         ACorr_std = std(S.ACorr(index_keep,:),[],1,'omitnan');
%         nSamples = sum(~isnan(S.ACorr(index_keep,:)),1);
%         ACorr_sem = ACorr_std./sqrt(nSamples);
% 
%         ACorr2_mean = mean(S.ACorr2(index_keep,:),1,'omitnan');
%         ACorr2_std = std(S.ACorr2(index_keep,:),[],1,'omitnan');
%         nSamples = sum(~isnan(S.ACorr2(index_keep,:)),1);
%         ACorr2_sem = ACorr2_std./sqrt(nSamples);
% 
%         XCorr_mean = mean(S.XCorr(index_keep,:),1,'omitnan');
%         XCorr_std = std(S.XCorr(index_keep,:),[],1,'omitnan');
%         nSamples = sum(~isnan(S.XCorr(index_keep,:)),1);
%         XCorr_sem = XCorr_std./sqrt(nSamples);
% 
%         px_data = [TLag,fliplr(TLag)];
%         py_data = [ACorr_mean+ACorr_sem,fliplr(ACorr_mean-ACorr_sem)];
%         patch('XData',px_data,'YData',py_data,'FaceColor',g_colors(j,:),'EdgeColor','none',...
%             'Parent',ax1,'Visible','on','FaceAlpha',alpha_value);
%         line('XData',TLag,'YData',ACorr_mean,'Parent',ax1,'Color',g_colors(j,:),'Linewidth',linewidth);
% 
%         px_data = [TLag,fliplr(TLag)];
%         py_data = [ACorr2_mean+ACorr2_sem,fliplr(ACorr2_mean-ACorr2_sem)];
%         patch('XData',px_data,'YData',py_data,'FaceColor',g_colors(j,:),'EdgeColor','none',...
%             'Parent',ax2,'Visible','on','FaceAlpha',alpha_value);
%         line('XData',TLag,'YData',ACorr2_mean,'Parent',ax2,'Color',g_colors(j,:),'Linewidth',linewidth);
% 
%         px_data = [TLag,fliplr(TLag)];
%         py_data = [XCorr_mean+XCorr_sem,fliplr(XCorr_mean-XCorr_sem)];
%         patch('XData',px_data,'YData',py_data,'FaceColor',g_colors(j,:),'EdgeColor','none',...
%             'Parent',ax3,'Visible','on','FaceAlpha',alpha_value);
%         line('XData',TLag,'YData',XCorr_mean,'Parent',ax3,'Color',g_colors(j,:),'Linewidth',linewidth);
%     end
% 
% end
% 
% end