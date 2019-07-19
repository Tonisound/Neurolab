function success = import_regions(foldername,file_recording,handles,val)
% Step 1
% Converts Spikoscope Regions to binary files in txt format to SEED_REGION
% Select most recent Mask directory and extracts name, mask and patch for
% each region
% files .U8 generated by Spikoscope must be stored in SEED_REGION/Spikoscope_RegionArchive

% Step 2
% Converts binary files directly to file NRegions.mat

success = false;
global SEED_REGION LAST_IM IM;

% Step 1: Searching Spikoscope_RegionArchive if
% fullfile(SEED_REGION,file_recording) is empty
if ~exist(fullfile(SEED_REGION,file_recording),'dir')
    seed_region = fullfile(SEED_REGION,'Spikoscope_RegionArchive');
    file_E = strcat(file_recording,'_spiko_region_archive');
    dir_regions = dir(fullfile(seed_region,file_E,'Mask*'));
    
    %Sorting by datenum
    if length(dir_regions)>1
        S = [];
        for i =1:length(dir_regions)
            d = dir(fullfile(seed_region,file_E,char(dir_regions(i).name),'fUS*.U8'));
            if isempty(d)
                S = [S;dir_regions(i).datenum];
            else
                S = [S;d(1).datenum];
            end
        end
        %S = [dir_regions(:).datenum]';
        [~,ind] = sort(S);
        dir_regions = dir_regions(ind);
        
        % Selecting most recent one
        dir_regions = fullfile(seed_region,file_E,char(dir_regions(end).name));
    elseif    length(dir_regions)==1
        dir_regions = fullfile(seed_region,file_E,char(dir_regions.name));
    end
    
    if isempty(dir_regions)
        warning('No Mask Regions found under binary format [%s].',fullfile(seed_region,file_E));
        return;
    else
        % be careful to remove all hidden files (.fUS_plane*.U8)
        files_regions = dir(fullfile(dir_regions,'fUS*.U8'));
        
        % creating saving folder
        if exist(fullfile(SEED_REGION,file_recording),'dir')
            rmdir(fullfile(SEED_REGION,file_recording),'s');
        end
        mkdir(fullfile(SEED_REGION,file_recording));
        
        % copying
        fprintf('Copying files in NRegions directory...');
        for i =1:length(files_regions)
            copyfile(fullfile(dir_regions,char(files_regions(i).name)),fullfile(SEED_REGION,file_recording,char(files_regions(i).name)))
        end
        fprintf(' done.\n');
    end
else
    dir_regions = fullfile(SEED_REGION,file_recording);
    files_regions = dir(fullfile(dir_regions,'fUS*.U8'));
end

% Step 2: building regions struct and importing regions from
% fullfile(SEED_REGION,file_recording)
regions = struct('name',{},'mask',{},'patch_x',{},'patch_y',{});

% Sorting by name
pattern_list = {'ac';'s1bf';'lpta';'rs';'v2';'antcortex';'amidcortex';'pmidcortex';'postcortex';'neocortex';...
    'dg';'ca3';'ca2';'ca1';'fc';'subiculum';'dhpc';'vhpc';...
    'dthal';'vthal';'vpm';'po';'thalamus';'cpu';'gp';'hypothalrg'};

