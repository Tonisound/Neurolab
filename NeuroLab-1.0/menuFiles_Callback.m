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
W = 120;
H = 50;
ftsize = 10;
panelColor = get(0,'DefaultUicontrolBackgroundColor');
backColor = [.75 .75 .75];

% Creating Dialog Box
f2 = dialog('Units','characters',...
    'Position',[30 30 W H],...
    'HandleVisibility','callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'Toolbar','figure',...
    'NumberTitle','off',...
    'Name','File Selection');
%f2.DeleteFcn = {@delete_fcn,handles}; 

mainPanel = uipanel('FontSize',ftsize,...
    'Units','characters',...
    'Position',[0 6 W H-6],...
    'Parent',f2);
pos = get(mainPanel,'Position');

tabgp = uitabgroup(mainPanel);
tab0 = uitab(tabgp,'Title','Files');

edits = [];
if ~isempty(FILES)
    tab1 = uitab(tabgp,'Title','Current File Info');
    load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Config.mat'),'START_IM','CUR_IM','END_IM','LAST_IM');
    % Current File Info
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-7 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Image Information',...
        'Parent',tab1);
    e1 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-6.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'START_IM',...
        'String',START_IM,...
        'Parent',tab1);
    e2 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[32 pos(4)-6.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'CUR_IM',...
        'String',CUR_IM,...
        'Parent',tab1);
    e3 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[42 pos(4)-6.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'END_IM',...
        'String',END_IM,...
        'Parent',tab1);
    e4 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[52 pos(4)-6.5 8 1.5],...
        'BackgroundColor',backColor,...
        'TooltipString', 'LAST_IM',...
        'String',LAST_IM,...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-9 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Session Name',...
        'Parent',tab1);
    e5 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-8.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).session,...
        'TooltipString', '.session',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-11 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Recording Name',...
        'Parent',tab1);
    e6 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-10.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).recording,...
        'TooltipString', '.recording',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-13 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Video',...
        'Parent',tab1);
    e7 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-12.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).video,...
        'TooltipString', '.video',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-15 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','fUS File',...
        'Parent',tab1);
    e8 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-14.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).acq,...
        'TooltipString', '.acq',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-17 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','IQ file',...
        'Parent',tab1);
    e9 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-16.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).biq,...
        'TooltipString', '.biq',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-19 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS1 Directory',...
        'Parent',tab1);
    e10 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-18.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns1,...
        'TooltipString', '.ns1',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-21 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS2 Directory',...
        'Parent',tab1);
    e11 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-20.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns2,...
        'TooltipString', '.ns2',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-23 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS3 Directory',...
        'Parent',tab1);
    e12 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-22.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns3,...
        'TooltipString', '.ns3',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-25 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS4 Directory',...
        'Parent',tab1);
    e13 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-24.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns4,...
        'TooltipString', '.ns1',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-27 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS5 Directory',...
        'Parent',tab1);
    e14 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-26.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns5,...
        'TooltipString', '.ns5',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-29 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NS6 Directory',...
        'Parent',tab1);
    e15 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-28.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ns6,...
        'TooltipString', '.ns6',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-31 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','NEV Directory',...
        'Parent',tab1);
    e16 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-30.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).nev,...
        'TooltipString', '.nev',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-33 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Channel Configuration',...
        'Parent',tab1);
    e16b = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-32.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ccf,...
        'TooltipString', '.ccf',...
        'Parent',tab1);
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-35 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Raster Configuration',...
        'Parent',tab1);
    e16c = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-34.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).rcf,...
        'TooltipString', '.rcf',...
        'Parent',tab1);
    
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-37 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Session type',...
        'Parent',tab1);
    e17 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-36.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).type,...
        'TooltipString', '.type',...
        'Parent',tab1);
    
    d1.normalization = '';
    if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Doppler_normalized.mat'),'file')
        d1 = load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Doppler_normalized.mat'),'normalization');
    end
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-39 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Doppler normalization',...
        'Parent',tab1);
    e18 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-38.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',d1.normalization,...
        'TooltipString', 'normalization',...
        'Parent',tab1);
    d2.reference = '';
    if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'file')
        d2 = load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'reference');
    end
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-41 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Trigger',...
        'Parent',tab1);
    e19 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-40.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'TooltipString','Time Reference',...
        'Parent',tab1);
    e19.String = d2.reference;
    uicontrol('Style','text',...
        'Units','characters',...
        'Position',[2 pos(4)-43 20 2],...
        'BackgroundColor',panelColor,...
        'HorizontalAlignment', 'left',...
        'String','Nconfig File',...
        'Parent',tab1);
    e20 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[22 pos(4)-42.5 38 1.5],...
        'BackgroundColor',backColor,...
        'HorizontalAlignment', 'left',...
        'String',FILES(CUR_FILE).ncf,...
        'TooltipString','Cereplex Configuration',...
        'Parent',tab1);
    
    
    e100 = uicontrol('Style','text',...
        'Units','characters',...
        'Position',[62 pos(4)-43 52 38],...
        'HorizontalAlignment', 'left',...
        'BackgroundColor','w',...
        'String','',...
        'TooltipString', 'File info',...
        'Parent',tab1);
    try
        fid = fopen(fullfile(SEED,FILES(CUR_FILE).parent,FILES(CUR_FILE).session,FILES(CUR_FILE).info),'r');
        line_ex = {fgetl(fid)};
        while ~feof(fid)
            line_ex = [line_ex;{fgetl(fid)}];
        end
        e100.String = line_ex;
        fclose(fid);
    catch
        e100.String = '';
    end
    edits = [e1;e2;e3;e4;e5;e6;e7;e8;e9;e10;e11;e12;e13;e14;e15;e16;e16b;e16c;e17;e18;e19;e20;e100];

