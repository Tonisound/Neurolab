function F = menuImportfile_Callback(~,~,handles,flag)
% File Importation
% Searches for EEG, fUS and video files

global SEED SEED_SWL DIR_SAVE;
global CUR_IM START_IM END_IM LAST_IM;

% Initialization
F = struct('session',{},'recording',{},'parent',{},'fullpath',{},'info',{},'video',{},'dir_fus',{},'acq',{},'biq',{},...
    'ns1',{},'ns2',{},'ns3',{},'ns4',{},'ns5',{},'ns6',{},'nev',{},'ccf',{},'rcf',{},'nlab',{},'type',{});


if flag == 1
    % Manual Import
    FileName = uigetdir(SEED,'Select file');
    if FileName==0
        return;
    else
        FileList = {FileName};
    end
    
else
    % Recording list Import
    rec_list = dir(fullfile(SEED_SWL,'*.txt'));
    s = listdlg('PromptString','Select a recording list:',...
        'SelectionMode','single','ListString',{rec_list(:).name}','ListSize',[300 500]);
    if isempty(s)
        return;
    else
        % Loading Separators
        load('Preferences.mat','GParams');
        sep_swl_1 = GParams.sep_swl_1;
        sep_swl_2 = GParams.sep_swl_2;
        % Extracting FileName
        fid = fopen(fullfile(SEED_SWL,char(rec_list(s).name)),'r');
        raw_list = fread(fid,'*char')';
        index1 = strfind(raw_list,sep_swl_1);
        index2 = strfind(raw_list,sep_swl_2);
        n_files = length(index1);
        FileList = [];
        for i = 1:n_files
            line_ex = raw_list(index1(i)+length(sep_swl_1):index2(i)-1);
            FileList = [FileList;{line_ex}];
        end    
    end
end

% Convert FileList in format parent/session/recording
FileList_converted = [];
for i = 1:length(FileList)
    FileName = char(FileList(i));
    FileName_split = regexp(FileName,'/|\','split');
    if contains(FileName_split(end),'_pre') || contains(FileName_split(end),'_per')...
            || contains(FileName_split(end),'_post') || contains(FileName_split(end),'_nlab')
        % Direct importation
        FileList_converted = [FileList_converted;{FileName}];
    elseif contains(FileName_split(end),'_MySession')
        % Searches recording
        d = [dir(fullfile(FileName,'*_pre'));dir(fullfile(FileName,'*_per'));dir(fullfile(FileName,'*_post'))];
        if isempty(d)
            warning('File skipped [No recording in session] %s.\n',FileName);
        else
            all_files = cell(length(d),1);
            for j=1:length(d)
                all_files(j) = {fullfile(FileName,'/',char(d(j).name))};
            end
            %all_files = strcat(FileName,'/',{d(:).name}');
            FileList_converted = [FileList_converted;all_files];
        end
    else
        warning('File skipped [Incorrect path] %s.\n',FileName);
    end
end
FileList = FileList_converted;
%fprintf('%d recording detected. Proceed.\n',length(FileList));

for i = 1:length(FileList)
    % Extracting FileName
    ind_file = i;
    FileName = char(FileList(ind_file));
    % Extracting session name
    FileName_split = regexp(FileName,'/|\','split');
    index_session = contains(FileName_split,'_MySession');
    
    if contains(FileName_split(end),'_nlab')
        l = load(fullfile(FileName,'Config.mat'),'File');
        F(ind_file) = l.File;
        continue;
    elseif index_session(end-1)==1 && contains(FileName_split(end),["pre","per","post"])
        session = char(FileName_split(end-1));
        % Extracting parent
        temp = regexp(FileName,session,'split');
        parent = strrep(char(temp(1)),SEED,'');
        parent = parent(1:end-1);
        % Extracting recording
        recording = char(FileName_split(end));
    else
        % Return if incorrect path
        errordlg('Please select a file path with _MySession');
        return;
    end
    F(ind_file).session = session;
    F(ind_file).recording = recording;
    F(ind_file).parent = parent;
    F(ind_file).fullpath = fullfile(SEED,parent,session,recording);
    
    % Looking for info file
    d = dir(fullfile(SEED,parent,session,'*.txt'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).info = str;
    end
    % Looking for video file
    d = dir(fullfile(FileName,'*.mpg'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).video = str;
    end
    
    % Looking for fUS
    d = dir(fullfile(FileName,'*_fus'));
    if ~isempty(d)
        dir_fus = char(d(1).name);
        F(ind_file).dir_fus = dir_fus;
        
        dd = dir(fullfile(FileName,dir_fus,'*.acq'));
        if ~isempty(dd)
            acq = char(dd(1).name);
            F(ind_file).acq = acq;
        end
        dd = dir(fullfile(FileName,dir_fus,'*.biq'));
        if ~isempty(dd)
            biq = char(dd(1).name);
            F(ind_file).biq = biq;
        end
    end
    
    % Looking for EEG
    d = dir(fullfile(FileName,'*.ns1'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns1 = str;
    end
    d = dir(fullfile(FileName,'*.ns2'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns2 = str;
    end
    d = dir(fullfile(FileName,'*.ns3'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns3 = str;
    end
    d = dir(fullfile(FileName,'*.ns4'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns4 = str;
    end
    d = dir(fullfile(FileName,'*.ns5'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns5 = str;
    end
    d = dir(fullfile(FileName,'*.ns6'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ns6 = str;
    end
    d = dir(fullfile(FileName,'*.nev'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).nev = str;
    end
    d = dir(fullfile(FileName,'*.ccf'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).ccf = str;
    end
    d = dir(fullfile(FileName,'*.rcf'));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).rcf = str;
    end
    
    % File type
    if isempty(F(ind_file).acq)
        if isempty(F(ind_file).ns1)&&isempty(F(ind_file).ns2)...
                &&isempty(F(ind_file).ns3)&&isempty(F(ind_file).ns4)...
                &&isempty(F(ind_file).ns5)&&isempty(F(ind_file).ns6)...
                && ~isempty(F(ind_file).video)
            F(ind_file).type = 'VIDEO';
        elseif ~isempty(F(ind_file).video)
            F(ind_file).type = 'EEG-VIDEO';
        end
    else
        if isempty(F(ind_file).ns1)&&isempty(F(ind_file).ns2)...
                &&isempty(F(ind_file).ns3)&&isempty(F(ind_file).ns4)...
                &&isempty(F(ind_file).ns5)&&isempty(F(ind_file).ns6)...
                && ~isempty(F(ind_file).video)
            F(ind_file).type = 'fUS-VIDEO';
        elseif ~isempty(F(ind_file).video)
            F(ind_file).type = 'EEG-fUS-VIDEO';
        else
            F(ind_file).type = 'fUS';
        end
    end
    
    % Looking for NLab File
    d = dir(fullfile(DIR_SAVE,strcat('*',recording,'*')));
    if ~isempty(d)
        str = char(d(1).name);
        F(ind_file).nlab = str;
    else
        %F(ind_file).nlab = regexprep(session,'_MySession','_nlab');
        F(ind_file).nlab = strcat(recording,'_nlab');
        % ask confirmation before importation   
        str_quest = strcat(fieldnames(F(ind_file)),sprintf(' : '),struct2cell(F(ind_file)));
        button = questdlg(str_quest,'New Importation','OK','Cancel','OK');
        
        % Creating nlab file if confirmation and
        if isempty(button) || strcmp(button,'Cancel')
            return;
        else
            mkdir(fullfile(DIR_SAVE,F(ind_file).nlab));
            fprintf('Nlab directory created : %s.\n',F(ind_file).nlab);
            
            % Import fUS Movie and Save Config.mat
            Doppler_film = import_DopplerFilm(F(ind_file),handles,0);
            
            % Detect trigger
            import_reference_time(F(ind_file),Doppler_film,handles);
            
            % select EEG
        end
    end
end

end