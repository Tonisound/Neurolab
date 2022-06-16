function menuFiles_Callback(~,~,handles,flag)
% Files Menu Management
% flag == 1 Manual Importation
% flag == 2 Importation from Recording list

if nargin<4
    flag=0;
end

global SEED DIR_SAVE;
global FILES CUR_FILE;
%global SEED_SWL IM START_IM END_IM LAST_IM CUR_IM;

% Working with files
files_temp = FILES;

% Display Parameters
W = 130;
H = 60;
ftsize = 10;
panelColor = get(0,'DefaultUicontrolBackgroundColor');
backColor = [.75 .75 .75];

% Creating Dialog Box
f2 = dialog('Units','characters',...
    'Position',[10 10 W H],...
    'HandleVisibility','callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'Toolbar','figure',...
    'NumberTitle','off',...
    'Name','File Manager');
%f2.DeleteFcn = {@delete_fcn,handles}; 

mainPanel = uipanel('FontSize',ftsize,...
    'Units','characters',...
    'Position',[0 6 W H-6],...
    'Parent',f2);
pos = get(mainPanel,'Position');

tabgp = uitabgroup(mainPanel);
tab0 = uitab(tabgp,'Title','Files');


% Files Selection Table
file_uitable = uitable('ColumnName',{'Session','nlab','fUS','Video'},...
    'ColumnFormat',{'char','char','char','char'},...
    'ColumnEditable',[false,false,false,false],...
    'ColumnWidth',{180 180 180 180},...
    'Units','characters',...
    'Position',[0 0 mainPanel.Position(3)-1 mainPanel.Position(4)-3],...
    'CellSelectionCallback',@uitable_select,...
    'Parent',tab0);
%file_uitable.CellSelectionCallback = {@(src,evnt)set(src,'UserData',evnt.Indices)};

if ~isempty(files_temp)
    file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',...
        {files_temp.dir_fus}',{files_temp.video}'];
end

loadfileButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[W/4 3 W/8 2],...
    'String','Load',...
    'Parent',f2);

addfileButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[3*W/8 3 W/8 2],...
    'String','Import',...
    'Parent',f2);

rmfileButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[5*W/8 3 W/8 2],...
    'String','Remove',...
    'Parent',f2);

fileInfoButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[W/2 3 W/8 2],...
    'String','File Info',...
    'Parent',f2);

% OK & CANCEL Buttons
okButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[W/4 1 W/4 2],...
    'String','OK',...
    'Parent',f2);

cancelButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[W/2 1 W/4 2],...
    'String','Cancel',...
    'Parent',f2);

set(okButton,'Callback',{@okButton_callback,handles});
set(cancelButton,'Callback', @cancelButton_callback);
set(loadfileButton,'Callback',@load_file_callback);
set(addfileButton,'Callback',@addfileButton_callback);
set(rmfileButton,'Callback',@rmfileButton_callback);
set(fileInfoButton,'Callback',@fileInfoButton_callback);

switch flag
    case 1
        addfileButton_callback([],[]);
    case 2
        load_file_callback([],[]);
