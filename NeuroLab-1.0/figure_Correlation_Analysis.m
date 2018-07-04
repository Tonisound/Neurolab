function f2 = figure_Correlation_Analysis(myhandles,val,str_group)

global DIR_SAVE CUR_IM START_IM END_IM FILES CUR_FILE;

if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'file')
    load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'time_ref');
else
    errordlg(sprintf('Missing File %s',fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat')));
    return;
end

if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Tags.mat'),'file')
    load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Tags.mat'),'TimeTags_cell','TimeTags_images','TimeTags_strings');
else
    errordlg(sprintf('Missing File %s',fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Tags.mat')));
    return;
end

f2 = figure('Units','characters',...
    'HandleVisibility','Callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'MenuBar','figure',...
    'Toolbar','figure',...
    'NumberTitle','off',...
    'Tag','MainFigure',...
    'PaperPositionMode','auto',...
    'Name','Pixel Correlation');
clrmenu(f2);
colormap('jet');

% Information Panel
iP = uipanel('Units','normalized',...
    'Position',[0 .0 1 1/8],...
    'bordertype','etchedin',...
    'Tag','InfoPanel',...
    'Parent',f2);

t1 = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment',...
    'left','Parent',iP,...
    'String',sprintf('File : %s',FILES(CUR_FILE).nlab),...
    'Tag','Text1');
t2 = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String',sprintf('%s',myhandles.CenterPanelPopup.String(myhandles.CenterPanelPopup.Value,:)),...
    'Tag','Text2');
t3 = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String',sprintf('START_IM = %d (%s)',START_IM,myhandles.TimeDisplay.UserData(START_IM,:)),...
    'Tag','Text3');
t3.UserData = myhandles.TimeDisplay.UserData(START_IM,:);
t4 = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String',sprintf('END_IM = %d (%s)',END_IM,myhandles.TimeDisplay.UserData(END_IM,:)),...
    'Tag','Text4');
t4.UserData = myhandles.TimeDisplay.UserData(END_IM,:);

p1 = uicontrol('Units','normalized',...
    'Style','popupmenu',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String','<0>',...
    'Value',1,...
    'Tooltipstring','Reference Time Series',...
    'Tag','Popup1');
p2 = uicontrol('Units','normalized',...
    'Style','popupmenu',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String','Pearson|Kendall|SpearMan',...
    'Tooltipstring','Correlation Type',...
    'Value',1,'Tag','Popup2');
p3 = uicontrol('Units','normalized',...
    'Style','popupmenu',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String','both|right|left',...
    'Tooltipstring','P-value Hypothesis',...
    'Value',1,'Tag','Popup3');

s1 = uicontrol('Units','normalized',...
    'Style','slider',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'Tag','Slider');
t9 = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String',sprintf('Lag (s) : 0'),...
    'Tag','Text9');
t9.UserData.time_ref = time_ref;

c1 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'Value',1,...
    'TooltipString','Include reference in matrix',...
    'Tag','Checkbox1');
c2 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'Value',1,...
    'TooltipString','Automatic Slider Update',...
    'Tag','Checkbox2');

e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'Parent',iP,...
    'Tag','Edit1',...
    'Tooltipstring','Minimum Lag');
e2 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'Tag','Edit2',...
    'Tooltipstring','Maximum Lag');

bc = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Compute',...
    'Tag','ButtonCompute');
bi = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Save Images',...
    'Tag','ButtonSaveImage');
bs = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Save Stats',...
    'Tag','ButtonSaveStats');
br = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Reset',...
    'Tag','ButtonReset');
bb = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Batch',...
    'Tag','ButtonBatch');
br.UserData.ref_name = '';

% Setting Positions
t1.Position = [0     3/4 4/10   1/4];
t2.Position = [0     1/2   4/10   1/4];
t3.Position = [0     1/4   4/10   1/4];
t4.Position = [0     0            4/10   1/4];
p1.Position = [4/10     6.5/10   4/10   1/4];
p2.Position = [4/10     3.5/10   2/10   1/4];
p3.Position = [6/10     3.5/10   2/10   1/4];
t9.Position = [4/10     .5/10  1/10   1/5];
c1.Position = [5.2/10     2/10  1/20   1/6];
c2.Position = [5.2/10     0  1/20  1/6];
s1.Position = [6/10    .5/10  1.5/10   1/5];
e1.Position = [5.5/10    .5/10  .5/10   1/4];
e2.Position = [7.5/10    .5/10  .5/10   1/4];
bc.Position = [8/10     2/3      2/10   1/3];
br.Position = [8/10     1/3      1/10   1/3];
bb.Position = [9/10     1/3      1/10   1/3];
bs.Position = [8/10     0    1/10   1/3];
bi.Position = [9/10     0    1/10   1/3];

% Main Panel
mP = uipanel('Units','normalized',...
    'Position',[0 1/8 1 7/8],...
    'bordertype','etchedin',...
    'Tag','MainPanel',...
    'Parent',f2);

tabgp = uitabgroup('Units','normalized',...
    'Position',[0 0 1 1],...
    'Parent',mP,...
    'Tag','TabGroup');
tab1 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Correlation Map',...
    'Tag','MainTab');
tab2 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Propagation',...
    'Tag','SecondTab');
tab3 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Functional Connectivity',...
    'Tag','ThirdTab');
tab4 = uitab('Parent',tabgp,...
    'Units','normalized',...
    'Title','Traces & Tags',...
    'Tag','FourthTab');
% tab5 = uitab('Parent',tabgp,...
%     'Units','normalized',...
%     'Title','Dynamics',...
%     'Tag','FifthTab');

% Copying objects
% Center Panel Copy
% First Tab
cp = copyobj(myhandles.CenterPanel,tab1);
cp.Tag = 'CenterPanel';
cp.Units = 'normalized';
cp.Position = [0 0 1 1];
ax = findobj(cp,'Tag','CenterAxes');
c0 = colorbar(ax,'Tag','Colorbar0');
uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',cp,...
    'String',0,...
    'Tag','Cmin_0',...
    'Callback', {@update_caxis,ax,c0,1},...
    'Tooltipstring','CMin Main');
uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',cp,...
    'String',1,...
    'Tag','Cmax_0',...
    'Callback', {@update_caxis,ax,c0,2},...
    'Tooltipstring','CMax Main');
colormap(ax,'jet');

% Second Tab
% Auxilliary Panel 1
aP1 = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Position',[0 .5 1 .5],...
    'Tag','AuxPanel1',...
    'Parent',tab2);
ax1 = subplot(1,2,1,'Parent',aP1,'Tag','Ax1');
colormap(ax1,'jet');
title(ax1,'Variance Explained');
c1 = colorbar(ax1,'Tag','Colorbar1');
e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'String',0,...
    'Tag','Cmin_1',...
    'Callback', {@update_caxis,ax1,c1,1},...
    'Tooltipstring','CMin 2');
e2 =uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'String',1,...
    'Tag','Cmax_1',...
    'Callback', {@update_caxis,ax1,c1,2},...
    'Tooltipstring','CMax 2');
b1 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'Value',0,...
    'Tag','ThreshBox',...
    'Tooltipstring','Threshold Image');
t1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'String',.2,...
    'Tag','ThreshEdit',...
    'Tooltipstring','Threshold');
% Setting Positions
margin = .02;
w_button = .04;
w_box = .03;
b1.Position = [1/100     1/40      w_box  2*w_box];
t1.Position = [1/100     4/40      w_button  2*w_button];
ax1.Position = [3*margin 3*margin .4-margin .9-margin];
c1.Position = [.45 .15 .02 .7];
e1.Position = [9/20     .01      w_button   2*w_button];
e2.Position = [9/20     .9      w_button   2*w_button];

ax2 = subplot(1,2,2,'Tag','Ax2','Parent',aP1,'NextPlot','replace');
colormap(ax2,'jet');
title(ax2,'Peak Time (s)');
c2 = colorbar(ax2,'Tag','Colorbar2');
e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'String',0,...
    'Tag','Cmin_2',...
    'Callback', {@update_caxis,ax2,c2,1},...
    'Tooltipstring','CMin 2');
e2 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP1,...
    'String',1,...
    'Tag','Cmax_2',...
    'Callback', {@update_caxis,ax2,c2,2},...
    'Tooltipstring','CMax 2');
% Setting Positions
margin = .02;
w_button = .04;
ax2.Position = [.5+2*margin 3*margin .4-margin .9-margin];
c2.Position = [.95 .15 .02 .7];
e1.Position = [19/20     .01      w_button   2*w_button];
e2.Position = [19/20     .9      w_button   2*w_button];

% Auxilliary Panel 2
aP2 = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Position',[0 0 1 .5],...
    'Tag','AuxPanel2',...
    'Parent',tab2);
ax3 = subplot(1,2,1,'Parent',aP2,'Tag','Ax3');
colormap(ax3,'jet');
title(ax3,'Peak Correlations');

ax4 = subplot(1,2,2,'Tag','Ax4','Parent',aP2,'NextPlot','replace');
colormap(ax4,'jet');
title(ax4,'Time Lag Correlation');
c4 = colorbar(ax4,'Tag','Colorbar4');
e3 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP2,...
    'String',0,...
    'Tag','Cmin_4',...
    'Callback', {@update_caxis,ax4,c4,1},...
    'Tooltipstring','CMin 4');
e4 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP2,...
    'String',1,...
    'Tag','Cmax_4',...
    'Callback', {@update_caxis,ax4,c4,2},...
    'Tooltipstring','CMax 4');
% Setting Positions
margin = .02;
w_button = .04;
ax3.Position = [2*margin 6*margin .5-5*margin .9-4*margin];
ax4.Position = [.5+4*margin 6*margin .4-3*margin .9-4*margin];
c4.Position = [.95 .15 .02 .7];
e3.Position = [19/20     .01      w_button   2*w_button];
e4.Position = [19/20     .9      w_button   2*w_button];

% Third Tab
% Auxilliary Panel 3
aP3 = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Position',[0 0 1 1],...
    'Tag','AuxPanel3',...
    'Parent',tab3);
ax5 = subplot(1,1,1,'Parent',aP3,'Tag','Ax5','NextPlot','replacechildren');
colormap(ax5,'jet');
ax5.YDir = 'reverse';
caxis(ax5,[-1,1]);
title(ax5,'Correlogram');
c5 = colorbar(ax5,'Tag','Colorbar5');
e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP3,...
    'String',0,...
    'Tag','Cmin_5',...
    'Callback', {@update_caxis,ax5,c5,1},...
    'Tooltipstring','CMin 5');
e2 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',aP3,...
    'String',1,...
    'Tag','Cmax_5',...
    'Callback', {@update_caxis,ax5,c5,2},...
    'Tooltipstring','CMax 5');
t1 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',aP3,...
    'Value',0,...
    'Tag','TextBox',...
    'Tooltipstring','Numeric Correlogram');
% Setting Positions
margin = .02;
w_button = .04;
w_box = .03;
t1.Position = [1/100     1/40      w_box  2*w_box];
ax5.Position = [5*margin 6*margin 1-10*margin .9-4*margin];
c5.Position = [.95 .15 .02 .7];
e1.Position = [19/20     .01      w_button   2*w_button];
e2.Position = [19/20     .9      w_button   2*w_button];

% Fourth Tab
% Lines Array
m = findobj(myhandles.RightAxes,'Tag','Trace_Mean');
l = flipud(findobj(myhandles.RightAxes,'Type','line','-not','Tag','Cursor','-not','Tag','Trace_Cerep','-not','Tag','Trace_Mean'));
t = flipud(findobj(myhandles.RightAxes,'Tag','Trace_Cerep'));