files_regions_sorted = [];
for i =1:length(pattern_list)
    pattern = strcat('_',pattern_list(i),'_');
    ind_sort = contains(lower({files_regions(:).name}'),pattern);
    files_regions_sorted = [files_regions_sorted;files_regions(ind_sort)];
    files_regions(ind_sort)=[];
end
files_regions = [files_regions_sorted;files_regions];


for i=1:length(files_regions)
    filename = fullfile(dir_regions,files_regions(i).name);
    fileID = fopen(filename,'r');
    raw = fread(fileID,8,'uint8')';
    X = raw(8);
    Y = raw(4);
    mask = fread(fileID,[X,Y],'uint8')';
    fclose(fileID);
    regions(i).name = files_regions(i).name;
    regions(i).mask = mask';
    
    % Creating Patch
    [y,x]= find(mask'==1);
    try
        k = convhull(x,y);
        regions(i).patch_x = x(k);
        regions(i).patch_y = y(k);
    catch
        % Problem when points are colinear
        regions(i).patch_x = x;
        regions(i).patch_y = y ;
    end
end

% Removing largest prefix and suffix from regions.name
%Largest Prefix
pattern = char(regions(1).name);
count=0;
while (count <= length(pattern)) && (sum(contains({regions(:).name}',pattern(1:count)))== size({regions(:).name}',1))
    count = count+1;
end
prefix = pattern(1:count-1);
%Largest Suffix
pattern = char(regions(1).name);
count=0;
while (count <= length(pattern)) && (sum(contains({regions(:).name}',pattern(end-count+1:end)))== size({regions(:).name}',1))
    count = count+1;
end
suffix = pattern(end-count+2:end);
% Renaming regions
regions_name = [];
for i=1:length(files_regions)
    root =  regions(i).name;
    regions(i).name = root(length(prefix)+1:end-length(suffix));
    regions(i).name = strrep(regions(i).name,'_','-');
    regions_name = [regions_name;{regions(i).name}];
end

% Unilateral/Bilateral Importation
load('Preferences.mat','GDisp','GTraces','GImport');
switch GImport.Region_loading 
    case 'unilateral'
        fprintf('=== Unilateral Importation ===\n');
    case {'bilateral';'all'}
        %regions_unilateral = struct('name',{},'mask',{},'patch_x',{},'patch_y',{});
        regions_bilateral = struct('name',{},'mask',{},'patch_x',{},'patch_y',{});
        patterns = regexprep(regions_name,'-L|-R|-A|-P','');
        unique_patterns = unique(regexprep(regions_name,'-L|-R|-A|-P',''),'stable');
        
        % loop across unique patterns
        for i=1:length(unique_patterns)
            ind_merge = find(strcmp(patterns,unique_patterns(i))==1);
            if length(ind_merge)==1
                regions_bilateral(i)= regions(ind_merge);
                regions_bilateral(i).name = char(unique_patterns(i));
            else
                name_merge = char(unique_patterns(i));
                mask_merge = zeros(size(regions(1).mask));
                patch_x_merge = [];
                patch_y_merge = [];
                for j=1:length(ind_merge)
                    mask_merge = mask_merge+regions(ind_merge(j)).mask;
                    patch_x_merge = [patch_x_merge;regions(ind_merge(j)).patch_x];
                    patch_y_merge = [patch_y_merge;regions(ind_merge(j)).patch_y];
                end
                regions_bilateral(i).name = name_merge;
                regions_bilateral(i).mask = double(mask_merge>0);
                regions_bilateral(i).patch_x = patch_x_merge;
                regions_bilateral(i).patch_y = patch_y_merge;
            end
        end
        if strcmp(GImport.Region_loading,'bilateral')
            fprintf('=== Bilateral Importation ===\n');
            regions = regions_bilateral;
        else
            fprintf('=== Unilateral & Bilateral Importation ===\n');
            
            % Removing double regions
            ind_double = false(size(regions_bilateral));
            for k =1:length(regions_bilateral)
                pattern = regions_bilateral(k).name;
                if ~isempty(find(strcmp({regions(:).name}',pattern))==1)
                    ind_double(k)=true;
                end
            end
            regions_bilateral = regions_bilateral(~ind_double);
            regions = [regions,regions_bilateral];
        end    
end


% Direct Region Loading
if exist(fullfile(foldername,'Time_Reference.mat'),'file')
    load(fullfile(foldername,'Time_Reference.mat'),'time_ref','length_burst','n_burst','rec_mode');
else
    errordlg(sprintf('Missing File %s',fullfile(folder_name,'Time_Reference.mat')));
    return;
end

% Gaussian window
t_gauss = GTraces.GaussianSmoothing;
delta =  time_ref.Y(2)-time_ref.Y(1);
w = gausswin(round(2*t_gauss/delta));
w = w/sum(w);

% Choising regions
lines = findobj(handles.RightAxes,'Tag','Trace_Region');
% getting lines name
lines_name = cell(length(lines),1);
for i =1:length(lines)
    lines_name{i} = lines(i).UserData.Name;
end
count=length(lines);

if nargin <4
    [ind_regions,ok] = listdlg('PromptString','Select Regions','SelectionMode','multiple',...
        'ListString',{regions.name},'ListSize',[300 500]);
else
    ind_regions = 1:length(regions);
    ok = true;
end

if ~ok || isempty(ind_regions)
    return;
end
 

for i=1:length(ind_regions)
    
    % finding trace name
    t = char(regions(ind_regions(i)).name);
    str = lower(t);
    
    if sum(strcmp(t,lines_name))>0
        %line already exists overwrite
        ind_overwrite = find(strcmp(t,lines_name)==1);
        hq = lines(ind_overwrite).UserData.Graphic;
        hl = lines(ind_overwrite);
        
        % patch update
        hq.XData = regions(ind_regions(i)).patch_x;
        hq.YData = regions(ind_regions(i)).patch_y;
        % mask update
        hl.UserData.Mask = regions(ind_regions(i)).mask;
        % line update
        im_mask = regions(ind_regions(i)).mask;
        im_mask(im_mask==0)=NaN;
        im_mask = IM.*repmat(im_mask,1,1,size(IM,3));
        Y = mean(mean(im_mask,2,'omitnan'),1,'omitnan');
        Y = [reshape(Y,[length_burst,n_burst]);NaN(1,n_burst)];
        hl.YData = Y;
        fprintf('Region %s Successfully Updated (%d/%d).\n',t,i,length(ind_regions));
        
    else
        
        % Color counter
        count = count+1;
        
        %if contains(str,{'hpc';'ca1';'ca2';'ca3';'dg';'fc-';'subic';'lent-'})
        if contains(str,{'hpc';'ca1';'ca2';'ca3';'dg';'fc';'subic';'lent'})
            delta = 10;
        %elseif contains(str,{'thal';'vpm-';'po-';'cpu-';'gp-';'septal'})
        elseif contains(str,{'thal';'vpm';'po';'cpu-';'gp';'septal'})
            delta = 20;
        %elseif contains(str,{'cortex';'rs-';'ac';'s1';'lpta';'m12';'v1';'v2';'cg-';'cx-';'ptp'})
        elseif contains(str,{'cortex';'rs';'ac';'s1';'lpta';'m12';'v1';'v2';'cg';'cx';'ptp'})
            delta = 0;
        else
            delta = 30;
        end
        ind_color = min(delta+count,length(handles.MainFigure.Colormap));
        color = handles.MainFigure.Colormap(ind_color,:);
        %fprintf('i = %d, ind_color %d, color [%.2f %.2f %.2f]\n',i,ind_color,color(:,1),color(:,2),color(:,3));
        
        % Checking if region name is whole
        l_width = 1;
        if contains(str,'whole')
            color = [.5 .5 .5];
            l_width = 2;
        end
        
        % patch creation
        hq = patch(regions(ind_regions(i)).patch_x,regions(ind_regions(i)).patch_y,color,...
            'EdgeColor','none',...
            'Tag','Region',...
            'FaceAlpha',.5,...
            'LineWidth',.5,...
            'ButtonDownFcn',{@click_RegionFcn,handles},...
            'Visible','off',...
            'Parent',handles.CenterAxes);
        % mask creation
        X = [reshape(1:LAST_IM,[length_burst,n_burst]);NaN(1,n_burst)];
        im_mask = regions(ind_regions(i)).mask;
        im_mask(im_mask==0)=NaN;
        im_mask = IM.*repmat(im_mask,1,1,size(IM,3));
        %im_mask = IM(:,:,:).*repmat(regions(ind_regions(i)).mask,1,1,size(IM,3));
        %im_mask(im_mask==0)=NaN;
        Y = mean(mean(im_mask,2,'omitnan'),1,'omitnan');
        Y = [reshape(Y,[length_burst,n_burst]);NaN(1,n_burst)];
        
        % line creation
        hl = line('XData',X(:),...
            'YData',Y(:),...
            'Color',color,...
            'Tag','Trace_Region',...
            'HitTest','on',...
            'Visible','off',...
            'LineWidth',l_width,...
            'Parent',handles.RightAxes);
        set(hl,'ButtonDownFcn',{@click_lineFcn,handles});
        
        % Updating UserData
        s.Name = regions(ind_regions(i)).name;
        s.Mask = regions(ind_regions(i)).mask;
        s.Graphic = hq;
        hq.UserData = hl;
        hl.UserData = s;
        
        fprintf('Region %s Successfully Imported (%d/%d).\n',t,i,length(ind_regions));
    end
    
    % Line Visibility
    if handles.RightPanelPopup.Value ==3
        %set([hq;hl],'Visible','on');
        set(hl,'Visible','on');
    end
    
    % Gaussian smoothing
    if t_gauss>0
        %fprintf(' Smoothing constant (%.1f s)... ',t_gauss);
        y = hl.YData(1:end-1); 
        if strcmp(rec_mode,'BURST')
            % gaussian nan convolution + nan padding (only for burst_recording)
            % length_burst_smooth = 30;
            length_burst_smooth = 59;
            n_burst_smooth = length(y)/length_burst_smooth;
            y_reshape = [reshape(y,[length_burst_smooth,n_burst_smooth]);NaN(length(w),n_burst_smooth)];
            y_conv = nanconv(y_reshape(:),w,'same');
            y_reshaped = reshape(y_conv,[length_burst_smooth+length(w),n_burst_smooth]);
            y_final = reshape(y_reshaped(1:length_burst_smooth,:),[length_burst_smooth*n_burst_smooth,1]);
            hl.YData(1:end-1) = y_final';
        else
            hl.YData(1:end-1) = nanconv(y,w,'same');
        end
    end
    
end

% Checkbox Update
boxLabel_Callback(handles.LabelBox,[],handles);
boxPatch_Callback(handles.PatchBox,[],handles);        
actualize_plot(handles);
success = true;

end
