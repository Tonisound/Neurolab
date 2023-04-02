function f1 = figure_Ripple_Imaging(handles,val,str_regions)
% (Figure) Displays fUS imaging sequence associated with ripples

% close all;
global FILES CUR_FILE DIR_SAVE DIR_FIG DIR_STATS IM;
% if nargin<3
%     str_tag = [];
%     str_group = [];
%     str_regions = [];
%     str_traces = [];
% end

recording_name = FILES(CUR_FILE).nlab;

if exist(fullfile(DIR_SAVE,recording_name,'RippleEvents.mat'),'file')
    data_ripples = load(fullfile(DIR_SAVE,recording_name,'RippleEvents.mat'));
    channel_id = data_ripples.channel_ripple;
    band_name = 'ripple';
    ripples_abs = data_ripples.ripples_abs;
    mean_dur = mean(ripples_abs(:,4),1,'omitnan');
    mean_freq = mean(ripples_abs(:,5),1,'omitnan');
    mean_p2p = mean(ripples_abs(:,6),1,'omitnan');
    fprintf('File Loaded [%s].\n',fullfile(DIR_SAVE,recording_name,'RippleEvents.mat'));
else
    errordlg('Missing File [%s].',fullfile(DIR_SAVE,recording_name,'RippleEvents.mat'));
    return;
end

channel_raw = strcat('LFP_',channel_id);
channel1 = strcat('LFP-',band_name,'_',channel_id);