lines_1 = [m;l];
lines_2 = t;

% Adding NaN values 
for i = 1:length(lines_2)
    lines_2(i).XData = [lines_2(i).XData,NaN];
    lines_2(i).YData = [lines_2(i).YData,NaN];
end

lines = [lines_1;lines_2];
bc.UserData.lines_1 = lines_1;
bc.UserData.lines_2 = lines_2;
p1.UserData.lines = lines;



%Regions Panel
rPanel = uipanel('Parent',tab4,...
    'Units','normalized',...
    'Position',[0 0 .25 1],...
    'Title','Regions',...
    'Tag','RegionPanel');
% Table Data
D = {m.UserData.Name,m.Tag};
for i =1:length(l)
    D=[D;{l(i).UserData.Name, l(i).Tag}];
end
rt = uitable('Units','normalized',...
    'ColumnName','',...
    'RowName',{},...
    'ColumnFormat',{'char','char'},...
    'ColumnEditable',[false,false],...
    'ColumnWidth',{120 120},...
    'Data',D,...
    'Position',[0 0 1 1],...
    'Tag','Region_table',...
    'CellSelectionCallback',@template_uitable_select,...
    'RowStriping','on',...
    'Parent',rPanel);
rt.UserData.Selection = strcmp(D(:,2),'Trace_Region');
%rt.UserData.Selection = (1:size(D,1))';

%Trace Panel
tPanel = uipanel('Parent',tab4,...
    'Units','normalized',...
    'Position',[.25 0 .25 1],...
    'Title','Traces',...
    'Tag','TracePanel');
% Table Data
D=[];
for i =1:length(t)
    D=[D;{t(i).UserData.Name, t(i).Tag}];
end
tt = uitable('Units','normalized',...
    'ColumnName','',...
    'RowName',{},...
    'ColumnFormat',{'char','char'},...
    'ColumnEditable',[false,false],...
    'ColumnWidth',{120 120},...
    'Data',D,...
    'Position',[0 0 1 1],...
    'Tag','Trace_table',...
    'CellSelectionCallback',@template_uitable_select,...
    'RowStriping','on',...
    'Parent',tPanel);
tt.UserData.Selection = [];

if isempty(tt.Data)
    p1.String = rt.Data(:,1);
else
    p1.String = [rt.Data(:,1);tt.Data(:,1)];
end

%Tag Panel
taPanel = uipanel('FontSize',10,...
    'Units','normalized',...
    'Position',[.5 0 .25 1],...
    'Title','Time Tags',...
    'Tag','Tag_Panel',...
    'Parent',tab4);
% UiTable
t = uitable('Units','normalized',...
    'ColumnName','',...
    'RowName',{},...
    'ColumnFormat',{'char','char','char'},...
    'ColumnEditable',[false,false,false],...
    'ColumnWidth',{70 70 70},...
    'Position',[0 0 1 1],...
    'Data',TimeTags_cell(2:end,2:4),...
    'Tag','Tag_table',...
    'CellSelectionCallback',@template_uitable_select,...
    'RowStriping','on',...
    'Parent',taPanel);
%Default Time tags Selection
% t.UserData.Selection = (myhandles.TagButton.UserData.Selected)';
t.UserData.Selection = [];
t.UserData.TimeTags_images = TimeTags_images;
t.UserData.TimeTags_strings = TimeTags_strings;


%Episode Panel
ePanel = uipanel('FontSize',10,...
    'Units','normalized',...
    'Position',[.75 0 .25 1],...
    'Title','Episodes',...
    'Tag','Episode_Panel',...
    'Parent',tab4);
% UiTable
et = uitable('Units','normalized',...
    'ColumnName','',...
    'RowName',{},...
    'ColumnFormat',{'char','char'},...
    'ColumnEditable',[false,false],...
    'ColumnWidth',{70 70},...
    'Position',[0 0 1 1],...
    'Data','',...
    'Tag','Episode_table',...
    'CellSelectionCallback',@template_uitable_select,...
    'RowStriping','on',...
    'Parent',ePanel);
et.UserData.Selection = [];

handles2 = guihandles(f2);
delete(handles2.CenterAxes.Title);
delete(handles2.CenterAxes.XLabel);
delete(handles2.CenterAxes.YLabel);

% Changing Units
handles2.PatchBox.Units = 'normalized';
handles2.MaskBox.Units = 'normalized';
handles2.TimeDisplay.Units = 'normalized';

% Resize Function Attribution
set(handles2.CenterPanel,'ResizeFcn',{@resize_mainPanel,handles2});
set(f2,'Position',[30 30 200 40]);    

% Interactive Control
set(handles2.MainFigure,'DeleteFcn',{@close_figure,CUR_IM,START_IM,END_IM});
caxis(handles2.CenterAxes,[-1,1]);

% Callback Function Attribution
set(handles2.PatchBox,'Callback',{@boxPatch_Callback,handles2});
set(handles2.MaskBox,'Callback',{@boxMask_Callback,handles2});

set(handles2.Slider,'Callback',{@slider_Callback,handles2});  
set(handles2.ButtonCompute,'Callback',{@compute_Callback,handles2});
set(handles2.ButtonSaveImage,'Callback',{@saveimage_Callback,handles2});
set(handles2.ButtonSaveStats,'Callback',{@savestats_Callback,handles2});
set(handles2.ButtonReset,'Callback',{@reset_Callback,handles2});
set(handles2.ButtonBatch,'Callback',{@batch_Correlation_Callback,handles2});
set(handles2.TextBox,'Callback',{@textbox_Callback,handles2});
set(handles2.Edit1,'Callback',{@edit_Callback,handles2});
set(handles2.Edit2,'Callback',{@edit_Callback,handles2});

% Push Button Reset
reset_Callback([],[],handles2);
handles2.MainFigure.Position = [30 10 150 60];
im = findobj(handles2.CenterAxes,'Tag','MainImage');
set(im,'CData',zeros(size(im)));
tabgp.SelectedTab = tab4;