end


% Files Selection Table
file_uitable = uitable('ColumnName',{'Session','nlab','fUS','Video'},...
    'ColumnFormat',{'char','char','char','char'},...
    'ColumnEditable',[false,false,false,false],...
    'ColumnWidth',{160 160 160 160},...
    'Units','characters',...
    'Position',[0 0 120 40],...
    'CellSelectionCallback',{@uitable_select,edits},...
    'Parent',tab0);
%file_uitable.CellSelectionCallback = {@(src,evnt)set(src,'UserData',evnt.Indices)};

if ~isempty(files_temp)
    file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',{files_temp.dir_fus}',...
        {files_temp.video}'];
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
    'Position',[W/2 3 W/8 2],...
    'String','Remove',...
    'Parent',f2);

rmallfilesButton = uicontrol('Style','pushbutton',...
    'Units','characters',...
    'Position',[5*W/8 3 W/8 2],...
    'String','Remove all',...
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
set(rmallfilesButton,'Callback',@rmallfilesButton_callback);

switch flag
    case 1
        addfileButton_callback([],[]);
    case 2
        load_file_callback([],[]);
    case 3
        %rmfileButton_callback([],[])
    case 4
        rmallfilesButton_callback([],[]);
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
        
        %Update files
        FILES = files_temp;
        CUR_FILE = cur_file;
        if ~isempty(FILES)
            str = strcat({FILES(:).parent}','/',{FILES(:).session}','/',{FILES(:).recording}');
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

    function rmallfilesButton_callback(~,~)
        files_temp(1:length(files_temp))=[];
        file_uitable.Data = [{files_temp.session}',{files_temp.nlab}',{files_temp.dir_fus}',{files_temp.video}'];
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

    function uitable_select(hObj,evnt,edits)
        
        hObj.UserData = evnt.Indices;
        if ~isempty(evnt.Indices)
            cur_file = evnt.Indices(1,1);
            data = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Config.mat'));
            data_norm.normalization = '';
            if exist(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Doppler_normalized.mat'),'file')
                data_norm = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Doppler_normalized.mat'),'normalization');
            end
            data_ref.reference = '';
            if exist(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Time_Reference.mat'),'file')
                data_ref = load(fullfile(DIR_SAVE,files_temp(cur_file).nlab,'Time_Reference.mat'),'reference');
            end
            
            edits(1).String = data.START_IM;
            edits(2).String = data.CUR_IM;
            edits(3).String = data.END_IM;
            edits(4).String = data.LAST_IM;
            edits(5).String = files_temp(cur_file).session;
            edits(6).String = files_temp(cur_file).recording;
            edits(7).String = files_temp(cur_file).video;
            edits(8).String = files_temp(cur_file).acq;
            edits(9).String = files_temp(cur_file).biq;
            edits(10).String = files_temp(cur_file).ns1;
            edits(11).String = files_temp(cur_file).ns2;
            edits(12).String = files_temp(cur_file).ns3;
            edits(13).String = files_temp(cur_file).ns4;
            edits(14).String = files_temp(cur_file).ns5;
            edits(15).String = files_temp(cur_file).ns6;
            edits(16).String = files_temp(cur_file).nev;
            edits(17).String = files_temp(cur_file).ccf;
            edits(18).String = files_temp(cur_file).rcf;
            edits(19).String = files_temp(cur_file).type;
            edits(20).String = data_norm.normalization;
            edits(21).String = data_ref.reference;
            edits(22).String = files_temp(cur_file).ncf;
            
            try
                fid = fopen(fullfile(SEED,files_temp(cur_file).parent,files_temp(cur_file).session,files_temp(cur_file).info),'r');
                line_ex = {fgetl(fid)};
                while ~feof(fid)
                    line_ex = [line_ex;{fgetl(fid)}];
                end
                edits(23).String = line_ex;
                fclose(fid);
            catch
                edits(23).String = '';
            end
        end 
    end
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