end

    function cancelButton_callback(~,~)
        close(f2);
    end

    function okButton_callback(~,~,handles)     
        if isempty(FILES)
            % If files_temp does not contain current file
            % Sets cur_file depending on selection
            if isempty(file_uitable.UserData)
                cur_file=1;
            else
                selection = file_uitable.UserData(:,1);
                cur_file=selection(1);
            end
            
        else
            cur_file = 1;
            % If files_temp contains current file
            for i=1:length(files_temp)
                if strcmp(files_temp(i).recording,FILES(CUR_FILE).recording)
                    cur_file = i;                  
                end
            end
        end
        
        % Update fullpath in Config.mat & files_temp
        for i =1:length(files_temp)
            % Loading Configuration
            data_c = load(fullfile(DIR_SAVE,files_temp(i).nlab,'Config.mat'),'File','UiValues');
            File = data_c.File;
            File.fullpath = fullfile(SEED,File.parent,File.session,File.recording);
            files_temp(i).fullpath = fullfile(SEED,File.parent,File.session,File.recording);
            % Saving Config.mat
            save(fullfile(DIR_SAVE,files_temp(i).nlab,'Config.mat'),'File','-append');
            % fprintf('File [%s] updated.\n',fullfile(DIR_SAVE,files_temp(i).nlab,'Config.mat'));
        end
        
        %Update files
        FILES = files_temp;
        CUR_FILE = cur_file;
        if ~isempty(FILES)
            str = strcat({FILES(:).parent}',filesep,{FILES(:).session}',filesep,{FILES(:).recording}');
        else
            str = '<0>';
        end
        % storing info   
        handles.FileSelectPopup.String = str;
        handles.FileSelectPopup.Value = cur_file;
        close(f2);
        fileSelectionPopup_Callback(handles.FileSelectPopup,[],handles);
        
        % Saving Files.mat
        save('Files.mat','FILES','CUR_FILE','str','-append');
        fprintf('Files.mat Saved %s.\n',fullfile(pwd,'Files.mat'));    
    end

    function addfileButton_callback(~,~)
        f2.Pointer = 'watch';
        drawnow;
        F = menuImportfile_Callback([],[],handles,1);
        f2.Pointer = 'arrow';
        if isempty(F)
            return;
        else
            % Sorting files
            files_temp = sortstruct(F,files_temp);
            file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',{files_temp.dir_fus}',{files_temp.video}'];
        end
    end

    function rmfileButton_callback(~,~)
        selection = get(file_uitable,'UserData');
        files_temp(unique(selection(:,1)))=[];
        file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',{files_temp.dir_fus}',{files_temp.video}'];
    end

    function fileInfoButton_callback(hObj,evnt)  
        selection = get(file_uitable,'UserData');
        if isempty(selection)
            errordlg('Select Files to display information.');
        else
            display_info_panel(selection);
        end
    end


    function load_file_callback (~,~)
        F = menuImportfile_Callback([],[],handles,2);
        if isempty(F)
            return;
        else
            % Sorting files
            files_temp = sortstruct(F,files_temp);
            file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',{files_temp.dir_fus}',{files_temp.video}'];
        end
    end

    function uitable_select(hObj,evnt) 
        hObj.UserData = evnt.Indices;
    end
end

function f = display_info_panel(all_files)

global SEED DIR_SAVE FILES;

% Display Parameters
W = 120;
H = 60;
ftsize = 10;
panelColor = get(0,'DefaultUicontrolBackgroundColor');
backColor = [.75 .75 .75];


f = figure('Units','characters',...
    'Position',[140 10 W H],...
    'HandleVisibility','callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'Toolbar','figure',...
    'NumberTitle','off',...
    'Name','Information Panel');

mainPanel = uipanel('FontSize',ftsize,...
    'Units','characters',...
    'Position',[0 0 W H],...
    'Parent',f);
pos = get(mainPanel,'Position');

tabgp = uitabgroup(mainPanel);

for i = 1:length(all_files)
    cur_file = all_files(i);
    
    tab1 = uitab(tabgp,'Title',FILES(cur_file).nlab);
    edits = [];
    load(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Config.mat'),'START_IM','CUR_IM','END_IM','LAST_IM');
    % Current File Info
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-6 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Image Information',...
        'Parent',tab1);
    e1 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-5.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'START_IM',...
        'String',START_IM,...
        'Parent',tab1);
    e2 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[42 pos(4)-5.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'CUR_IM',...
        'String',CUR_IM,...
        'Parent',tab1);
    e3 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[52 pos(4)-5.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'END_IM',...
        'String',END_IM,...
        'Parent',tab1);
    e4 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[62 pos(4)-5.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'LAST_IM',...
        'String',LAST_IM,...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-8 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Session type',...
        'Parent',tab1);
    e5a = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-7.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).type,...
        'TooltipString','Recording type',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-10 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Session Name',...
        'Parent',tab1);
    e5 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-9.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).session,...
        'TooltipString', '.session',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-12 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Recording Name',...
        'Parent',tab1);
    e6 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-11.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).recording,...
        'TooltipString', '.recording',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-14 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Video',...
        'Parent',tab1);
    e7 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-13.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).video,...
        'TooltipString', '.video',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-16 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','fUS File',...
        'Parent',tab1);
    e8 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-15.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).acq,...
        'TooltipString', '.acq',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-18 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','IQ file',...
        'Parent',tab1);
    e9 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-17.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).biq,...
        'TooltipString', '.biq',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-20 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS1 File',...
        'Parent',tab1);
    e10 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-19.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns1,...
        'TooltipString', '.ns1',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-22 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS2 File',...
        'Parent',tab1);
    e11 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-21.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns2,...
        'TooltipString', '.ns2',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-24 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS3 File',...
        'Parent',tab1);
    e12 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-23.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns3,...
        'TooltipString', '.ns3',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-26 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS4 File',...
        'Parent',tab1);
    e13 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-25.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns4,...
        'TooltipString', '.ns1',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-28 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS5 File',...
        'Parent',tab1);
    e14 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-27.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns5,...
        'TooltipString', '.ns5',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-30 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS6 File',...
        'Parent',tab1);
    e15 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-29.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ns6,...
        'TooltipString', '.ns6',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-32 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NEV File',...
        'Parent',tab1);
    e16 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-31.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).nev,...
        'TooltipString', '.nev',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-34 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','LFP Config file',...
        'Parent',tab1);
    e17 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-33.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).ncf,...
        'TooltipString', '.ncf',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-36 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','LFP Main Channel',...
        'Parent',tab1);
    e18 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-35.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).mainlfp,...
        'TooltipString', 'LFP Main channel',...
        'Parent',tab1);
    e18.String = FILES(cur_file).mainlfp;
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-38 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','EMG Main Channel',...
        'Parent',tab1);
    e18b = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-37.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).mainemg,...
        'TooltipString', 'EMG Main channel',...
        'Parent',tab1);
    e18b.String = FILES(cur_file).mainemg;
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-40 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','ACC Main Channel',...
        'Parent',tab1);
    e18c = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-39.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).mainacc,...
        'TooltipString', 'ACC Main channel',...
        'Parent',tab1);
    e18c.String = FILES(cur_file).mainacc;
    
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-42 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','LFP Directory',...
        'Parent',tab1);
    e19 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-41.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).dir_lfp,...
        'TooltipString', '.dir_lfp',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-44 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','External Directory',...
        'Parent',tab1);
    e40 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-43.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).dir_ext,...
        'TooltipString', '.dir_ext',...
        'Parent',tab1);
    % Loading normalization
    %     d1 = load(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Doppler.mat'));
    %     if ~isfield(d1,'normalization')
    %         d1.normalization = '';
    %     end
    %     if ~isfield(d1,'str_baseline')
    %         d1.str_baseline = '';
    %     end
    d_norm = load(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Doppler.mat'),'normalization');
    if ~isfield(d_norm,'normalization')
        d_norm.normalization = '';
    end
    d_str = load(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Doppler.mat'),'str_baseline');
    if ~isfield(d_str,'str_baseline')
        d_str.str_baseline = '';
    end
    d1.normalization = d_norm.normalization;
    d1.str_baseline = d_str.str_baseline;
    
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-46 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Doppler normalization',...
        'Parent',tab1);
    e21 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-45.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',sprintf('%s[%s]',d1.normalization,d1.str_baseline),...
        'TooltipString', 'normalization',...
        'Parent',tab1);
    d2.reference = '';
    d2.padding = '';
    if exist(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Time_Reference.mat'),'file')
        d2 = load(fullfile(DIR_SAVE,FILES(cur_file).nlab,'Time_Reference.mat'),'reference','padding');
    end
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-48 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Trigger',...
        'Parent',tab1);
    e22 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-47.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'TooltipString','Time Reference',...
        'Parent',tab1);
    e22.String = sprintf('%s [%s]',d2.reference,d2.padding);
    
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-50 30 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Atlas Information',...
        'Parent',tab1);
    e23a = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-49.5 18 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).atlas_name,...
        'TooltipString', 'Atlas Type',...
        'Parent',tab1);
    e23b = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[52 pos(4)-49.5 8 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).atlas_plate,...
        'TooltipString', 'Atlas Plate',...
        'Parent',tab1);
    e23c = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[62 pos(4)-49.5 8 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(cur_file).atlas_coordinate,...
        'TooltipString', 'Atlas Coordinate (mm)',...
        'Parent',tab1);
    
    e100 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[72 pos(4)-54 pos(3)-75 50],...
        'HorizontalAlignment', 'left',...
        'BackgroundColor','w',...
        'String','',...
        'TooltipString', 'File info',...
        'Parent',tab1);
    try
        fid = fopen(fullfile(SEED,FILES(cur_file).parent,FILES(cur_file).session,FILES(cur_file).info),'r');
        line_ex = {fgetl(fid)};
        while ~feof(fid)
            line_ex = [line_ex;{fgetl(fid)}];
        end
        e100.String = line_ex;
        fclose(fid);
    catch
        e100.String = '';
    end
    %edits = [e1;e2;e3;e4;e5a;e5;e6;e7;e8;e9;e10;e11;e12;e13;e14;e15;e16;e17;e18;e18b;e19;e40;e21;e22;e100];
    edits.start_im = e1;
    edits.cur_im = e2;
    edits.end_im = e3;
    edits.last_im = e4;
    edits.type = e5a;
    edits.session = e5;
    edits.recording = e6;
    edits.video = e7;
    edits.fus = e8;
    edits.iq = e9;
    edits.ns1 = e10;
    edits.ns2 = e11;
    edits.ns3 = e12;
    edits.ns4 = e13;
    edits.ns5 = e14;
    edits.ns6 = e15;
    edits.nev = e16;
    edits.ncf = e17;
    edits.mainlfp = e18;
    edits.mainemg = e18b;
    edits.mainacc = e18c;
    edits.dir_lfp = e19;
    edits.dir_ext = e40;
    edits.norm = e21;
    edits.trigger = e22;
    edits.atlas_name = e23a;
    edits.atlas_plate = e23b;
    edits.atlas_coordinate = e23c;
    edits.info = e100;
    
    tab1.UserData.edits = edits;