% If nargin > 3 batch processing
% val indicates callback provenance (0 : batch mode - 1 : user mode)
% str_group contains group names 
if val==0
    batch_Correlation_Callback(handles2.ButtonBatch,[],handles2,str_group,1);
end

end

function close_figure(~,~,cur_im,start_im,end_im)

global CUR_IM START_IM END_IM;
CUR_IM = cur_im ;
START_IM = start_im;
END_IM = end_im;

end

function resize_mainPanel(~,~,handles)

margin = .04;
cpos = get(gcbo,'Position');

handles.PatchBox.Position = [0 cpos(4)*28/30 cpos(3)*2/30 cpos(4)*1.5/30];
handles.MaskBox.Position = [0 cpos(4)*26.5/30 cpos(3)*2/30 cpos(4)*1.5/30];
handles.TimeDisplay.Position = [0 cpos(4)*-.5/30 cpos(3)/4 cpos(4)*2/30];

handles.CenterAxes.Position = [2*margin 2*margin .9-2*margin 1-4*margin];
handles.Colorbar0.Position = [.92 .1 .04 .8];
handles.Cmin_0.Position = [27.5*cpos(3)/30 cpos(4)*.5/30 cpos(3)*2/30 cpos(4)*1.5/30];
handles.Cmax_0.Position = [27.5*cpos(3)/30 cpos(4)*27.5/30 cpos(3)*2/30 cpos(4)*1.5/30];

end

function update_caxis(hObj,~,ax,c,value)
for i=1:length(ax)
    switch value
        case 1
            ax(i).CLim(1) = str2double(hObj.String);
        case 2
            ax(i).CLim(2) = str2double(hObj.String);
    end
end
c.Limits = ax.CLim;
end

function textbox_Callback(hObj,~,handles)

t = findobj(handles.Ax5,'Type','text');
if hObj.Value
    status = 'on';
else
    status = 'off';
end
for k=1:length(t)
    t(k).Visible = status;
end

end

function edit_Callback(hObj,~,handles)

val = hObj.String;

switch hObj.Tag
    case 'Edit1'
        if isempty(str2num(val)) || round(str2num(val))>=0
            hObj.String = hObj.UserData.Previous;
        else
            hObj.String = round(str2num(val));
            hObj.UserData.Previous = hObj.String;
        end
    case 'Edit2'
        if isempty(str2num(val)) || round(str2num(val))<=0
           hObj.String = hObj.UserData.Previous;
        else
            hObj.String = round(str2num(val));
            hObj.UserData.Previous = hObj.String;
        end
end

handles.Slider.Min = str2double(handles.Edit1.String);
handles.Slider.Max = str2double(handles.Edit2.String);
handles.Slider.SliderStep = [1/abs(handles.Slider.Max-handles.Slider.Min) 5/abs(handles.Slider.Max-handles.Slider.Min)];

end

function slider_Callback(hObj,~,handles)

time_ref = handles.Text9.UserData.time_ref;
hObj.Value = round(hObj.Value);
handles.Text9.String = sprintf('Lag (s) : %.2f',(time_ref.Y(2)-time_ref.Y(1))*hObj.Value);
lags = hObj.Min:hObj.Max;

if ~isempty(hObj.UserData)
    % Update Correlation Map
    C_map = hObj.UserData.C_map;
    im = findobj(handles.CenterAxes,'Tag','MainImage');
    xlabel(handles.CenterAxes,sprintf('Lag = %.2f s',(time_ref.Y(2)-time_ref.Y(1))*hObj.Value));
    
    delete(findobj(handles.CenterAxes,'Type','text'));
    t = text(18,4,sprintf('Lag = %.2f s',(time_ref.Y(2)-time_ref.Y(1))*hObj.Value),...
            'BackgroundColor','none',...
            'FontSize',30,...
            'FontWeight','bold',...
            'Color',[0 0 0],...
            'Visible','on','Parent',handles.CenterAxes);
    
    ylabel(handles.CenterAxes,'');
    cmap = C_map(:,:,lags==hObj.Value);
    set(im,'CData',cmap);
    
end

end

function compute_Callback(hObj,~,handles)
% Compute Correlation Map
% Compute Correlogram

global START_IM END_IM IM DIR_SAVE FILES CUR_FILE;
load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'time_ref','length_burst','n_burst');

% Pointer Watch
set(handles.MainFigure, 'pointer', 'watch')
drawnow;
handles.MainFigure.UserData.success = false;

%Opening info file
clock_start = clock;
fid_info = fopen('_info.txt','w');

fwrite(fid_info,sprintf('%s \n',handles.Text1.String));
fwrite(fid_info,sprintf('Doppler type : %s \n',handles.Text2.String));

% Getting Visible Objects
lines_1 = hObj.UserData.lines_1;
lines_2 = hObj.UserData.lines_2;
lines_1 = lines_1(handles.Region_table.UserData.Selection);
lines_2 = lines_2(handles.Trace_table.UserData.Selection);
h_all = [lines_1;lines_2];

% Getting Reference
val = handles.Popup1.Value;
h_ref = handles.Popup1.UserData.lines(val);
ref_name = char(strtrim(handles.Popup1.String(val,:)));
ref_color = h_ref.Color;
xdata = h_ref.YData;
fwrite(fid_info,sprintf('Reference : %s \n',ref_name));
fwrite(fid_info,sprintf('Correlation type : %s \n',handles.Popup2.String(handles.Popup2.Value,:)));
fwrite(fid_info,sprintf('Stats type : %s \n',handles.Popup3.String(handles.Popup3.Value,:)));

% Adapting slider
% Getting Lags
if handles.Checkbox2.Value
    adapt_slider_batch(h_ref.Tag,handles);
end
lags = handles.Slider.Min:handles.Slider.Max;
fwrite(fid_info,sprintf('Lags : %s \n',mat2str(lags)));

