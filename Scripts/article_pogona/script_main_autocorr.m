function script_main_autocorr()


load('Preferences.mat','GColors');


InfoFile =[{'20190730_P1-003_E_nlab'},{'DVR2'};...
    {'20190730_P1-004_E_nlab'},{'DVR2'};...
    {'20190731_P1-005_E_nlab'},{'DVR2'};...
    {'20190731_P2-008_E_nlab'},{'DVR4'};...
    {'20190731_P2-009_E_nlab'},{'DVR4'};...
    {'20190801_P2-011_E_nlab'},{'DVR4'};...
    {'20190927_P3-016_E_nlab'},{'DVRR4'};...
    {'20190927_P3-017_E_nlab'},{'DVRR4'};...
    {'20190927_P3-018_E_nlab'},{'DVRR4'};...
    {'20190927_P3-019_E_nlab'},{'DVRR4'};...
    {'20190930_P3-020_E_nlab'},{'DVRR4'};...
    {'20190930_P3-021_E_nlab'},{'DVRR4'};...
    {'20190930_P3-022_E_nlab'},{'DVRR4'};...
    {'20191003_P3-027_E_nlab'},{'DVRR4'};...
    {'20191003_P3-028_E_nlab'},{'DVRR4'};...
    {'20191003_P3-029_E_nlab'},{'DVRR4'};...
    {'20200715_P5-033_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-034_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-035_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-036_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-037_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-038_E_nlab'},{'DVR-PR2'};...
    {'20200716_P5-039_E_nlab'},{'DVR-PR2'};...
    {'20200717_P5-040_E_nlab'},{'DVR-PR2'};...
    {'20200717_P6-041_E_nlab'},{'DVR-PR2'};...
    {'20200717_P6-042_E_nlab'},{'DVR-PR2'};...
    {'20200717_P6-043_E_nlab'},{'DVR-PR2'};...
    {'20200718_P6-044_E_nlab'},{'DVR-PR2'};...
    {'20200718_P6-045_E_nlab'},{'DVR-PR2'};...
    {'20200719_P5-046_E_nlab'},{'DVR-PR2'};...
    {'20200719_P5-047_E_nlab'},{'DVR-PR2'};...
    {'20200720_P5-048_E_nlab'},{'DVR-PR2'};...
    {'20200720_P5-049_E_nlab'},{'DVR-PR2'};...
    {'20200721_P5-050_E_nlab'},{'DVR-PR2'};...
    {'20200721_P5-051_E_nlab'},{'DVR-PR2'};...
    {'20200722_P6-052_E_nlab'},{'DVR-PR2'};...
    {'20200722_P6-053_E_nlab'},{'DVR-PR2'};...
    {'20200723_P6-054_E_nlab'},{'DVR-PR2'};...
    {'20200723_P6-055_E_nlab'},{'DVR-PR2'};...
    {'20200724_P6-056_E_nlab'},{'DVR-PR2'};...
    {'20200725_P5-058_E_nlab'},{'DVR-PR2'};...
    {'20200726_P5-060_E_nlab'},{'DVR-PR2'};...
    {'20200726_P5-061_E_nlab'},{'DVR-PR2'}];


% InfoFile =[{'20240812_K1653_001_E_nlab'},{'000'};...
%     {'20240820_K1656_001_E_nlab'},{'000'};...
%     {'20240820_K1657_001_E_nlab'},{'000'}];
%
% InfoFile =[{'20190226_SD025_P401_R_nlab'},{'023'};...
%     {'20190226_SD025_P402_R_nlab'},{'023'};...
%     {'20190416_SD032_P101_R_nlab'},{'005'};...
%     {'20190416_SD032_P102_R_nlab'},{'005'};...
%     {'20190416_SD032_P103_R_nlab'},{'005'};...
%     {'20190416_SD032_P201_R_nlab'},{'005'};...
%     {'20190416_SD032_P202_R_nlab'},{'005'};...
%     {'20190416_SD032_P203_R_nlab'},{'005'};...
%     {'20190416_SD032_P301_R_nlab'},{'005'};...
%     {'20190416_SD032_P302_R_nlab'},{'005'};...
%     {'20190416_SD032_P303_R_nlab'},{'005'};...
%     {'20190416_SD032_P401_R_nlab'},{'005'};...
%     {'20190416_SD032_P402_R_nlab'},{'005'}];

