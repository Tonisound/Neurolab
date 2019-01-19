function success = import_regions(foldername,file_session,handles,val)
% Step 1
% Converts Spikoscope Regions to binary files in txt format to SEED_REGION
% Select most recent Mask directory and extracts name, mask and patch for
% each region
% files .U8 generated by Spikoscope must be stored in SEED_REGION/Spikoscope_RegionArchive

% Step 2
% Converts binary files directly to file NRegions.mat

success = false;
global SEED_REGION LAST_IM IM;

% Searching seed_region
%seed_region = '/Users/tonio/Documents/Spikoscope_RegionArchive/';
seed_region = fullfile(SEED_REGION,'Spikoscope_RegionArchive');
%file_E = strrep(file_session,'_MySession','_E_spiko_region_archive');
file_E = strcat(file_session,'_spiko_region_archive');
dir_regions = dir(fullfile(seed_region,file_E,'Mask*'));

%Sorting by datenum
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
% be careful to remove all hidden files (.fUS_plane*.U8)
files_regions = dir(fullfile(dir_regions,'fUS*.U8'));

if isempty(files_regions)
    warning('No Mask Regions found under binary format [%s].',dir_regions);
    return;
else
    % creating saving folder
    if exist(fullfile(SEED_REGION,file_session),'dir')
        rmdir(fullfile(SEED_REGION,file_session),'s');
    end
    mkdir(fullfile(SEED_REGION,file_session));
    
    % copying
    fprintf('Copying files in NRegions directory...');
    for i =1:length(files_regions)
        copyfile(fullfile(dir_regions,char(files_regions(i).name)),fullfile(SEED_REGION,file_session,char(files_regions(i).name)))
    end
    fprintf(' done.\n');
end

regions = struct('name',{},'mask',{},'patch_x',{},'patch_y',{});

% %Sorting by datenum
% S = [files_regions(:).datenum];
% [~,ind] = sort(S);
% files_regions = files_regions(ind);

