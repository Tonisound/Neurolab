function success = filter_accgyremg_extractenvelope(foldername,handles,val)
% Filter ACC,GYR,EMG channels into bands defined in Gfilt (Preferences.mat)
% Compute and smooth LFP power envelopes
% User can select bands and channels manually
% Selects only main channel (if specified) in batch mode

success = false;
load('Preferences.mat','GFilt');

% if val undefined, set val = 1 (default) user can select which channels to export
if nargin <3
    val = 1;
end

% Loading Configuration
if exist(fullfile(foldername,'Config.mat'),'file')
    data_config = load(fullfile(foldername,'Config.mat'));
else
    errordlg(sprintf('Missing File %s',fullfile(foldername,'Config.mat')));
    return;
end

% Time Reference loading
if exist(fullfile(foldername,'Time_Reference.mat'),'file')
    data_t = load(fullfile(foldername,'Time_Reference.mat'),'time_ref','length_burst','n_burst');
    time_ref = data_t.time_ref;
else
    errordlg(sprintf('Missing File %s',fullfile(foldername,'Time_Reference.mat')));
    return;
end

% Searching LFP channels in Sources_LFP folder
dir_e = dir(fullfile(foldername,'Sources_LFP','EMG_*.mat'));
dir_a = dir(fullfile(foldername,'Sources_LFP','ACC_*.mat'));
dir_g = dir(fullfile(foldername,'Sources_LFP','GYR_*.mat'));
dir_t = [dir_e;dir_a;dir_g];

if isempty(dir_t)
    errordlg(sprintf('No ACC/GYR/EMG traces_filter found in %s',foldername));
    return;
else
    channel_list = {dir_t(:).name}';
end

% % Initial selection
ind_emg = find(strcmp(channel_list,strcat('EMG_',data_config.File.mainemg,'.mat'))==1);
ind_acc = find(strcmp(channel_list,strcat('ACC_',data_config.File.mainacc,'.mat'))==1);
ind_selected = [ind_emg;ind_acc];
if isempty(ind_selected)
        ind_selected = 1:length(channel_list);
end
% asks for user input if val == 1
if val == 1
    % user mode
    [ind_lfp,v] = listdlg('Name','Channel Selection','PromptString','Select channels to export',...
        'SelectionMode','multiple','ListString',channel_list,'InitialValue',ind_selected,'ListSize',[300 500]);
else
    % batch mode
    ind_lfp = ind_selected;
    v = true;
end
% return if selection empty
if v==0 || isempty(ind_lfp)
    warning('No trace selected .\n');
    return;
else
    channel_list =  channel_list(ind_lfp);
end


% Saving struct
count = 0;
traces_filter = [];
% traces_filter = struct('ID',{},'shortname',{},'fullname',{},'parent',{},...
%     'X',{},'Y',{},'X_ind',{},'X_im',{},'Y_im',{},'nb_samples',{});
traces_envelope = struct('ID',{},'shortname',{},'fullname',{},'parent',{},...
    'X',{},'Y',{},'X_ind',{},'X_im',{},'Y_im',{},'nb_samples',{});

% Extracting bands for each channel
for j =1:length(channel_list)
    % loading
    str_channel = char(channel_list(j));
    data  = load(fullfile(foldername,'Sources_LFP',str_channel));
    Y = data.Y;
    X = (data.x_start:data.f:data.x_end)';
    fs = 1/data.f;
    
    % Select frequencies
    switch str_channel(1:3)
        case 'ACC'
            f1 = GFilt.acc_inf;
            f2 = GFilt.acc_sup;
            t_smooth  = GFilt.acc_smooth;
        case 'EMG'
            f1 = GFilt.emg_inf;
            f2 = GFilt.emg_sup;
            t_smooth  = GFilt.emg_smooth;
        case 'GYR'
            f1 = GFilt.gyr_inf;
            f2 = GFilt.gyr_sup;
            t_smooth  = GFilt.gyr_smooth;
    end
    
    % Pass-band filtering
    fprintf('Pass-band filtering %s [%.1f Hz; %.1f Hz]...',str_channel,f1,f2);
    [B,A]  = butter(1,[f1 f2]/(fs/2),'bandpass');
    Y_temp = filtfilt(B,A,Y);
    
    % Subsampling filter
    ftemp = 10*f2;
    if ftemp < fs
        X_filt = (X(1):1/ftemp:X(end))';
        Y_filt = interp1(X,Y_temp,X_filt);
    else
        X_filt = X;
        Y_filt = Y_temp;
    end
    