handles.Slider.UserData.h_ref = h_ref;
handles.Slider.UserData.ref_name = ref_name;
handles.Slider.UserData.ref_color = ref_color;
fprintf('Reference Object : %s\n',ref_name);
handles.ButtonReset.UserData.ref_name = ref_name;

test_hother = ~handles.Checkbox1.Value;
if test_hother
    h_other = h_all(~ismember(h_all,h_ref));
else
    h_other = h_all;
end

% Selecting Time indices
if isempty(handles.Tag_table.UserData.Selection)
    % errordlg('Please Select Time Tags.');
    % return;
    TimeTags = [{'CURRENT'},{handles.Text3.UserData},{handles.Text4.UserData}];
    TimeTags_strings = [{handles.Text3.UserData},{handles.Text4.UserData}];
    TimeTags_images = [START_IM, END_IM];
else
    ind_tags = handles.Tag_table.UserData.Selection;
    TimeTags = handles.Tag_table.Data(ind_tags,:);
    TimeTags_strings = handles.Tag_table.UserData.TimeTags_strings(ind_tags,:);
    TimeTags_images = handles.Tag_table.UserData.TimeTags_images(ind_tags,:);
end

% Building Time_indices
Time_indices = zeros(size(IM,3),1);
indices = (1:size(IM,3))';
for k=1:size(TimeTags_images,1)
    selected = (indices>=TimeTags_images(k,1)).*(indices<=TimeTags_images(k,2));
    Time_indices(selected==1)=1;
end
for i=1:size(TimeTags_strings,1)
    fprintf('Time Reference %s [%s - %s]\n',char(TimeTags(i,1)),char(TimeTags_strings(i,1)),char(TimeTags_strings(i,2)));
    fwrite(fid_info,sprintf('Time Reference %s [%s - %s]\n',char(TimeTags(i,1)),char(TimeTags_strings(i,1)),char(TimeTags_strings(i,2))));
end

% Compute Correlation Map
str1 = strtrim(handles.Popup2.String(handles.Popup2.Value,:));
str2 = strtrim(handles.Popup3.String(handles.Popup3.Value,:));
[C_map,P_map] = compute_correlationmap(IM,xdata.^2,lags,Time_indices,str1,str2);
handles.Slider.UserData.C_map = C_map;
handles.Slider.UserData.P_map = P_map;
title(handles.CenterAxes,sprintf('Pixel Correlation map (Ref: %s)',ref_name));
im = findobj(handles.CenterAxes,'Tag','MainImage');
im.CData = (NaN(size(C_map,1),size(C_map,2)));
handles.Cmin_0.String = sprintf('%.1f',handles.CenterAxes.CLim(1));
handles.Cmax_0.String = sprintf('%.1f',handles.CenterAxes.CLim(2));

% Reshaping xdat 
xdat = reshape(xdata,[length_burst+1,n_burst]);
xdat = reshape(xdat(1:end-1,:),[length_burst*n_burst,1]);
xdat(Time_indices==0) = NaN;
% Adding NaN Values between each burst
Xdat = [reshape(xdat,[length_burst,n_burst]);NaN(length(lags),n_burst)];
Xdat = Xdat(:);
data = Xdat;
for k=1:length(h_other)
    color = h_other(k).Color;
    ydata = h_other(k).YData;
    % Reshaping ydat 
    ydat = reshape(ydata,[length_burst+1,n_burst]);
    ydat = reshape(ydat(1:end-1,:),[length_burst*n_burst,1]);
    ydat(Time_indices==0) = NaN;
    % Adding NaN Values between each burst
    Ydat = [reshape(ydat,[length_burst,n_burst]);NaN(length(lags),n_burst)];
    Ydat = Ydat(:);
    data = [data,Ydat];
end
handles.Slider.UserData.data = data;

% Correlogramm
str_labels = cell(1,size(data,2));
labels = cell(1,size(data,2));
labs = cell(1,size(data,2));
series = data;
str_t1 = strcat('{\color[rgb]',sprintf('{%.2f %.2f %.2f}',ref_color(1),ref_color(2),ref_color(3)),'[}');
str_t2 = strcat('{\color[rgb]',sprintf('{%.2f %.2f %.2f}',ref_color(1),ref_color(2),ref_color(3)),']}');
str = strcat('\bf{',sprintf('%s',ref_name),'}');
str_labels(1) = {sprintf('%s',ref_name)};
labels(1) = {strcat(str_t1,str,str_t2)};
labs(1) = {strcat(str_t1,ref_name(1:min(3,end)),ref_name(end-1:end),str_t2)};

for k=2:length(h_other)+1
    c_reg = h_other(k-1).Color;
    str_t1 = strcat('{\color[rgb]',sprintf('{%.2f %.2f %.2f}',c_reg(1),c_reg(2),c_reg(3)),'[}');
    str_t2 = strcat('{\color[rgb]',sprintf('{%.2f %.2f %.2f}',c_reg(1),c_reg(2),c_reg(3)),']}');
    name = h_other(k-1).UserData.Name;
    str_labels(k) = {sprintf('%s',name)};
    labels(k) = {strcat(str_t1,name,str_t2)};
    labs(k) = {strcat(str_t1,name(1:min(3,end)),name(max(4,end-4):end),str_t2)};
end

[Cor,P_cor] = compute_correlogramm(series,lags);
handles.Slider.UserData.Cor = Cor;
handles.Slider.UserData.P_cor = P_cor;
handles.Slider.UserData.str_labels = str_labels;

% Display Correlogram
imagesc(Cor(:,:,lags==0),'Parent',handles.Ax5,'Tag','Correlogram');
delete(findobj(handles.Ax5,'Type','text'));
if handles.TextBox.Value
    status = 'on';
else
    status = 'off';