% all_channels_2 = {'RetrosplenialCortex';'[SR]HippocampalFormation'};%;'[SR]Thalamus'
d_channels = dir(fullfile(DIR_SAVE,recording_name,'Sources_fUS','[SR]*.mat'));
d_channels = d_channels(arrayfun(@(x) ~strcmp(x.name(1),'.'),d_channels));
ind_leftright = contains({d_channels(:).name}','-L.mat')+contains({d_channels(:).name}','-R.mat');
d_channels =d_channels(ind_leftright==0);
% [ind_channels,v] = listdlg('Name','Region Selection','PromptString','Select Regions to display',...
%     'SelectionMode','multiple','ListString',{d_channels(:).name}','InitialValue',1,'ListSize',[300 500]);
% if v==0
%     return;
% end
ind_channels = 1:length(d_channels);
all_channels_2 = strrep({d_channels(ind_channels).name}','.mat','');

n_channels = length(all_channels_2);
label1 = strrep(channel1,'_','-');
% label1 = strcat('[LFP]',label1);
all_labels_2 = strrep(all_channels_2,'_','-');
all_labels_2 = strrep(all_labels_2,'[SR]','');
all_labels_2 = strcat('[fUS]',all_labels_2);

timegroup = 'NREM';
t_step = .1;
markersize = 3;
face_color = [0.9300    0.6900    0.1900];
face_alpha = .5 ;
g_colors = get_colors(n_channels+1,'jet');

% Loading time reference
data_tr = load(fullfile(DIR_SAVE,recording_name,'Time_Reference.mat'));
% Loading atlas
data_atlas = load(fullfile(DIR_SAVE,recording_name,'Atlas.mat'));
switch data_atlas.AtlasName
    case 'Rat Coronal Paxinos'
        atlas_name = sprintf('AP=%.2fmm',data_atlas.AP_mm);
    case 'Rat Sagittal Paxinos'
        atlas_name = sprintf('ML=%.2fmm',data_atlas.ML_mm);
end

% Loading time groups
data_tg = load(fullfile(DIR_SAVE,recording_name,'Time_Groups.mat'));
ind_group = strcmp(data_tg.TimeGroups_name,timegroup);
if isempty(ind_group)
    warning('Time Group not found [%s-%s]',recording_name,timegroup);
    return;
end
S = data_tg.TimeGroups_S(ind_group);
temp = datenum(S.TimeTags_strings(:,1));
t_start = (temp-floor(temp))*24*3600;
temp = datenum(S.TimeTags_strings(:,2));
t_end = (temp-floor(temp))*24*3600;

% Loading channels
d_raw = dir(fullfile(DIR_SAVE,recording_name,'*',strcat(channel_raw,'.mat')));
d1 = dir(fullfile(DIR_SAVE,recording_name,'*',strcat(channel1,'.mat')));
d2 = [];
for i = 1:n_channels
    channel2 = char(all_channels_2(i,:));
    d2 = [d2;dir(fullfile(DIR_SAVE,recording_name,'*',strcat(channel2,'.mat')))];
end
% Loading spectrogramm
d_spectro = dir(fullfile(DIR_STATS,'Wavelet_Analysis',recording_name,'*',strcat(recording_name,'*',channel_raw,'.mat')));

if isempty(d_raw)
    warning('Channel not found [%s-%s]',recording_name,channel_raw);
    return;
else
    data_raw = load(fullfile(d_raw.folder,d_raw.name));
    Xraw = (data_raw.x_start:data_raw.f:data_raw.x_end)';
    Yraw = data_raw.Y;
end

if isempty(d1)
    warning('Channel not found [%s-%s]',recording_name,channel1);
    return;
else
    data_1 = load(fullfile(d1.folder,d1.name));
    X1 = (data_1.x_start:data_1.f:data_1.x_end)';
    Y1 = data_1.Y;
end

if isempty(d2)
    warning('Channel not found [%s-%s]',recording_name,channel2);
    return;
else
    Y2 = [];
    for i = 1:n_channels
        data_2 = load(fullfile(d2(i).folder,d2(i).name));
        X2 = data_tr.time_ref.Y;
        Y2 = [Y2,data_2.Y];
    end
end

% Getting pixel activity
Y3 = reshape(IM,[size(IM,1)*size(IM,2) size(IM,3)])';

if isempty(d_spectro)
    warning('Spectrogram not found [%s-%s]',recording_name,channel_raw);
    return;
else
    data_spectro = load(fullfile(d_spectro.folder,d_spectro.name));
end

% Interpolation
Xq = (data_tr.time_ref.Y(1):t_step:data_tr.time_ref.Y(end))';
% Y1q = interp1(X1,Y1,Xq);
Y2q = interp1(X2,Y2,Xq);
Y3q = interp1(X2,Y3,Xq);

% Restricting time frames and Z-scoring
X_restrict = zeros(size(Xq));
for k=1:length(S.Name)
    temp = sign((Xq-t_start(k)).*(Xq-t_end(k)));
    X_restrict = X_restrict+(temp<0);
end
% Removing NaN frames
X_NaN = (sum(isnan(Y2q),2))>0;
X_restrict(X_NaN==1)=0;

% Xq = Xq(X_restrict==1);
% Y1q = Y1q(X_restrict==1);
% Y2q = Y2q(X_restrict==1,:);
Xq(X_restrict==0) = NaN;
% Y1q(X_restrict==0) = NaN;
Y2q(X_restrict==0,:) = NaN;
Y3q(X_restrict==0,:) = NaN;


% % Restricting ripples
% column_sort = 6; % 4 duration, 5 frequency, 6 p2p amplitude;
% ratio_keep = .1;
% [~,ind_sorted] = sort(ripples_abs(:,column_sort),'descend');
% ripples_abs_sorted = ripples_abs(ind_sorted,:);
% index_keep = 1:round(ratio_keep*size(ripples_abs,1));
% % index_keep = round(ratio_keep*size(ripples_abs,1)):size(ripples_abs,1);
% ripples_abs = ripples_abs_sorted(index_keep,:);
mean_dur = mean(ripples_abs(:,4),1,'omitnan');
mean_freq = mean(ripples_abs(:,5),1,'omitnan');
mean_p2p = mean(ripples_abs(:,6),1,'omitnan');


% Plotting
f1=figure;
f1.UserData.success = false;
f1.Name = sprintf(strcat('[%s]%s[%s-%s][Ripples Means:%.1fsec-%1.fHz-%1.f]'),atlas_name,strrep(recording_name,'_nlab',''),band_name,channel_id,mean_dur,mean_freq,mean_p2p);
colormap(f1,'jet');


mP = uipanel('Units','normalized',...
    'Position',[0 0 1 1],...
    'bordertype','etchedin',...
    'Tag','MainPanel',...
    'Parent',f1);
tabgp = uitabgroup('Units','normalized',...
    'Position',[0 0 1 1],...
    'Parent',mP,...
    'Tag','TabGroup');
tab1 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Dynamics',...
    'Tag','FirstTab');
tab2 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Synthesis',...
    'Tag','SecondTab');
