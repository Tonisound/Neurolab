function import_reference_time(F,Doppler_film,handles)
% Import reference time - Detects NEV channel and extracts trigger from it
% Adds one trigger if discrepancy between fus data and trigger number

%global LAST_IM IM CUR_IM  FILES CUR_FILE;
global CUR_IM DIR_SAVE;
load('Preferences.mat','GImport');
dir_save = fullfile(DIR_SAVE,F.nlab);


% test if trigger.txt does not exist and creates it
if ~exist(fullfile(F.fullpath,F.dir_fus,'trigger.txt'), 'file')
    
    % Trigger Importation
    if exist(fullfile(F.fullpath,F.dir_lfp,F.nev), 'file')
        % Trigger extraction from NEV file
        [trigger,reference,padding] = extract_trigger_nev(F,Doppler_film);
        
    elseif exist(fullfile(F.fullpath,F.dir_lfp,F.ns5), 'file')
        % Trigger extraction from NS5 file
        [trigger,reference,padding] = extract_trigger_ns5(F,Doppler_film);
        
    else
        % Missing NEV : template trigger
        warning('Missing NEV file.\n');
        [trigger,reference,padding] = extract_trigger_void(Doppler_film);
        return;
    end
    
    % Trigger Exportation
    file_txt = fullfile(F.fullpath,F.dir_fus,'trigger.txt');
    fid_txt = fopen(file_txt,'w');
    fprintf(fid_txt,'%s',sprintf('<REF>\n%s</REF>\n',reference));
    fprintf(fid_txt,'%s',sprintf('<PAD>\n%s</PAD>\n',padding));
    fprintf(fid_txt,'%s',sprintf('<TRIG>\n'));
    %fprintf(fid_txt,'%s',sprintf('n=%d \n',length(trigger)));
    for k = 1:length(trigger)
        fprintf(fid_txt,'%s',sprintf('%.3f\t',trigger(k)));
    end
    fprintf(fid_txt,'%s',sprintf('</TRIG>'));
    fclose(fid_txt);
    fprintf('File trigger.txt saved at %s.\n',file_txt);

else
    % Trigger Readout
    reference = 'default';
    padding = 'none';
    trigger = [];
    
    file_txt = fullfile(F.fullpath,F.dir_fus,'trigger.txt');
    fid_txt = fopen(file_txt,'r');
    A = fread(fid_txt,'*char')';
    fclose(fid_txt);

    % REF
    delim1 = '<REF>';
    delim2 = '</REF>';
    if strfind(A,delim1)
        %B = regexp(A,'<REF>|<\REF>','split');
        B = A(strfind(A,delim1)+length(delim1):strfind(A,delim2)-1);
        C = regexp(B,'\t|\n|\r','split');
        D = C(~cellfun('isempty',C));
        reference = char(D);
    end
    % pAD
    delim1 = '<PAD>';
    delim2 = '</PAD>';
    if strfind(A,delim1)
        B = A(strfind(A,delim1)+length(delim1):strfind(A,delim2)-1);
        C = regexp(B,'\t|\n|\r','split');
        D = C(~cellfun('isempty',C));
        padding = char(D);
    end
    % TRIG
    B = regexp(A,'<TRIG>|</TRIG>','split');
    C = char(B(2));

    D = textscan(C,'%f');
    trigger = D{1,1};
end


% Trigger Importation  
n_images = length(trigger);
time_ref.X = (1:n_images)';
time_ref.Y = trigger;
time_ref.nb_images = length(trigger);
n_burst = 1;
length_burst = length(trigger);

% Save dans ReferenceTime.mat
time_str = cellstr(datestr((time_ref.Y)/(24*3600),'HH:MM:SS.FFF'));
handles.TimeDisplay.UserData = char(time_str);
handles.TimeDisplay.String = char(time_str(CUR_IM));
%datestr(time_ref.Y(CUR_IM)/(24*3600),'HH:MM:SS.FFF');
% save(fullfile(dir_save,'Time_Reference.mat'),'time_str','time_ref','n_burst','length_burst','n_images',...
%     'reference','padding','discrepant','trigger','trigger_raw','time_stamp','time_stamp_raw','-v7.3');
save(fullfile(dir_save,'Time_Reference.mat'),'time_str','time_ref','n_burst',...
    'length_burst','n_images','reference','padding','-v7.3');
fprintf('Succesful Reference Time Importation\n===> Saved at %s.mat\n',fullfile(dir_save,'Time_Reference.mat'));


end

function [trigger,reference,padding] = extract_trigger_ns5(F,Doppler_film)

fprintf('Loading NS5 file...');
data_ns5 = openNSx(fullfile(F.fullpath,F.dir_lfp,F.ns5));
fprintf(' done.\n');