end
for k=1:size(Cor,1)
    for j=1:size(Cor,2)
        text(j-.4,k,sprintf('%0.2f',Cor(k,j,lags==0)),...
            'BackgroundColor','none','Visible',status,'Parent',handles.Ax5);
    end
end
title(handles.Ax5,'Correlogram');
set(handles.Ax5,'XTick',1:length(labs),'XTickLabel', labs);
set(handles.Ax5,'YTick',1:length(labs),'YTickLabel', labels);
set(handles.Ax5, 'TickLength', [0 0]);
set(handles.Ax5,'XTickLabelRotation',90);
handles.Ax5.XLim = [.5, length(labs)+.5];
handles.Ax5.YLim = [.5, length(labs)+.5];
handles.Cmax_5.String = sprintf('%.1f',handles.Ax5.CLim(2));
handles.Cmin_5.String = sprintf('%.1f',handles.Ax5.CLim(1));

% Compute Peak-time image
delta = handles.Text9.UserData.time_ref.Y(2)-handles.Text9.UserData.time_ref.Y(1);
[im_max,t_max] = max(C_map,[],3);

% Display Max Image
cla(handles.Ax1);
im1 = imagesc('CData',im_max,...
    'Parent',handles.Ax1,...
    'Tag','MaxVarImage');
set(handles.Ax1, 'TickLength', [0 0]);
handles.Ax1.YDir = 'reverse';
handles.Ax1.XLim = [.5 size(im_max,2)+.5];
handles.Ax1.YLim = [.5 size(im_max,1)+.5];
handles.Cmax_1.String = sprintf('%.1f',handles.Ax1.CLim(2));
handles.Cmin_1.String = sprintf('%.1f',handles.Ax1.CLim(1));
handles.Ax1.YTick='';
handles.Ax1.XTick='';
title(handles.Ax1,'Max Correlation');
% Display Peak-time image
cla(handles.Ax2);
t_max = delta*lags(t_max);
im2 = imagesc('CData',t_max,...
    'Parent',handles.Ax2,...
    'Tag','MaxLagImage');
set(handles.Ax2, 'TickLength', [0 0]);
handles.Ax2.YDir = 'reverse';
handles.Ax2.XLim = [.5 size(t_max,2)+.5];
handles.Ax2.YLim = [.5 size(t_max,1)+.5];
handles.Ax2.CLim = [lags(1) lags(end)]*delta;
handles.Cmax_2.String = sprintf('%.1f',handles.Ax2.CLim(2));
handles.Cmin_2.String = sprintf('%.1f',handles.Ax2.CLim(1));
handles.Ax2.YTick='';
handles.Ax2.XTick='';
title(handles.Ax2,'Peak Correlation Map (s)');

thresh = str2double(handles.ThreshEdit.String);
if handles.ThreshBox.Value && thresh < max(max(im_max))
    thresh = str2double(handles.ThreshEdit.String);
    B  = im_max>thresh;
    im1.AlphaData = B;
    im2.AlphaData = B;
    handles.Ax1.CLim = [thresh,max(max(im_max))];
    handles.Cmin_1.String = sprintf('%.1f',handles.Ax1.CLim(1));
    update_caxis(handles.Cmin_1,[],handles.Ax1,handles.Colorbar1,1);
end

% Compute Time-lag Correlogram
A = permute(Cor(1,:,:),[2,3,1]);
lags_labels = cell(length(lags),1);
step = handles.Text9.UserData.time_ref.Y(2)-handles.Text9.UserData.time_ref.Y(1);
for i =1:2:length(lags)-1
    lags_labels(i) = {sprintf('%.1f',step*lags(i))};
end
lags_labels(length(lags)) = {sprintf('%.1f',step*lags(end))};

% Display Peak Correlations
cla(handles.Ax3);
[r_max,t_max] = max(A,[],2);
[r_min,t_min] = min(A,[],2);
x_ = lags*step;
x_max = x_(t_max)';
x_min = x_(t_min)';
for k=1:length(h_other)
    color = h_other(k).Color;
    if abs(r_max(k+1))>abs(r_min(k+1))
        r = r_max(k+1);
        x = x_max(k+1);
    else
        r = r_min(k+1);
        x = x_min(k+1);
    end
    line('XData',x,...
        'YData',r,...
        'LineStyle','none',...
        'Marker','o',...
        'MarkerSize',10,...
        'Tag',sprintf('ldata%d',k),...
        'MarkerFaceColor',color,...
        'MarkerEdgeColor',color,...
        'Parent',handles.Ax3);
end
handles.Ax3.XLim = [x_(1),x_(end)];
handles.Ax3.YLim = [-1,1];
handles.Ax3.XGrid = 'on';
handles.Ax3.YGrid = 'on';

% Display Time-Shift Correlogram
cla(handles.Ax4);
imagesc('CData',A,...
    'Parent',handles.Ax4,...
    'Tag','TimeLagCorr');
title(handles.Ax4,'Time Lag Correlation');
set(handles.Ax4,'YTick',1:length(labs),'YTickLabel', labels);
set(handles.Ax4, 'TickLength', [0 0]);
handles.Ax4.XLim = [.5, length(lags)+.5];
set(handles.Ax4,'XTick',1:length(lags),'XTickLabel',lags_labels);
handles.Ax4.XTickLabelRotation = 0;
handles.Ax4.YLim = [.5, length(labs)+.5];
handles.Ax4.YDir = 'reverse';
handles.Cmax_4.String = sprintf('%.1f',handles.Ax4.CLim(2));
handles.Cmin_4.String = sprintf('%.1f',handles.Ax4.CLim(1));
%box(handles.Ax4,'on');

% Update Text and Strings
handles.Text3.String = sprintf('START_IM = %d (%s)',START_IM,handles.TimeDisplay.UserData(START_IM,:));
handles.Text4.String = sprintf('END_IM = %d (%s)',END_IM,handles.TimeDisplay.UserData(END_IM,:));
handles.Slider.Value = 0;
handles.Text9.String = 'Lag (s) : 0';