% Parameters
Params.GColors = GColors;
Params.Fs = 1;
Params.WinSec = 300;
Params.StepSec = 10;
Params.MaxLagSec = 300;
Params.NormWinMin = 3;
Params.t_smooth = 30;
Params.nCol = 8; % Number Max Columns
Params.seed_save = '/Users/tonio/Desktop/XCorrPA';
Params.seed_nlab = '/Users/tonio/Documents/Antoine-fUSDataset/NEUROLAB/NLab_DATA';


flag_recompute = true;     % if True re-computes dynamics xcorr
flag_savefig = true;       % if True saves figure


% Compute Dynamic Xcorr
if flag_recompute
    Params.t_smooth = 30;
    Params.seed_save = '/Users/tonio/Desktop/XCorrPA[30]';
    compute_dynamic_xcorr(InfoFile,Params,false);
    compute_dynamic_xcorr(InfoFile,Params,true);
end
% Plot Dynamic Xcorr
if flag_savefig
    [XCorrMat_all,XCorrPeak_all] = plot_dynamic_xcorr(InfoFile,Params,false);
    [XCorrMat_all,XCorrPeak_all] = plot_dynamic_xcorr(InfoFile,Params,true);
end

% Compute Dynamic Xcorr
if flag_recompute
    Params.t_smooth = 10;
    Params.seed_save = '/Users/tonio/Desktop/XCorrPA[10]';
    compute_dynamic_xcorr(InfoFile,Params,false);
%     compute_dynamic_xcorr(InfoFile,Params,true);
end
% Plot Dynamic Xcorr
if flag_savefig
    [XCorrMat_all,XCorrPeak_all] = plot_dynamic_xcorr(InfoFile,Params,false);
%     [XCorrMat_all,XCorrPeak_all] = plot_dynamic_xcorr(InfoFile,Params,true);
end

end


function compute_dynamic_xcorr(InfoFile,Params,flag_crosscorr)