tab3 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Regions',...
    'Tag','ThirdTab');
tab4 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Trials',...
    'Tag','FourthTab');
tab5 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Sequence',...
    'Tag','FifthTab');
% tab6 = uitab('Parent',tabgp,...
%     'Units','normalized',...
%     'Title','Tab6',...
%     'Tag','SixthTab');

ax1 = subplot(411,'parent',tab1);
hold(ax1,'on');
plot(Xraw,Yraw,'Color','k','Parent',ax1);
% plot(data_spectro.X_trace,data_spectro.Y_trace,'ro','Parent',ax1)
ax1.Title.String = 'Raw trace LFP';
n_iqr1 = 4;
ax1.YLim = [median(Yraw(:))-n_iqr1*iqr(Yraw(:)),median(Yraw(:))+n_iqr1*iqr(Yraw(:))];

ax2 = subplot(412,'parent',tab1);
% Correction
exp_cor = .5;
t_gauss = .1;
n_iqr2 = 1.5;
correction = repmat((data_spectro.freqdom(:).^exp_cor),1,size(data_spectro.Cdata_sub,2));
correction = correction/correction(end,1);
Cdata_corr = data_spectro.Cdata_sub.*correction;
%Gaussian smoothing
step = t_gauss*round(1/median(diff(data_spectro.Xdata_sub)));
Cdata_smooth = imgaussfilt(Cdata_corr,[1 step]);
Cdata = Cdata_smooth;

hold(ax2,'on');
imagesc('XData',data_spectro.Xdata_sub,'YData',data_spectro.freqdom,'CData',Cdata,'HitTest','off','Parent',ax2);
ax2.CLim = [median(Cdata(:))-n_iqr2*iqr(Cdata(:)),median(Cdata(:))+n_iqr2*iqr(Cdata(:))];
ax2.YLim = [data_spectro.freqdom(1),data_spectro.freqdom(end)];

ax3 = subplot(413,'parent',tab1);
hold(ax3,'on');
% plot(Xq,Y1q,'Color',[.5 .5 .5],'Marker','.','MarkerSize',markersize,'Parent',ax3);
plot(X1,Y1,'Color',[.5 .5 .5],'Parent',ax3);
ax3.Title.String = 'Filtered trace (Ripple band 150-300 Hz)';
% legend(ax3,cat(1,label1,all_labels_2))
n_iqr3 = 10;
ax3.YLim = [median(Y1(:))-n_iqr3*iqr(Y1(:)),median(Y1(:))+n_iqr3*iqr(Y1(:))];

ax4 = subplot(414,'parent',tab1);
hold(ax4,'on');
for i = 1:n_channels
%     plot(Xq,Y2q(:,i),'Color',g_colors(i+1,:),'Marker','.','MarkerSize',markersize,'Parent',ax4);
    plot(Xq,Y2q(:,i),'Color',g_colors(i+1,:),'Parent',ax4);
end
ax4.Title.String = 'CBV traces';
% legend(ax4,all_labels_2);

