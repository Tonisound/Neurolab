function success = import_regions(foldername,file_session)
% Step 1
% Converts Spikoscope Regions to binary files in txt format to SEED_REGION
% Select most recent Mask directory and extracts name, mask and patch for
% each region
% files .U8 generated by Spikoscope must be stored in SEED_REGION/Spikoscope_RegionArchive

% Step 2
% Converts binary files directly to file NRegions.mat

success = false;
global SEED_REGION;

% Searching seed_region
%seed_region = '/Users/tonio/Documents/Spikoscope_RegionArchive/';
seed_region = fullfile(SEED_REGION,'Spikoscope_RegionArchive');
%file_E = strrep(file_session,'_MySession','_E_spiko_region_archive');
file_E = strcat(file_session,'_spiko_region_archive');
dir_regions = dir(fullfile(seed_region,file_E,'Mask*'));

%Sorting by datenum
S = [dir_regions(:).datenum];
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

%Sorting by datenum
S = [files_regions(:).datenum];
[~,ind] = sort(S);
files_regions = files_regions(ind);

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