function f = edit_patches(handles)

%global DIR_SAVE FILES CUR_FILE 
global START_IM END_IM IM;

f = figure('Name','Anatomical Regions Edition',...
    'NumberTitle','off',...
    'Units','normalized',...
    'MenuBar','none',...
    'Tag','EditFigure');
colormap(f,'gray');
clrmenu(f);
%colormap(f,'jet');

ax = copyobj(handles.CenterAxes,f);
ax.Tag = 'AxEdit';
ax.TickLength = [0 0];
ax.XTickLabel = '';
ax.YTickLabel = '';
ax.XLabel.String ='';
ax.YLabel.String ='';
axis(ax,'off');

% Region Table
w_col = 100;
w_margin = 4;
table_region = uitable('Units','normalized',...
    'Position',[0 0 1 1],...
    'ColumnFormat',{'char'},...
    'ColumnWidth',{w_col},...
    'ColumnEditable',false,...
    'ColumnName','',...
    'Data',[],...
    'RowName','',...
    'Tag','Region_table',...
    'CellSelectionCallback',@uitable_select,...
    'RowStriping','on',...
    'Parent',f);
% Adjust Columns
table_region.Units = 'pixels';
table_region.ColumnWidth ={table_region.Position(3)-w_margin};
table_region.Units = 'normalized';
table_region.UserData.Selection = [];

% OK & CANCEL Buttons
boxMask = uicontrol('Style','checkbox',...
    'Units','normalized',...
    'String','Mask Display',...
    'Tag','boxMask',...
    'Parent',f);
newButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','New',...
    'Tag','newButton',...
    'Parent',f);
drawButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','Draw',...
    'Tag','drawButton',...
    'Parent',f);
applyButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','Apply',...
    'Tag','applyButton',...
    'Parent',f);
removeButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','Remove',...
    'Tag','removeButton',...
    'Parent',f);

okButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','OK',...
    'Tag','okButton',...
    'Parent',f);
cancelButton = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','Cancel',...
    'Tag','cancelButton',...
    'Parent',f);

%Graphic position
ax.Position = [.3 .05 .5 .9];
f.Position = [.1 .1 .4 .4];
table_region.Position = [.05 .05 .2 .9];

newButton.Position = [.825 .9 .15 .05];
drawButton.Position = [.825 .85 .15 .05];
applyButton.Position = [.825 .8 .15 .05];
removeButton.Position = [.825 .75 .15 .05];
boxMask.Position = [.825 .15 .15 .05];
okButton.Position = [.825 .1 .15 .05];
cancelButton.Position = [.825 .05 .15 .05];


handles2 = guihandles(f);
set(newButton,'Callback',{@newButton_callback,handles2});
set(drawButton,'Callback',{@drawButton_callback,handles2});
set(applyButton,'Callback',{@applyButton_callback,handles2});
set(removeButton,'Callback',{@removeButton_callback,handles2});
set(okButton,'Callback',{@okButton_callback,handles,handles2});
set(cancelButton,'Callback',{@cancelButton_callback,handles2});
set(boxMask,'Callback',{@boxMask_Callback,handles2});


% Changing main image
main_im = mean(IM(:,:,START_IM:END_IM),3);
im = findobj(ax,'Tag','MainImage');
im.CData = main_im;

% Intialization
im.AlphaData = ones(size(main_im));
% Searching patches
patches = flipud(findobj(ax,'Tag','Region'));
str_popup = [];
for i = 1:length(patches)
    patches(i).Visible = 'on';
    patches(i).EdgeColor = patches(i).FaceColor;
    patches(i).FaceColor ='none';
    patches(i).LineWidth = 1;
    patches(i).MarkerSize =1;
    %patches(i).FaceAlpha = 0;
    str_popup = [str_popup;{patches(i).UserData.UserData.Name}];
    % changing Tag to handle patches
    patches(i).Tag = patches(i).UserData.UserData.Name;
end
table_region.Data = cellstr(str_popup);
table_region.UserData.patches = patches;

end


function newButton_callback(~,~,handles)

answer = inputdlg('Enter Region Name','Region creation',[1 60]);
while contains(char(answer),handles.Region_table.Data)
    answer = inputdlg('Enter Region Name','Invalid name (Region already exists)',[1 60]);
end

if ~isempty(answer)
    return
end


%creation
delete(handles.Region_table.UserData.patches(selection));
handles.Region_table.UserData.patches(selection)=[];
handles.Region_table.Data(selection,:)=[];

% actual creation
hl = line('XData',X(:),...
    'YData',Y(:),...
    'Color',color,...
    'Tag','Trace_Region',...
    'HitTest','off',...
    'Visible','off',...
    'LineWidth',l_width,...
    'Parent',handles.RightAxes);
% Updating UserData
s.Name = regions(ind_regions(i)).name;
s.Mask = regions(ind_regions(i)).mask;
s.Graphic = hq;
hq.UserData = hl;
hl.UserData = s;

end


function drawButton_callback(hObj,~,handles)
% Draw new temporary patch