f1_axes=[ax1;ax2;ax3;ax4];
linkaxes(f1_axes,'x');
ax1.XLim = [data_tr.time_ref.Y(1) data_tr.time_ref.Y(end)];

% Displaying ripples
for i=1:size(ripples_abs,1)
    ax = f1_axes(1);
    
    l1 = line('XData',[ripples_abs(i,1) ripples_abs(i,1)],'YData',[ax.YLim(1) ax.YLim(2)],'LineWidth',1,'LineStyle','-','Color','g','Parent',ax,'Tag','EventLine','HitTest','off');
    l2 = line('XData',[ripples_abs(i,2) ripples_abs(i,2)],'YData',[ax.YLim(1) ax.YLim(2)],'LineWidth',1,'LineStyle','-','Color','b','Parent',ax,'Tag','EventLine','HitTest','off');
    l3 = line('XData',[ripples_abs(i,3) ripples_abs(i,3)],'YData',[ax.YLim(1) ax.YLim(2)],'LineWidth',1,'LineStyle','-','Color','r','Parent',ax,'Tag','EventLine','HitTest','off');
%     l1.Color(4) = .5;
%     l2.Color(4) = .5;
%     l3.Color(4) = .5;
end
ax.Title.String = strcat(ax.Title.String,sprintf(' [%d ripples events]',size(ripples_abs,1)));ax.Title.String = strcat(ax.Title.String,sprintf(' [%d ripples events]',size(ripples_abs,1)));

sb = copyobj(handles.ScaleButton,f1);
mb =copyobj(handles.MinusButton,f1);
pb = copyobj(handles.PlusButton,f1);
rb = copyobj(handles.RescaleButton,f1);
bb = copyobj(handles.BackButton,f1);
skb = copyobj(handles.SkipButton,f1);
tb = copyobj(handles.TagButton,f1);
ptb = copyobj(handles.prevTagButton,f1);
ntb = copyobj(handles.nextTagButton,f1);

e2 = uicontrol('Units','normalized','Parent',f1,'Style','edit','ToolTipString','Start Time','Tag','Edit2','String','');
e2.Position = [sb.Position(1) sb.Position(2)+sb.Position(4) sb.Position(3) sb.Position(4)];
% e2.Callback = {@e1_Callback,all_axes_control};
e3 = uicontrol('Units','normalized','Parent',f1,'Style','edit','ToolTipString','End Time','Tag','Edit3','String','');
e3.Position = [e2.Position(1) e2.Position(2)+e2.Position(4) e2.Position(3) e2.Position(4)];
% e3.Callback = {@e1_Callback,all_axes_control};

edits = [e2;e3];
ax_control = f1_axes(1);
set(sb,'Callback',{@template_buttonScale_Callback,ax_control});
set(ptb,'Callback',{@template_prevTag_Callback,tb,ax_control,edits});
set(ntb,'Callback',{@template_nextTag_Callback,tb,ax_control,edits});
set(pb,'Callback',{@template_buttonPlus_Callback,ax_control,edits});
set(mb,'Callback',{@template_buttonMinus_Callback,ax_control,edits});
set(rb,'Callback',{@template_buttonRescale_Callback,ax_control,edits});
set(skb,'Callback',{@template_buttonSkip_Callback,ax_control,edits});
set(bb,'Callback',{@template_buttonBack_Callback,ax_control,edits});
set(tb,'Callback',{@template_button_TagSelection_Callback,ax_control,edits,'single'});

set(f1,'Units','normalized','OuterPosition',[0 0 1 1]);
fprintf('>> Process 1/5 done [%s].\n',tab1.Title);

% Computing ripple averages and fUS averages
t_before = -1;           % seconds
t_after = 5;           % seconds
sampling_fus = 10;      % Hz
sampling_lfp = 1000;    % Hz
t_bins_fus  = (t_before:1/sampling_fus:t_after)';
t_bins_lfp  = (t_before:1/sampling_lfp:t_after)';