all_files = InfoFile(:,1);
all_refs = InfoFile(:,2);

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
    reference = char(all_refs(k));
    filepath = fullfile(seed_nlab,cur_file);
    temp = regexp(cur_file,'_','split');
    temp2 = regexp(char(temp(2)),'-','split');
    cur_animal = char(temp2(1));
    if ~flag_crosscorr
        folder_save = fullfile(seed_save,'AutoCorr',cur_animal);
    else
        folder_save = fullfile(seed_save,'CrossCorr',cur_animal);
    end
    mat_name = strcat(cur_file,'.mat');

    % Getting time
    data_t = load(fullfile(filepath,'Time_Reference.mat'));
    t_start = round(data_t.time_ref.Y(1));
    t_end = round(data_t.time_ref.Y(end));
    xq = t_start:1/Fs:t_end;

    % Selecting beta channels
    d_channels = dir(fullfile(filepath,'Sources_LFP','Power-beta_*.mat'));
    ind_channels = 1:length(d_channels);
    %     ind_channels = (1:4);
    all_channels={d_channels(ind_channels).name}';
    nChannels=size(all_channels,1);

    % Selecting regions
    d_regions = dir(fullfile(filepath,'Sources_fUS','*.mat'));
    ind_regions=1:length(d_regions);
    %     ind_regions = 1:0;
    all_regions={d_regions(ind_regions).name}';
    nRegions=size(all_regions,1);
    nTot = nChannels+nRegions;

    % Selecting reference
    % Building DataRef
    if flag_crosscorr
        d_ref = dir(fullfile(filepath,'Sources_LFP',['Power-beta_*',reference,'*.mat']));
        % Loading reference for xcorr
        if length(d_ref)==1
            data_ref = load(fullfile(filepath,'Sources_LFP',d_ref.name));
            v = data_ref.Y(:)';
            x = data_ref.x_start:data_ref.f:data_ref.x_end;
            DataRef = interp1(x,v,xq);
            % Smoothing
            DataRef = nanconv(DataRef,w,'same');
            label_ref = d_ref.name;
        elseif length(d_ref)>1
            warning('Multiple reference channels found. [%s]',filepath);
            continue;
        else
            warning('Missing reference channel [%s]',filepath);
            continue;
        end
    else
        DataRef = [];
        label_ref = [];
    end


    % Computing xcorr
    % XCorrMat_Channels = NaN(length(TWin),length(2*WinSec+1),nChannels);
    XCorrMat_Channels = [];
    thisPos_Channels = [];
    thisNeg_Channels = [];
    XCorrPeak_Channels = struct('MeanXcorr',[],'Pos',[],'Neg',[]);
    Data_Channels = NaN(nChannels,size(xq,2));
    
    all_labels = [];
    for i=1:nChannels

        % Getting label
        channel=char(all_channels(i));
        label = regexprep(channel,'.mat','');
        label = regexprep(label,'_','-');
        all_labels = [all_labels;{label}];

        % Loading Beta
        data_beta = load(fullfile(filepath,'Sources_LFP',channel));
        v = data_beta.Y(:)';
        x = data_beta.x_start:data_beta.f:data_beta.x_end;
        Data = interp1(x,v,xq);
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
    Data_Regions = NaN(nRegions,size(xq,2));

    for i=1:nRegions

        % Getting label
        region=char(all_regions(i));
        label = regexprep(region,'.mat','');
        label = regexprep(label,'_','-');
        all_labels = [all_labels;{label}];

        % Loading Region
        data_region = load(fullfile(filepath,'Sources_fUS',region));
        v = data_region.Y(:)';
        x = data_region.X(:)';
        Data = interp1(x,v,xq);
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
    fprintf('Saving data [%s]...',fullfile(folder_save,mat_name));
    save(fullfile(folder_save,mat_name),'Params','all_regions','all_channels','all_labels','label_ref',...
        'XCorrMat_Regions','XCorrPeak_Regions','XCorrMat_Channels','XCorrPeak_Channels',...
        'thisPos_Channels','thisNeg_Channels','thisPos_Regions','thisNeg_Regions',...
        'xq','Data_Channels','Data_Regions','DataRef','-v7.3');
    fprintf(' done.\n');
end

end


function [XCorrMat_all,XCorrPeak_all] = plot_dynamic_xcorr(InfoFile,Params,flag_crosscorr)

all_files = InfoFile(:,1);
all_refs = InfoFile(:,2);


% Parameters
GColors = Params.GColors;
Fs = Params.Fs;
WinSec = Params.WinSec;
StepSec = Params.StepSec;
MaxLagSec = Params.MaxLagSec;
NormWinMin = Params.NormWinMin;
seed_save = Params.seed_save;
seed_nlab = Params.seed_nlab;
nCol = Params.nCol; % Number Max Columns