% Calls Slider_Callback to update Axes Content
slider_Callback(handles.Slider,[],handles);
handles.TabGroup.SelectedTab = handles.MainTab;
set(handles.MainFigure, 'pointer', 'arrow');

% Copy time ot info file
clock_end = clock;
time_s = sprintf('Day %d-%d-%d - Time %d:%d:%.0f',clock_start(1),clock_start(2),clock_start(3),clock_start(4),clock_start(5),clock_start(6));
fwrite(fid_info,sprintf('Computation started %s \n',time_s));
time_e = sprintf('Day %d-%d-%d - Time %d:%d:%.0f',clock_end(1),clock_end(2),clock_end(3),clock_end(4),clock_end(5),clock_end(6));
fwrite(fid_info,sprintf('Computation ended time %s \n',time_e));    
fclose(fid_info);
handles.MainFigure.UserData.success = true;

end

function reset_Callback(~,~,handles)

global START_IM END_IM;

% Update Text
handles.Text3.String = sprintf('START_IM = %d (%s)',START_IM,handles.TimeDisplay.UserData(START_IM,:));
handles.Text4.String = sprintf('END_IM = %d (%s)',END_IM,handles.TimeDisplay.UserData(END_IM,:));
handles.Text9.String = 'Lag (s) : 0';

%Adapting Slider
handles.Edit1.String = -15;
handles.Edit2.String = 15;

handles.Edit1.UserData.Previous = handles.Edit1.String;
handles.Edit2.UserData.Previous = handles.Edit2.String;
handles.Slider.Min = str2double(handles.Edit1.String);
handles.Slider.Max = str2double(handles.Edit2.String);
handles.Slider.Value = 0;
handles.Slider.SliderStep = [1/abs(handles.Slider.Max-handles.Slider.Min) 5/abs(handles.Slider.Max-handles.Slider.Min)];

% Change Image by updating slider
slider_Callback(handles.Slider,[],handles);

end

function savestats_Callback(~,~,handles)

global DIR_SAVE FILES CUR_FILE DIR_STATS;
load('Preferences.mat','GTraces');

load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'n_burst');
if ~isempty(handles.ButtonBatch.UserData)
    folder_name = handles.ButtonBatch.UserData.folder_name;
%elseif ~isempty(handles.TagMenu_TimeGroupSelection.UserData)
%    folder_name = handles.TagMenu_TimeGroupSelection.UserData.Name;
else
    prompt={'Saving Directory (Recording Group)'};
    name = 'Name';
    defaultans = {'CURRENT'};
    answer = inputdlg(prompt,name,[1 40],defaultans);
    if ~isempty(answer)
        folder_name= char(answer);
    else
        return;
    end
end

% Creating Stats Directory
stats_dir = fullfile(DIR_STATS,'fUS_Correlation',FILES(CUR_FILE).nlab);
if ~isdir(stats_dir)
    mkdir(stats_dir);
end

ref_name = regexprep(strcat('Ref-',handles.ButtonReset.UserData.ref_name(1:min(end,20))),'/','-');
save_dir= fullfile(stats_dir,strcat(ref_name,'-',handles.Text2.String),folder_name);
work_dir = fullfile(save_dir,'Regions');
if isdir(save_dir)
    rmdir(save_dir,'s');
end
mkdir(save_dir);
mkdir(work_dir);
labels = handles.Slider.UserData.str_labels;

% Saving Stats
lags = handles.Slider.Min:handles.Slider.Max;
step = handles.Text9.UserData.time_ref.Y(2)-handles.Text9.UserData.time_ref.Y(1);
im4 = findobj(handles.Ax4,'type','image');
A = im4.CData;
[r_max,t_max] = max(A,[],2);
[r_min,t_min] = min(A,[],2);
x_ = lags*step;
x_max = x_(t_max)';
x_min = x_(t_min)';

UF.labels = labels;
UF.ref_name = ref_name;
UF.lags = lags;
UF.step = step;
save(fullfile(save_dir,'UF.mat'),'UF','-v7.3');
P_cor = handles.Slider.UserData.P_cor;
Cor = handles.Slider.UserData.Cor;
save(fullfile(save_dir,'fCorrelation.mat'),'Cor','P_cor','-v7.3');
C_map = handles.Slider.UserData.C_map;
P_map = handles.Slider.UserData.P_map;
save(fullfile(save_dir,'Full_map.mat'),'C_map','P_map','-v7.3');
im1 = findobj(handles.Ax1,'type','Image');
Rmax_map = im1.CData;
im2 = findobj(handles.Ax2,'type','Image');
Tmax_map = im2.CData;
RT_pattern = A;
save(fullfile(save_dir,'Correlation_pattern.mat'),'Rmax_map','Tmax_map','RT_pattern','-v7.3');

for k=2:length(labels)
    filename = regexprep(strcat(char(labels(k)),'.mat'),'/','-');
    rmax = r_max(k);
    tmax = x_max(k);
    rmin = r_min(k);
    tmin = x_min(k);
    save(fullfile(work_dir,filename),'rmax','tmax','rmin','tmin','-mat');
    fprintf('File %s Saved : Rmax %.2f t_max %.2f Rmin %.2f t_min %.2f.\n',filename,r_max(k),x_max(k),r_min(k),x_min(k));
end

%Copying info file to stats_dir
copyfile('_info.txt',save_dir);

end

function saveimage_Callback(~,~,handles)

global DIR_SAVE FILES CUR_FILE DIR_FIG;
load('Preferences.mat','GTraces');

load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'n_burst');

if ~isempty(handles.ButtonBatch.UserData)
    folder_name = handles.ButtonBatch.UserData.folder_name;