end

% if ~isempty(evnt.Indices)
%     cur_file = evnt.Indices(1,1);
%     data = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Config.mat'));
%     % Loading normalization
%     data_norm = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Doppler.mat'));
%     if ~isfield(data_norm,'normalization')
%         data_norm.normalization = '';
%     end
%     data_ref.reference = '';
%     data_ref.padding = '';
%     if exist(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Time_Reference.mat'),'file')
%         data_ref = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Time_Reference.mat'),'reference','padding');
%     end
%     
%     edits.start_im.String = data.START_IM;
%     edits.cur_im.String = data.CUR_IM;
%     edits.end_im.String = data.END_IM;
%     edits.last_im.String = data.LAST_IM;
%     edits.type.String = files_temp(cur_file).type;
%     edits.session.String = files_temp(cur_file).session;
%     edits.recording.String = files_temp(cur_file).recording;
%     edits.video.String = files_temp(cur_file).video;
%     edits.fus.String = files_temp(cur_file).acq;
%     edits.iq.String = files_temp(cur_file).biq;
%     edits.ns1.String = files_temp(cur_file).ns1;
%     edits.ns2.String = files_temp(cur_file).ns2;
%     edits.ns3.String = files_temp(cur_file).ns3;
%     edits.ns4.String = files_temp(cur_file).ns4;
%     edits.ns5.String = files_temp(cur_file).ns5;
%     edits.ns6.String = files_temp(cur_file).ns6;
%     edits.nev.String = files_temp(cur_file).nev;
%     edits.ncf.String = files_temp(cur_file).ncf;
%     edits.mainlfp.String = files_temp(cur_file).mainlfp;
%     edits.mainemg.String = files_temp(cur_file).mainemg;
%     edits.mainacc.String = files_temp(cur_file).mainacc;
%     edits.dir_lfp.String = files_temp(cur_file).dir_lfp;
%     edits.dir_ext.String = files_temp(cur_file).dir_ext;
%     edits.norm.String = data_norm.normalization;
%     edits.atlas_name.String = files_temp(cur_file).atlas_name;
%     edits.atlas_plate.String = files_temp(cur_file).atlas_plate;
%     edits.atlas_coordinate.String = files_temp(cur_file).atlas_coordinate;
%     edits.trigger.String = sprintf('%s [%s]',data_ref.reference,data_ref.padding);
%     
%     try
%         fid = fopen(fullfile(SEED,files_temp(cur_file).parent,files_temp(cur_file).session,files_temp(cur_file).info),'r');
%         line_ex = {fgetl(fid)};
%         while ~feof(fid)
%             line_ex = [line_ex;{fgetl(fid)}];
%         end
%         edits.info.String = line_ex;
%         fclose(fid);
%     catch
%         edits.info.String = '';
%     end
% end

end

function Asorted = sortstruct(A,B)
% Sort Structures by field names

%Merges structures
if (nargin>1)
    A=[A,B];
end

% Sorting files
if isempty(A)
    Asorted=A;
else
    Afields = fieldnames(A);
    Acell = struct2cell(A);
    sz = size(Acell);
    Acell = reshape(Acell, sz(1), []);      % Px(MxN)
    Acell = Acell';                         % (MxN)xP
    Acell = sortrows(Acell,[2,2]);
    [~,idx] = unique(Acell(:,2));
    Acell = Acell(idx,:);
    sz = [sz(1),sz(2),size(Acell,1)];
    Acell = reshape(Acell', sz);
    Asorted = cell2struct(Acell, Afields, 1);
end

end