f_trig = 30000;
if size(data_ns5.Data,1)==1
    t = data_ns5.Data';
    reference = sprintf('Channel %d [ns5]',data_ns5.ElectrodesInfo.ElectrodeID);
else
    warning('NS5 Data file contains several channels.');
    return;
end

f = figure;
ax = axes('Parent',f);
plot(t,'Parent',ax);
answer = char(inputdlg('Enter threshold value.'));
close(f);
t_thresh = t>eval(answer);
index = find(diff(t_thresh)>0);
trigger_raw = index/f_trig;

n_images = size(Doppler_film,3);
% Test if trigger matches Doppler_film size
if n_images~= length(trigger_raw)
    if length(trigger_raw) < n_images
        
        warning('Trigger (%d) and IM size (%d) do not match [Missing end trig]. -> Adding end trig',length(trigger_raw),n_images);
        discrepant = n_images-length(trigger_raw);
        padding = 'missing';
        % extend trigger using delta_trig
        delta_trig = trigger_raw(2)-trigger_raw(1);
        additional_trigs = (1:discrepant)'*delta_trig;
        trigger = [trigger_raw; trigger_raw(end)+additional_trigs];
        
        
    elseif length(trigger_raw) > n_images
        
        warning('Trigger (%d) and IM size (%d) do not match [Excess trigs]. -> Discarding end trigs',length(trigger_raw),n_images);
        discrepant = n_images-length(trigger_raw);
        padding = 'excess'; 
        % keep only first triggers
        trigger = trigger_raw(end-n_images+1:end);
        %trigger = trigger_raw(1:n_images);
            
    end
else
    discrepant = 0;
    padding = 'exact';
    trigger = trigger_raw;
    time_stamp = time_stamp_raw;
end

end

function [trigger,reference,padding] = extract_trigger_nev(F,Doppler_film)

fprintf('Importing Neural-Event data...');
data_nev = openNEV(fullfile(F.fullpath,F.dir_lfp,F.nev),'nosave','nomat');
fprintf(' done.\n');

% Asks User to pick trigger chanel if two or more channels detected
trig_list  = unique(data_nev.Data.Spikes.Electrode);
switch length(trig_list) 
    case 0
        % Missing NEV : template trigger
        warning('No trigger channel found: using template trigger.\n');
        [trigger,reference,padding] = extract_trigger_void(Doppler_film);
        return;
        
    case 1
        ind_trig = 1;
        reference = sprintf('Channel %d [nev]',trig_list(ind_trig));
        fprintf('Trigger channel detected : %d.\n',reference);

    otherwise
        [ind_trig,v] = listdlg('Name','Tag Selection','PromptString','Select Trigger',...
            'SelectionMode','single','ListString',trig_list,'InitialValue',1,'ListSize',[300 500]);
        if v==0
            return;
        elseif isempty(ind_tag)
            return;
        else
            %trigger = trig_list(ind_trig);
            reference = sprintf('Channel %d [nev]',trig_list(ind_trig));
            fprintf('Trigger channel selected : %d.\n',reference)
        end
end

% Extracting_timing
f_trig = 30000;
time_stamp_raw = data_nev.Data.Spikes.TimeStamp(data_nev.Data.Spikes.Electrode==trig_list(ind_trig))';
trigger_raw = double(time_stamp_raw)/f_trig;
n_images = size(Doppler_film,3);

% Test if trigger matches Doppler_film size
if n_images~= length(trigger_raw)
    if length(trigger_raw) < n_images
        
        warning('Trigger (%d) and IM size (%d) do not match [Missing end trig]. -> Adding end trig',length(trigger_raw),n_images);
        discrepant = n_images-length(trigger_raw);
        padding = 'missing';
        % extend trigger using delta_trig
        delta_trig = trigger_raw(2)-trigger_raw(1);
        additional_trigs = (1:discrepant)'*delta_trig;
        trigger = [trigger_raw; trigger_raw(end)+additional_trigs];
        time_stamp = [time_stamp_raw; time_stamp_raw(end)+time_stamp_raw(2)-time_stamp_raw(1)];
        
    elseif length(trigger_raw) > n_images
        
        warning('Trigger (%d) and IM size (%d) do not match [Excess trigs]. -> Discarding end trigs',length(trigger_raw),n_images);
        discrepant = n_images-length(trigger_raw);
        padding = 'excess'; 
        % keep only first triggers
        trigger = trigger_raw(end-n_images+1:end);
        %trigger = trigger_raw(1:n_images);
        time_stamp = time_stamp_raw(1:n_images);
            
    end
else
    discrepant = 0;
    padding = 'exact';
    trigger = trigger_raw;
    time_stamp = time_stamp_raw;
end

end

function [trigger,reference,padding] = extract_trigger_void(Doppler_film)

reference = 'default';
padding = 'none';
trigger = (1:size(Doppler_film,3))'/2.5;

end