for k=1:length(all_files)

    % Getting file info
    cur_file = char(all_files(k));
    reference = char(all_refs(k));
    filepath = fullfile(seed_nlab,cur_file);
    temp = regexp(cur_file,'_','split');
    temp2 = regexp(char(temp(2)),'-','split');
    cur_animal = char(temp2(1));
    if ~flag_crosscorr
        folder_save = fullfile(seed_save,'AutoCorr',cur_animal);
        folder_save2 = fullfile(seed_save,'AutoCorr');
    else
        folder_save = fullfile(seed_save,'CrossCorr',cur_animal);
        folder_save2 = fullfile(seed_save,'CrossCorr');
    end
    mat_name = strcat(cur_file,'.mat');

    % Getting time
    data_t = load(fullfile(filepath,'Time_Reference.mat'));
    t_start = round(data_t.time_ref.Y(1));
    t_end = round(data_t.time_ref.Y(end));
    xq = t_start:1/Fs:t_end;

    % Getting time groups
    data_tg = load(fullfile(filepath,'Time_Groups.mat'));
    

    % Selecting beta channels
    d_channels = dir(fullfile(filepath,'Sources_LFP','Power-beta_*.mat'));
    ind_channels = 1:length(d_channels);
    %     ind_channels = (1:4);
    all_channels={d_channels(ind_channels).name}';
    nChannels=size(all_channels,1);

    % Selecting regions
    d_regions = dir(fullfile(filepath,'Sources_fUS','Whole*.mat'));
    ind_regions=1:length(d_regions);
    %     ind_regions = 1:0;
    all_regions={d_regions(ind_regions).name}';
    nRegions=size(all_regions,1);
    nTot = nChannels+nRegions;

    % Selecting reference
    if flag_crosscorr
        d_ref = dir(fullfile(filepath,'Sources_LFP',['Power-beta_*',reference,'*.mat']));
        % Loading reference for xcorr
        if length(d_ref)==1
            data_ref = load(fullfile(filepath,'Sources_LFP',d_ref.name));
            v = data_ref.Y(:)';
            x = data_ref.x_start:data_ref.f:data_ref.x_end;
            DataRef = interp1(x,v,xq);
            label_ref = d_ref.name;
        elseif length(d_ref)>1
            warning('Multiple reference channels found. [%s]',filepath);
            continue;
        else
            warning('Missing reference channel [%s]',filepath);
            continue;
        end
    else
        DataRef = [];
        label_ref = [];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Saving Figure

    if ~isfile(fullfile(folder_save,mat_name))
        warning('Missing data file [%s]',fullfile(folder_save,mat_name));
        continue;
    else

        % Loading file
        fprintf('Loading data [%s]...',fullfile(folder_save,mat_name));
        data_mat = load(fullfile(folder_save,mat_name));
        %         data_mat = load(fullfile(folder_save,mat_name),'all_regions','all_channels','Params',...
        %             'XCorrMat_all','XCorrPeak_all','Data_all');

        Params = data_mat.Params;
        TLag=Params.TLag;
        TWin=Params.TWin;
        XCorrMat_all = NaN(length(TWin),length(TLag),nTot);
        thisPos_all = NaN(length(TWin),2,nTot);
        thisNeg_all = NaN(length(TWin),2,nTot);

        XCorrPeak_all = struct('MeanXcorr',[],'Pos',[],'Neg',[]);
        Data_Channels = NaN(nChannels,length(xq));
        for j=1:length(all_channels)
            index_channel = find(strcmp(data_mat.all_channels,all_channels(j))==1);
            XCorrMat_all(:,:,j) = data_mat.XCorrMat_Channels(:,:,index_channel);
            XCorrPeak_all(j) = data_mat.XCorrPeak_Channels(index_channel);
            Data_Channels(j,:) = data_mat.Data_Channels(index_channel,:);
            thisPos_all(:,:,j) = data_mat.thisPos_Channels(:,:,index_channel);
            thisNeg_all(:,:,j) = data_mat.thisNeg_Channels(:,:,index_channel);
        end
        Data_Regions = NaN(nChannels,length(xq));
        for j=1:length(all_regions)
            index_region = find(strcmp(data_mat.all_regions,all_regions(j))==1);
            XCorrMat_all(:,:,nChannels+j) = data_mat.XCorrMat_Regions(:,:,index_region);
            XCorrPeak_all(nChannels+j) = data_mat.XCorrPeak_Regions(index_region);
            Data_Regions(j,:) = data_mat.Data_Regions(index_region,:);
            thisPos_all(:,:,nChannels+j) = data_mat.thisPos_Regions(:,:,index_region);
            thisNeg_all(:,:,nChannels+j) = data_mat.thisNeg_Regions(:,:,index_region);
        end

        Data_all = [Data_Channels;Data_Regions];
        fprintf(' done.\n');
        xq = data_mat.xq;
        %             all_regions = data_mat.all_regions;
        %             all_channels = data_mat.all_channels;
        %             all_labels = data_mat.all_labels;
        %             label_ref = data_mat.label_ref;
        %             XCorrMat_all = data_mat.XCorrMat_all;
        %             XCorrPeak_all = data_mat.XCorrPeak_all;
        %             Data_all = data_mat.Data_all;
        %             DataRef = data_mat.DataRef;

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
        all_ax = gobjects(3,nTot);

        % Figures
        for index_fig = 1:nFigs
            all_f(index_fig) = figure;
            all_f(index_fig).Name = sprintf('%s-%03d',cur_file,index_fig);
        end
        count = 1;
        eps = .01;
        % Axes
        for i=1:nTot
            framepos = [(count-1)/nCol+eps  .05  1/nCol-2*eps  .9];
            all_ax(1,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)  framepos(2)+.2  0.75*framepos(3)   .7]);
            all_ax(2,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)+0.75*framepos(3)  framepos(2)+.2  0.25*framepos(3)   .7]);
            all_ax(3,i) = axes('Parent',all_f(ceil(i/nCol)),'Position',[framepos(1)  framepos(2)  0.75*framepos(3)   .15]);
            count=mod(count,nCol)+1;
        end

        % plot  map and mean xcorr with peaks
        for i=1:nTot
            label=char(all_labels(i));
            XCorrMat = XCorrMat_all(:,:,i);
            XCorrPeak = XCorrPeak_all(i);
            time_ticks = (900:900:xq(end))';
            time_ticks_label = datestr(time_ticks/(24*3600),'HH:MM');

            ax1=all_ax(1,i);
            % p = pcolor(TLag,TWin,XCorrMat,'Parent',ax1);
            % shading(ax1,'flat');
            YTime = (TWin+WinSec/2+xq(1));
            imagesc('XData',TLag,'YData',YTime,'CData',XCorrMat,'Parent',ax1);
            line('XData',thisPos_all(:,1,i),'YData',YTime,'LineStyle','none','Parent',ax1,...
                'Marker','o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none');
            line('XData',thisNeg_all(:,1,i),'YData',YTime,'LineStyle','none','Parent',ax1,...
                'Marker','x','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','none');
            
            % ax1.YLim = [YTime(1),YTime(end)];
            ax1.YLim = [xq(1),xq(end)];
            ax1.YDir = 'reverse';
            set(ax1,'YTick',time_ticks,'YTickLabel',time_ticks_label);

            % Adding peaks

            ax2=all_ax(2,i);
            line('XData',Data_all(i,:),'YData',xq,'Parent',ax2);
            ax2.XLim = [mean(Data_all(i,:),'omitnan')-1.5*std(Data_all(i,:),[],'omitnan') mean(Data_all(i,:),'omitnan')+3*std(Data_all(i,:),[],'omitnan')];
            ax2.YLim = [xq(1),xq(end)];
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

            ax3 = all_ax(3,i);
            grid(ax3,'on');
            line('XData',TLag,'YData',XCorrPeak.MeanXcorr,'Parent',ax3);
            line('XData',XCorrPeak.Pos(1),'YData',XCorrPeak.Pos(2),'Marker','o','Color','r','Parent',ax3);
            line('XData',XCorrPeak.Neg(1),'YData',XCorrPeak.Neg(2),'Marker','x','Color','r','Parent',ax3);
            if flag_crosscorr
                ax3.YLim = [-.5 .5];
            end
            text(-MaxLagSec,ax3.YLim(2)-.25,sprintf('Amp=%.2f',XCorrPeak.Pos(2)-XCorrPeak.Neg(2)),'Parent',ax3);
            text(-MaxLagSec,ax3.YLim(2)-.1,sprintf('Lag=%dsec',XCorrPeak.Pos(1)),'Parent',ax3);

            linkaxes([ax1;ax3],'x');
            ax1.XLim = [TLag(1),TLag(end)];
            ax1.Title.String = label;
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
            % exportgraphics(f,fullfile(folder_save,pic_name),'ContentType','vector');
            exportgraphics(f,fullfile(folder_save2,pic_name),'ContentType','vector');
            fprintf(' done.\n');           
            close(f);
        end
    end
end

end