% Sorting by name
pattern_list = {'ac';'s1bf';'lpta';'rs';'antcortex';'amidcortex';'pmidcortex';'postcortex';'neocortex';...
    'dg';'ca3';'ca2';'ca1';'dhpc';'vhpc';'subiculum';...
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
C = permute(struct2cell(regions),[3,1,2]);
C = C(:,1);
C = regexprep(C,'_','-');
prefix = largest_prefix(C);
suffix = largest_suffix(C);

for i=1:length(files_regions)
    %root = regexp(char(C(i)),prefix,'split');
    %root = regexp(char(root(2)),suffix,'split');
    root=char(C(i));
    regions(i).name = root(length(prefix)+1:end-length(suffix));
end

% Saving Regions
save(fullfile(foldername,'Spikoscope_Regions.mat'),'X','Y','regions');
fprintf('Spikoscope Regions Imported [%s] \n===> Saved in %s\n',dir_regions,fullfile(foldername,'Spikoscope_Regions.mat'));


% Direct Region Loading

load('Preferences.mat','GDisp','GTraces');
if exist(fullfile(foldername,'Time_Reference.mat'),'file')
    load(fullfile(foldername,'Time_Reference.mat'),'time_ref','length_burst','n_burst');
else
    errordlg(sprintf('Missing File %s',fullfile(folder_name,'Time_Reference.mat')));
    return;
end

% Choising regions
lines = findobj(handles.RightAxes,'Tag','Trace_Region');
count=length(lines);

if nargin <4
    [ind_regions,ok] = listdlg('PromptString','Select Regions','SelectionMode','multiple','ListString',{regions.name},'ListSize',[300 500]);
else
    ind_regions = 1:length(regions);
    ok = true;
end

if ~ok || isempty(ind_regions)
    return;
end

for i=1:length(ind_regions)
    
    str = lower(char(regions(ind_regions(i)).name));
    fprintf('Importing Region %s (%d/%d) ...\n',str,i,length(ind_regions));
    
    if ~isempty(strfind(str,'hpc'))||...
            ~isempty(strfind(str,'ca1'))||...
            ~isempty(strfind(str,'ca2'))||...
            ~isempty(strfind(str,'ca3'))||...
            ~isempty(strfind(str,'dg'))||...
            ~isempty(strfind(str,'subic'))||...
            ~isempty(strfind(str,'lent-'))
        delta =10;
    elseif ~isempty(strfind(str,'thal'))||...
            ~isempty(strfind(str,'vpm-'))||...
            ~isempty(strfind(str,'po-'))||...
            ~isempty(strfind(str,'cpu-'))||...
            ~isempty(strfind(str,'gp-'))||...
            ~isempty(strfind(str,'septal'))
        delta =20;
    elseif ~isempty(strfind(str,'cortex'))||...
            ~isempty(strfind(str,'rs-'))||...
            ~isempty(strfind(str,'ac-'))||...
            ~isempty(strfind(str,'s1'))||...
            ~isempty(strfind(str,'lpta'))||...
            ~isempty(strfind(str,'m12'))||...
            ~isempty(strfind(str,'v1'))||...
            ~isempty(strfind(str,'v2'))||...
            ~isempty(strfind(str,'cg-'))||...
            ~isempty(strfind(str,'cx-'))||...
            ~isempty(strfind(str,'ptp'))
        delta =0;
    else
        delta =30;
    end
    
    count = count+1;
    ind_color = min(delta+count,length(handles.MainFigure.Colormap));
    color = handles.MainFigure.Colormap(ind_color,:);
    fprintf('i = %d, ind_color %d, color [%.2f %.2f %.2f]\n',i,ind_color,...
        handles.MainFigure.Colormap(ind_color,1),handles.MainFigure.Colormap(ind_color,2),handles.MainFigure.Colormap(ind_color,3));
    
    % Checking if region name is whole
    l_width = 1;
    if ~isempty(strfind(str,'whole'))
        color = [.5 .5 .5];
        l_width = 2;
    end
    
    hq = patch(regions(ind_regions(i)).patch_x,regions(ind_regions(i)).patch_y,color,...
        'EdgeColor','k',...
        'Tag','Region',...
        'FaceAlpha',.5,...
        'LineWidth',.5,...
        'ButtonDownFcn',{@click_RegionFcn,handles},...
        'Visible','off',...
        'Parent',handles.CenterAxes);
    
    X = [reshape(1:LAST_IM,[length_burst,n_burst]);NaN(1,n_burst)];
    im_mask = regions(ind_regions(i)).mask;
    im_mask(im_mask==0)=NaN;
    im_mask = IM.*repmat(im_mask,1,1,size(IM,3));
    %im_mask = IM(:,:,:).*repmat(regions(ind_regions(i)).mask,1,1,size(IM,3));
    %im_mask(im_mask==0)=NaN;
    Y = mean(mean(im_mask,2,'omitnan'),1,'omitnan');
    Y = [reshape(Y,[length_burst,n_burst]);NaN(1,n_burst)];
    
    hl = line('XData',X(:),...
        'YData',Y(:),...
        'Color',color,...
        'Tag','Trace_Region',...
        'HitTest','on',...
        'Visible','off',...
        'LineWidth',l_width,...
        'Parent',handles.RightAxes);
    set(hl,'ButtonDownFcn',{@click_lineFcn,handles});
    
    if handles.RightPanelPopup.Value ==3
        %set([hq;hl],'Visible','on');
        set(hl,'Visible','on');
    end
    boxLabel_Callback(handles.LabelBox,[],handles);
    boxPatch_Callback(handles.PatchBox,[],handles);
    
    % Updating UserData
    s.Name = regions(ind_regions(i)).name;
    s.Mask = regions(ind_regions(i)).mask;
    s.Graphic = hq;
    hq.UserData = hl;
    hl.UserData = s;
    
    fprintf('Region %s Successfully Imported (%d/%d).\n',str,i,length(ind_regions));
end

actualize_plot(handles);
success = true;

end

function pattern = largest_prefix(C)
pattern = char(C(1,1));
%while length(pattern)>1 && length(cell2mat(regexp(C,pattern)))<length(C)
%    pattern = pattern(1:end-1);
%end
cur=1;
while length(pattern)>1 && cur<length(C)
    if isempty(strfind(char(C(cur,1)),pattern))
        pattern = pattern(1:end-1);
    else
        cur = cur+1;
    end
end
end

function pattern = largest_suffix(C)
Pattern = char(C(1,1));
pattern = Pattern(end);
while length(pattern)<length(Pattern) && length(cell2mat(regexp(C,pattern)))>=length(C)
    pattern = Pattern(end-length(pattern):end);
end
pattern = pattern(2:end);
end