% Interpolate fUS
t_rip_ref = ripples_abs(:,2);
n_events = length(t_rip_ref);
Xq_rip_fus = [];
for i =1:n_events
    Xq_rip_fus = [Xq_rip_fus;t_rip_ref(i)+t_bins_fus];
end
Y2q_rip = (interp1(X2,Y2,Xq_rip_fus))';
Y3q_rip = (interp1(X2,Y3,Xq_rip_fus))';

% Interpolate LFP
Xq_rip_lfp = [];
for i =1:n_events
    Xq_rip_lfp = [Xq_rip_lfp;t_rip_ref(i)+t_bins_lfp];
end
Yraw_rip = interp1(Xraw,Yraw,Xq_rip_lfp);
Y1_rip = interp1(X1,Y1,Xq_rip_lfp);
Cdata_rip = (interp1(data_spectro.Xdata_sub,Cdata',Xq_rip_lfp))';

% Reshaping fUS
% Xq_rip_fus_ = reshape(Xq_rip_fus,[length(t_bins_fus) n_events]);
Y2q_rip_ = reshape(Y2q_rip,[size(Y2q_rip,1) length(t_bins_fus) n_events]);
Y3q_rip_ = reshape(Y3q_rip,[size(Y3q_rip,1) length(t_bins_fus) n_events]);


% Reshaping LFP
% Xq_rip_lfp_ = reshape(Xq_rip_lfp,[length(t_bins_lfp) n_events]);
Yraw_rip_ = reshape(Yraw_rip,[length(t_bins_lfp) n_events]);
Y1_rip_ = reshape(Y1_rip,[length(t_bins_lfp) n_events]);
Cdata_rip_ = reshape(Cdata_rip,[size(Cdata_rip,1) length(t_bins_lfp) n_events]);


% Baseline extraction and normalization
t_baseline_start = -1;           % seconds
t_baseline_end = 0;           % seconds
ind_baseline  = find((t_bins_fus-t_baseline_start).*(t_bins_fus-t_baseline_end)<=0);
Y2q_rip_baseline = mean(Y2q_rip_(:,ind_baseline,:),2,'omitnan');
Y2q_rip_normalized = Y2q_rip_-repmat(Y2q_rip_baseline,[1 size(Y2q_rip_,2) 1]);
Y3q_rip_baseline = mean(Y3q_rip_(:,ind_baseline,:),2,'omitnan');
Y3q_rip_normalized = Y3q_rip_-repmat(Y3q_rip_baseline,[1 size(Y3q_rip_,2) 1]);
Y3q_rip_mean = mean(Y3q_rip_normalized,3,'omitnan');
Y3q_rip_reshaped = reshape(Y3q_rip_mean,[size(IM,1) size(IM,2) length(t_bins_fus)]);

% Plotting
% f2=figure;
% f2.Name = sprintf(strcat('[%s]%s[%s-%s-synthesis]'),atlas_name,strrep(recording_name,'_nlab',''),band_name,channel_id);
% colormap(f2,'jet');

ax1 = subplot(321,'parent',tab2);
hold(ax1,'on');
for i=1:n_events
    l=line('XData',t_bins_lfp,'YData',Yraw_rip_(:,i),'Color','k','LineWidth',.1,'Parent',ax1);
    l.Color(4)=.5;
end
line('XData',t_bins_lfp,'YData',mean(Yraw_rip_,2,'omitnan'),'Color','r','Parent',ax1);
ax1.Title.String = 'Raw trace LFP';
n_iqr = 4;
data_iqr = Yraw_rip(~isnan(Yraw_rip));
ax1.YLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];

ax2 = subplot(323,'parent',tab2);
hold(ax2,'on');
for i=1:n_events
    l=line('XData',t_bins_lfp,'YData',Y1_rip_(:,i),'Color',[.5 .5 .5],'LineWidth',.1,'Parent',ax2);
    l.Color(4)=.5;
end
line('XData',t_bins_lfp,'YData',mean(Y1_rip_,2,'omitnan'),'Color','r','Parent',ax2);
ax2.Title.String = 'Filtered trace LFP';
n_iqr= 20;
data_iqr = Y1_rip_(~isnan(Y1_rip_));
ax2.YLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
ax2.XLim = [-.1 .5];


% Spectrogram
ax3 = subplot(325,'parent',tab2);
hold(ax3,'on');
Cdata_mean = mean(Cdata_rip_,3,'omitnan');
imagesc('XData',t_bins_lfp,'YData',data_spectro.freqdom,'CData',Cdata_mean,'HitTest','off','Parent',ax3);

n_iqr= 2;
data_iqr = Cdata_mean(~isnan(Cdata_mean));
ax3.CLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
ax3.YLim = [data_spectro.freqdom(1),data_spectro.freqdom(end)];
ax3.XLim = [t_bins_lfp(1),t_bins_lfp(end)];
ax3.Title.String = 'Mean Spectrogram';


% fUS
ax4 = subplot(122,'parent',tab2);
hold(ax4,'on');
Y2q_rip_mean = mean(Y2q_rip_normalized,3,'omitnan');
imagesc('XData',t_bins_fus,'YData',1:length(all_labels_2),'CData',Y2q_rip_mean,'HitTest','off','Parent',ax4);
n_iqr= 6;
data_iqr = Y2q_rip_mean(~isnan(Y2q_rip_mean));
% ax4.CLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
ax4.CLim = [median(data_iqr(:))-2,median(data_iqr(:))+5];
ax4.YLim = [.5 length(all_labels_2)+.5];
ax4.XLim = [t_bins_fus(1),t_bins_fus(end)];
ax4.YTick = 1:length(all_labels_2);
ax4.YTickLabel = all_labels_2;
ax4.Title.String = 'Mean Regions fUS';
ax4.FontSize = 6;
colorbar(ax4,'eastoutside');

f2_axes=[ax1;ax2;ax3;ax4];
% set(f2,'Units','normalized','OuterPosition',[0 0 1 1]);
fprintf('>> Process 2/5 done [%s].\n',tab2.Title);

% linkaxes(f1_axes,'x');
% ax1.XLim = [data_tr.time_ref.Y(1) data_tr.time_ref.Y(end)];


% f3=figure;
% f3.Name = sprintf(strcat('[%s]%s[%s-%s-regions]'),atlas_name,strrep(recording_name,'_nlab',''),band_name,channel_id);
% set(f3,'Units','normalized','OuterPosition',[0 0 1 1]);
% colormap(f3,'jet');
n_col = 4 ;
n_rows = ceil(n_channels/n_col);
f3_axes=[];

for i=1:n_channels
    ax = subplot(n_rows,n_col,i,'parent',tab3);
    hold(ax,'on');
    YData = squeeze(Y2q_rip_normalized(i,:,:));
    for j=1:n_events
        try
            l=line('XData',t_bins_fus,'YData',YData(:,j),'Color',g_colors(i,:),'LineWidth',.1,'Parent',ax);
        catch
            l=line('XData',t_bins_fus,'YData',YData(:,j),'Color',g_colors(end,:),'LineWidth',.1,'Parent',ax);
        end
        l.Color(4)=.5;
    end
    YData_mean = mean(YData,2,'omitnan');
    l=line('XData',t_bins_fus,'YData',YData_mean,'Color','r','LineWidth',2,'Parent',ax);
    n_samples = sum(~isnan(YData),2);
    ebar_data = std(YData,0,2,'omitnan')./sqrt(n_samples);
    errorbar(t_bins_fus,YData_mean,ebar_data,'Color',[.5 .5 .5],...
        'linewidth',1,'linestyle','none',...
        'Parent',ax,'Visible','on','Tag','ErrorBar');
    uistack(l,'top');
    ax.XLim = [t_bins_fus(1),t_bins_fus(end)];
    
    n_iqr= 2;
    data_iqr = YData_mean(~isnan(YData_mean));
%     ax.YLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
    ax.YLim = [median(data_iqr(:))-5,median(data_iqr(:))+10];
    ax.Title.String = char(all_labels_2(i));
    f3_axes=[f3_axes;ax];

end
fprintf('>> Process 3/5 done [%s].\n',tab3.Title);


% f4=figure;
% f4.Name = sprintf(strcat('[%s]%s[%s-%s-trials]'),atlas_name,strrep(recording_name,'_nlab',''),band_name,channel_id);
% set(f4,'Units','normalized','OuterPosition',[0 0 1 1]);
% colormap(f4,'jet');

f4_axes=[];

for i=1:n_channels
    ax = subplot(n_rows,n_col,i,'parent',tab4);
    hold(ax,'on');
    YData = squeeze(Y2q_rip_normalized(i,:,:));
    imagesc('XData',t_bins_fus,'YData',1:n_events,'CData',YData','Parent',ax)
    
    n_samples = sum(~isnan(YData),2);
    ax.XLim = [t_bins_fus(1),t_bins_fus(end)];
    ax.YLim = [.5,n_events+.5];
    ax.YDir = 'reverse';
    colorbar(ax,'eastoutside');
    
    ax.YTick= 1:10:n_events;
    ax.YTickLabel= t_rip_ref(1:10:end);
    ax.FontSize = 6;
    
    n_iqr= 3;
    data_iqr = YData(~isnan(YData));
%     ax.CLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
    ax.CLim = [-10,30];
    
    ax.Title.String = char(all_labels_2(i));
    f4_axes=[f4_axes;ax];

end
fprintf('>> Process 4/5 done [%s].\n',tab4.Title);


% f5=figure;
% f5.Name = sprintf(strcat('[%s]%s[%s-%s-sequence]'),atlas_name,strrep(recording_name,'_nlab',''),band_name,channel_id);
% set(f5,'Units','normalized','OuterPosition',[0 0 1 1]);
% colormap(f5,'jet');

f5_axes=[];
n_iqr= 3;
data_iqr = Y3q_rip_reshaped(~isnan(Y3q_rip_reshaped));

temp=1:length(t_bins_fus);
index_t_bins_fus = temp(1:end-1);%(1:2:end-1);

for i=index_t_bins_fus
    
    n=ceil(sqrt(length(index_t_bins_fus)));
    ax = subplot(n,n,i,'parent',tab5);
    hold(ax,'on');
    imagesc(Y3q_rip_reshaped(:,:,i),'Parent',ax);
    
    ax.Title.String = sprintf('t= %.1f s',t_bins_fus(i));
    
%     ax.CLim = [median(data_iqr(:))-n_iqr*iqr(data_iqr(:)),median(data_iqr(:))+n_iqr*iqr(data_iqr(:))];
    ax.CLim = [-5,10];
    ax.XLim = [.5 size(IM,2)+.5];
    ax.YLim = [.5 size(IM,1)+.5];
    
    set(ax,'XTick',[],'XTickLabel',[],'YTick',[],'YTickLabel',[]);
    ax.YDir = 'reverse';
    if i == index_t_bins_fus(end)
        cbar = colorbar(ax,'eastoutside');
        cbar.Position = [.94 .01 .01 .15];
    end
    f5_axes=[f5_axes;ax];
end

n_col = 10 ;
n_rows = ceil(length(f5_axes)/n_col);
eps1=.01;
eps2=.01;

for i=1:length(f5_axes)
    f5_axes(i).Position = get_position(n_rows,n_col,i,[.01,.07,.01;.01,.01,.02]);
end

fprintf('>> Process 5/5 done [%s].\n',tab5.Title);

load('Preferences.mat','GTraces');

% Saving Stats
flag_save_stats = false;
if flag_save_stats
    save_dir = fullfile(DIR_STATS,'Ripple_Imaging',recording_name);
    if ~isfolder(save_dir)
        mkdir(save_dir);
    end
    filename_save = sprintf(strcat('%s_Ripple-Imaging.mat'),recording_name);
    
    freqdom=data_spectro.freqdom;
    % save(fullfile(save_dir,filename_save),'recording_name','band_name','channel_id',...
    %     'Yraw_rip_','Y1_rip_','Cdata_rip_','Y2q_rip_','Y2q_rip_normalized',...
    %     't_baseline_start','t_baseline_end','freqdom',...
    %     't_before','t_after','sampling_fus','sampling_lfp','t_bins_fus','t_bins_lfp','-v7.3');
    save(fullfile(save_dir,filename_save),'recording_name','band_name','channel_id',...
        't_baseline_start','t_baseline_end','freqdom',...
        't_before','t_after','sampling_fus','sampling_lfp','t_bins_fus','t_bins_lfp','-v7.3');
end

% Saving Tabs
flag_save_figs = false;
if flag_save_figs
    save_dir = fullfile(DIR_FIG,'Ripple_Imaging',recording_name);
    if ~isfolder(save_dir)
        mkdir(save_dir);
    end
    
    tabgp.SelectedTab = tab1;
    saveas(f1,fullfile(save_dir,strcat(f1.Name,tab1.Title,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
    fprintf('Tab %s saved in [%s].\n',tab1.Title,save_dir);
    
    tabgp.SelectedTab = tab2;
    saveas(f1,fullfile(save_dir,strcat(f1.Name,tab2.Title,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
    fprintf('Tab %s saved in [%s].\n',tab2.Title,save_dir);
    
    tabgp.SelectedTab = tab3;
    saveas(f1,fullfile(save_dir,strcat(f1.Name,tab3.Title,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
    fprintf('Tab %s saved in [%s].\n',tab3.Title,save_dir);
    
    tabgp.SelectedTab = tab4;
    saveas(f1,fullfile(save_dir,strcat(f1.Name,tab4.Title,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
    fprintf('Tab %s saved in [%s].\n',tab4.Title,save_dir);
    
    tabgp.SelectedTab = tab5;
    saveas(f1,fullfile(save_dir,strcat(f1.Name,tab5.Title,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
    fprintf('Tab %s saved in [%s].\n',tab5.Title,save_dir);
end


% Saving Movie
flag_save_movie = true;
if flag_save_movie
    
    save_dir = fullfile(DIR_FIG,'Ripple_Imaging',recording_name);
    if ~isfolder(save_dir)
        mkdir(save_dir);
    end
    work_dir = fullfile(DIR_FIG,'Ripple_Imaging',recording_name,'Frames');
    if isfolder(work_dir)
        rmdir(work_dir,'s');
    end
    mkdir(work_dir);
    
    f2 = figure();
    for i = 1:length(f5_axes)
        ax = f5_axes(i);
        ax2 = copyobj(ax,f2);
        ax2.Title.String = strrep(ax2.Title.String,'t','Time from Ripple Peak');
        colorbar(ax2,'eastoutside');
        ax2.Position = [.05 .05 .85 .9];
        pic_name = sprintf(strcat('%s_Ripple-Imaging_%03d.mat'),recording_name,i);
        l = line('XData',data_atlas.line_x,'YData',data_atlas.line_z,'Tag','AtlasMask',...
            'LineWidth',1,'Color','r','Parent',ax2);
        l.Color(4) = .25;
        saveas(f2,fullfile(work_dir,strcat(pic_name,GTraces.ImageSaveExtension)),GTraces.ImageSaveFormat);
        delete(ax2);
    end
    
    close(f2);
    video_name = sprintf(strcat('%s_Ripple-Imaging'),recording_name);
    save_video(work_dir,save_dir,video_name)
end

f1.UserData.success = true;

end