delete(findobj(handles.AxEdit,'Tag','Marker'));
delete(findobj(handles.AxEdit,'Tag','Line'));

xdata = [];
ydata = [];
[x,y,button] = ginput(1);

while button==1
    % marker
    line(x,y,'Tag','Marker','Marker','o','MarkerSize',10,...
        'MarkerFaceColor','none','MarkerEdgeColor','w',...
        'Parent',handles.AxEdit);
    % line
    if ~isempty(xdata)
        line([x,xdata(end)],[y,ydata(end)],'Tag','Line',...
            'LineWidth',1,'Color','w','Parent',handles.AxEdit);
    end
    xdata = [xdata;x];
    ydata = [ydata;y];
    [x,y,button] = ginput(1);    
end

if length(xdata)>1
    line([xdata(1),xdata(end)],[ydata(1),ydata(end)],'Tag','Line',...
        'LineWidth',1,'Color','w','Parent',handles.AxEdit);
end

if ~isempty(xdata)
    hObj.UserData.xdata = xdata;
    hObj.UserData.ydata = ydata;
end

end

function applyButton_callback(~,~,handles)
% Apply changes in the Edit Figure

if ~isempty(handles.drawButton.UserData)
    xdata = handles.drawButton.UserData.xdata;
    ydata = handles.drawButton.UserData.ydata;
    selection = handles.Region_table.UserData.Selection;
    
    if ~isempty(selection)
        str = char(handles.Region_table.Data(selection,:));
        p = findobj(handles.EditFigure,'Tag',str);
        p.XData = xdata;
        p.YData = ydata;
    else
        errordlg('Select region to update.');
        return;
    end
    
    delete(findobj(handles.AxEdit,'Tag','Marker'));
    delete(findobj(handles.AxEdit,'Tag','Line'));
    handles.drawButton.UserData = [];
end

end

function removeButton_callback(~,~,handles)
% Remove temporary or selected patch

selection = handles.Region_table.UserData.Selection;

if ~isempty(handles.drawButton.UserData)
    delete(findobj(handles.AxEdit,'Tag','Marker'));
    delete(findobj(handles.AxEdit,'Tag','Line'));
    handles.drawButton.UserData = [];
elseif ~isempty(selection)
    delete(handles.Region_table.UserData.patches(selection));   
    handles.Region_table.UserData.patches(selection)=[];
    handles.Region_table.Data(selection,:)=[];
else
    errordlg('Select region to remove.');
    return;
end

end

function cancelButton_callback(~,~,handles2)
    close(handles2.EditFigure);
end

function okButton_callback(~,~,handles,handles2)
% Apply changes in the Main Figure

true_patches = findobj(handles.CenterAxes,'Tag','Region');
flag_change = false;

for i =1:length(true_patches)
    patch_name = true_patches(i).UserData.UserData.Name;
    new_patch = findobj(handles2.EditFigure,'Tag',patch_name);

    if length(true_patches(i).XData)~=length(new_patch.XData) || sum(true_patches(i).XData-round(new_patch.XData))~=0
        flag_change = true;
        % Update true patch
        true_patches(i).YData = round(new_patch.YData);
        true_patches(i).XData = round(new_patch.XData);
        % Update mask
        [x_mask,y_mask] = size(true_patches(i).UserData.UserData.Mask);
        new_mask = poly2mask(new_patch.XData,new_patch.YData,x_mask,y_mask);
        true_patches(i).UserData.UserData.Mask = double(new_mask);
    end
end

% Close figure and actualize traces
close(handles2.EditFigure);
if flag_change
    actualize_traces(handles);
end

end

function boxMask_Callback(src,~,handles)

hm = findobj(handles.AxEdit,'Type','Patch','-not','Tag','Box');
im = findobj(handles.AxEdit,'Tag','MainImage');

if src.Value 
    %draw mask 
    for i =1:length(hm)
        color = hm(i).EdgeColor;
        color_mask = cat(3, color(1)*ones(size(im.CData)),color(2)*ones(size(im.CData)),color(3)*ones(size(im.CData)));
        mask = hm(i).UserData.UserData.Mask;
        image('CData',color_mask,...
            'Parent',handles.AxEdit,...
            'Tag','Mask',...
            'Hittest','off',...
            'AlphaData',edge(mask,'canny'));
        hm(i).Visible = 'off';
    end
    
else
    %draw mask
    delete(findobj(handles.AxEdit,'Tag','Mask'));
    for i =1:length(hm)
        hm(i).Visible = 'on';
    end
end

end

function uitable_select(hObj,evnt)

if ~isempty(evnt.Indices)
    hObj.UserData.Selection = unique(evnt.Indices(1,1));
else
    hObj.UserData.Selection = [];
end

% Highlight patch
patches = hObj.UserData.patches;
for i =1:length(patches)
     patches(i).LineWidth = 1;
     patches(i).FaceColor = 'none';
end
if ~isempty(hObj.UserData.Selection)
    patches(hObj.UserData.Selection).LineWidth = 2;
    patches(hObj.UserData.Selection).FaceColor = patches(hObj.UserData.Selection).EdgeColor;
end

end