%elseif ~isempty(handles.TagMenu_TimeGroupSelection.UserData)
%    folder_name = handles.TagMenu_TimeGroupSelection.UserData.Name;
else
    prompt={'Saving Directory (Recording Group)'};
    name = 'Name';
    defaultans = {'CURRENT'};
    answer = inputdlg(prompt,name,[1 40],defaultans);
    if ~isempty(answer)
        folder_name= char(answer);
    else
        return;
    end
end

handles.TabGroup.SelectedTab = handles.MainTab;
val = handles.Slider.Value;
lags = handles.Slider.Min:handles.Slider.Max;

% Saving Video frame
ref_name = regexprep(strcat('Ref-',handles.ButtonReset.UserData.ref_name(1:min(end,20))),'/','-');
save_dir= fullfile(DIR_FIG,'fUS_Correlation',FILES(CUR_FILE).nlab,strcat(ref_name,'-',handles.Text2.String),folder_name);
work_dir = fullfile(DIR_FIG,'fUS_Correlation',FILES(CUR_FILE).nlab,strcat(ref_name,'-',handles.Text2.String),folder_name,'Frames');


% Removing old folder
if isdir(save_dir)
    rmdir(save_dir,'s');
end
mkdir(save_dir);
mkdir(work_dir);

% Saving 
for t = 1:length(lags)
    handles.Slider.Value = lags(t);
    slider_Callback(handles.Slider,[],handles);
    pic_name = strcat(sprintf('fUSCorrelation_%s_%03d',ref_name,t),GTraces.ImageSaveExtension);
    saveas(handles.MainFigure,fullfile(work_dir,pic_name),GTraces.ImageSaveFormat);
end
video_name = strcat(FILES(CUR_FILE).nlab,'-',strcat(ref_name,'-',handles.Text2.String));
save_video(work_dir,save_dir,video_name);

% Saving Tabs
handles.TabGroup.SelectedTab = handles.SecondTab;
pic_name = strcat(video_name,'_',handles.TabGroup.SelectedTab.Title);
saveas(handles.MainFigure,fullfile(save_dir,pic_name),GTraces.ImageSaveFormat);
fprintf('Image saved at %s.\n',fullfile(save_dir,pic_name));

handles.TabGroup.SelectedTab = handles.ThirdTab;
pic_name = strcat(video_name,'_',handles.TabGroup.SelectedTab.Title);
saveas(handles.MainFigure,fullfile(save_dir,pic_name),GTraces.ImageSaveFormat);
fprintf('Image saved at %s.\n',fullfile(save_dir,pic_name));

% handles.TabGroup.SelectedTab = handles.FourthTab;
% pic_name = strcat(video_name,'_',handles.TabGroup.SelectedTab.Title);
% saveas(handles.MainFigure,fullfile(save_dir,pic_name),GTraces.ImageSaveFormat);
% fprintf('Image saved at %s.\n',fullfile(save_dir,pic_name));

% Restore Figure
handles.TabGroup.SelectedTab = handles.MainTab;
handles.Slider.Value = val;
slider_Callback(handles.Slider,[],handles);

%Copying info file to stats_dir
copyfile('_info.txt',save_dir);

end

function adapt_slider_batch(tag,handles)

% Slider step Update
switch tag
    case {'Trace_Mean';'Trace_Region';'Trace_Box';'Trace_Pixel'}
        handles.Edit1.String = -10;
        handles.Edit2.String = 10;
    case {'Trace_Cerep'}
        handles.Edit1.String = -5;
        handles.Edit2.String = 15;
end


handles.Edit1.UserData.Previous = handles.Edit1.String;
handles.Edit2.UserData.Previous = handles.Edit2.String;
handles.Slider.Min = str2double(handles.Edit1.String);
handles.Slider.Max = str2double(handles.Edit2.String);
handles.Slider.Value = 0;
handles.Slider.SliderStep = [1/abs(handles.Slider.Max-handles.Slider.Min) 5/abs(handles.Slider.Max-handles.Slider.Min)];
drawnow;

end

function batch_Correlation_Callback(hObj,~,handles,str_group,v)

global DIR_SAVE FILES CUR_FILE;

if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Groups.mat'),'file')
    load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Groups.mat'),'TimeGroups_name','TimeGroups_frames','TimeGroups_duration','TimeGroups_S');
else
    errordlg(sprintf('Please edit Time_Groups.mat %s',fullfile(DIR_SAVE,FILES(CUR_FILE).nlab)));
    return;
end


if nargin == 3
    % If Manual Callback open inputdlg
    [ind_group,v] = listdlg('Name','Group Selection','PromptString','Select Time Groups',...
        'SelectionMode','multiple','ListString',TimeGroups_name,'InitialValue','','ListSize',[300 500]);
else
    % If batch mode, keep only elements in str_group
    ind_group = [];
    temp = TimeGroups_name;
    for i=1:length(temp)
        ind_keep = ~(cellfun('isempty',strfind(str_group,temp(i))));
        if sum(ind_keep)>0
            ind_group=[ind_group,i];
        end
    end  
end

if isempty(ind_group)||v==0
        return;
end

for i=1:length(ind_group)
    ii = ind_group(i);
    % Update Tag_table
    hObj.UserData.folder_name = char(TimeGroups_name(ii));
    handles.Tag_table.UserData.Selection = TimeGroups_S(ii).Selected';
    
    % Compute
    str_ref = {'DG-L'};
    %str_ref = {'Phasic';'Theta';'Gamma';'Whole';'ACCEL-POWER';'SPEED';'EMG-POWER'};
    for k =1:length(str_ref)
        p1 = handles.Popup1;
        bc = handles.ButtonCompute;
        ind_keep = ~(cellfun('isempty',strfind(p1.String,char(str_ref(k)))));
        ind_val = ind_keep.*(1:length(ind_keep))';
        
        for kk =1:length(ind_val)
            if ind_val(kk)> 0
                p1.Value = kk;
                compute_Callback(bc,[],handles);
                savestats_Callback([],[],handles);
                %saveimage_Callback([],[],handles);
                delete('_info.txt');
            end
        end
    end
end

end