%     % Saving
    count = count+1;
    temp = regexp(strrep(str_channel,'.mat',''),'_','split');
%     traces_filter(count).ID = char(temp(2));
%     traces_filter(count).shortname = sprintf('LFP-%s',band_name);
%     traces_filter(count).parent = 'Cereplex-Traces';
%     traces_filter(count).fullname = strcat(traces_filter(count).shortname,'/',traces_filter(count).ID);
%     traces_filter(count).X = X_filt;
%     traces_filter(count).Y = Y_filt;
%     traces_filter(count).X_ind = data_t.time_ref.X;
%     traces_filter(count).X_im = data_t.time_ref.Y;
%     traces_filter(count).Y_im = interp1(traces_filter(count).X,traces_filter(count).Y,traces_filter(count).X_im);
%     traces_filter(count).nb_samples = length(Y_filt);
%     %fprintf('Succesful Importation %s [Parent %s].\n',traces_filter(i).fullname,traces_filter(i).parent);
    
    % Extract envelope
    % fl = max(round(t_smooth/(X_filt(2)-X_filt(1))),1);
    % [Y_env_up,Y_env_down] = envelope(Y_filt,fl,'analytic');
    fprintf('Smoothing [%.1f s]...',t_smooth);
    f_filt = 1/(X_filt(2)-X_filt(1));
    [Y_env_up,~] = envelope(Y_filt);
    %Gaussian smoothing
    n = max(round(t_smooth*f_filt),1);
    Y_env = conv(Y_env_up,gausswin(n)/n,'same');
    fprintf(' done;\n');
    
    % Subsampling envelope
    ftemp = 5/t_smooth;
    if ftemp < f_filt
        X_power = (X_filt(1):1/ftemp:X_filt(end))';
        Y_power = interp1(X_filt,Y_env,X_power);
    else
        X_power = X_filt;
        Y_power = Y_env;
    end
    
    % Saving
    traces_envelope(count).ID = char(temp(2));
    traces_envelope(count).shortname = sprintf('Power-%s',str_channel(1:3));
    traces_envelope(count).parent = 'Cereplex-Traces';
    traces_envelope(count).fullname = strcat(traces_envelope(count).shortname,'/',traces_envelope(count).ID);
    traces_envelope(count).X = X_power;
    traces_envelope(count).Y = Y_power;
    traces_envelope(count).X_ind = data_t.time_ref.X;
    traces_envelope(count).X_im = data_t.time_ref.Y;
    traces_envelope(count).Y_im = interp1(traces_envelope(count).X,traces_envelope(count).Y,traces_envelope(count).X_im);
    traces_envelope(count).nb_samples = length(Y_power);
    %fprintf('Succesful Importation %s [Parent %s].\n',traces_envelope(i).fullname,traces_envelope(i).parent);
    
end

% Merging traces
traces = [traces_filter,traces_envelope];

% % Save dans SpikoscopeTraces.mat
% MetaData = [];
% if ~isempty(traces_filter)
%     traces = [traces_filter,traces_envelope];
%     fprintf('Saving Cereplex traces ...\n');
%     save(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Cereplex_Traces.mat'),'traces','MetaData','-v7.3');
%     fprintf('===> Saved at %s.mat\n',fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Cereplex_Traces.mat'));
% end
% success = load_lfptraces(foldername,handles);

% Direct Loading LFP traces
load('Preferences.mat','GDisp','GTraces');
g_colors = get(groot,'DefaultAxesColorOrder');

% if val == 1
%     [ind_traces,ok] = listdlg('PromptString','Select Traces','SelectionMode','multiple',...
%         'ListString',{traces.fullname}','ListSize',[400 500]);
% else
%     % batch mode
%     pattern_list = {'Power';'LFP-theta'};
%     ind_traces = find(contains({traces.fullname}',pattern_list)==1);
%     ok = true;
% end
% 
% if ~ok || isempty(ind_traces)
%     return;
% end
ind_traces = 1:length(traces);

% getting lines name
lines = findobj(handles.RightAxes,'Tag','Trace_Cerep');
lines_name = cell(length(lines),1);
for i =1:length(lines)
    lines_name{i} = lines(i).UserData.Name;
end

for i=1:length(ind_traces)
    
    % finding trace name
    t = traces(ind_traces(i)).fullname;
    
    %Adding burst
    Xtemp = traces(ind_traces(i)).X_ind;
    %Xtemp = [reshape(Xtemp,[data_t.length_burst,data_t.n_burst]);NaN(1,data_t.n_burst)];
    Ytemp = traces(ind_traces(i)).Y_im;
    %Ytemp = [reshape(Ytemp,[data_t.length_burst,data_t.n_burst]);NaN(1,data_t.n_burst)];
    
    if sum(strcmp(t,lines_name))>0
        %line already exists overwrite
        ind_overwrite = find(strcmp(t,lines_name)==1);
        lines(ind_overwrite).UserData.X = traces(ind_traces(i)).X;
        lines(ind_overwrite).UserData.Y = traces(ind_traces(i)).Y;
        lines(ind_overwrite).XData = Xtemp;
        lines(ind_overwrite).YData = Ytemp;
        save_name = regexprep(lines(ind_overwrite).UserData.Name,'/|\','_');
        fprintf('Cereplex Trace successfully updated (%s)\n',traces(ind_traces(i)).fullname);
    else
        %line creation
        %str = lower(char(traces(ind_traces(i)).fullname));
        switch traces(ind_traces(i)).shortname
            case 'Power-EMG'
                color = [.5 .5 .5];
            case 'Power-ACC'
                color = [0 1 0];
            case 'Power-GYR'
                color = [0 0 1];
            otherwise
                color = rand(1,3);
        end
        
        % Line creation
        hl = line('XData',Xtemp,...
            'YData',Ytemp,...
            'Color',color,...
            'Tag','Trace_Cerep',...
            'Visible','off',...
            'HitTest','off',...
            'Parent', handles.RightAxes);      
%         if handles.RightPanelPopup.Value==4
%             set(hl,'Visible','on');
%         end
        str_rpopup = strtrim(handles.RightPanelPopup.String(handles.RightPanelPopup.Value,:));
        if strcmp(str_rpopup,'Trace Dynamics')
            set(hl,'Visible','on');
        end
        
        % Updating UserData
        s.Name = regexprep(t,'_','-');
        s.X = traces(ind_traces(i)).X;
        s.Y = traces(ind_traces(i)).Y;
        hl.UserData = s;
        save_name = regexprep(s.Name,'/|\','_');
        fprintf('Cereplex Trace successfully loaded (%s)\n',traces(ind_traces(i)).fullname);
    end
    
    % Saving trace
    dir_source = fullfile(foldername,'Sources_LFP');
    if ~exist(dir_source,'dir')
        mkdir(dir_source);
    end
    X = traces(ind_traces(i)).X;
    Y = traces(ind_traces(i)).Y;
    f = X(2)-X(1);
    x_start = X(1);
    x_end = X(end);
    save(fullfile(dir_source,strcat(save_name,'.mat')),'Y','f','x_start','x_end','-v7.3');
    fprintf('Data Saved [%s]\n',fullfile(dir_source,strcat(save_name,'.mat')));
    
end

success = true;

end