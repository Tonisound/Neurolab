function success = actualize_traces(handles)
% Actualize Right Panel Traces when user modifies IM

global DIR_SAVE FILES CUR_FILE IM ;
success = false;

indexes  = isinf(1./IM);
if size(IM,1)*size(IM,2)*(size(IM,3)-1) == sum(indexes(:))
    choice = questdlg('fUSLab is going to modify traces without loading Doppler',...
            'User Confirmation','Proceed','Load Doppler','Cancel','Cancel');
        % Proceed, cancel, update
        if ~isempty(choice)
            switch choice
                case 'Cancel'
                    warning('Actualize traces canceled.\n');
                    return;
                case 'Proceed'
                    warning('Proceeding.\n');
                case 'Load Doppler'
                    load('Preferences.mat','GImport');
                    GImport.Doppler_loading = 'full';
                    GImport.Doppler_loading_index = 1;
                    save('Preferences.mat','GImport','-append');
            end
        end
end

if exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'file')
    load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Reference.mat'),'time_ref','length_burst','n_burst');
else
    warning('Missing File Time_Reference.mat');
    length_burst = size(IM,3);
    n_burst =1;
end

% Update XData, YData for Mean
tm = findobj(handles.RightAxes,'Tag','Trace_Mean');
%tm.YData(~isnan(tm.YData)) = mean(mean(IM,2,'omitnan'),1,'omitnan');
tm.YData(1:end-1) = mean(mean(IM,2,'omitnan'),1,'omitnan');

% Update YData for Mean, Lines and Boxes
graphics = findobj(handles.CenterAxes,'Type','Patch','-or','Type','Line');
for idx =1:length(graphics)
    fprintf('Actualizing trace %d (%s)\n',idx,graphics(idx).UserData.UserData.Name);
    switch graphics(idx).Tag
        case 'Pixel'
            pt_cp(1,1) = graphics(idx).XData;
            pt_cp(1,2) = graphics(idx).YData;
            %graphics(idx).UserData.YData(~isnan(graphics(idx).UserData.YData)) = IM(pt_cp(1,2),pt_cp(1,1),:);
            graphics(idx).UserData.YData(1:end-1) = IM(pt_cp(1,2),pt_cp(1,1),:);
        case 'Box'
            reg_y = graphics(idx).XData;
            reg_x = graphics(idx).YData;
            i = min(reg_x(1),reg_x(2));
            j = min(reg_y(3),reg_y(2));
            I = max(reg_x(1),reg_x(2));
            J = max(reg_y(3),reg_y(2));
            %graphics(idx).UserData.YData(~isnan(graphics(idx).UserData.YData)) = mean(mean(IM(i:I,j:J,:),2,'omitnan'),1,'omitnan');
            graphics(idx).UserData.YData(1:end-1) = mean(mean(IM(i:I,j:J,:),2,'omitnan'),1,'omitnan');
        case 'Region'
            im_mask = graphics(idx).UserData.UserData.Mask;
            im_mask(im_mask==0)=NaN;
            im_mask = IM.*repmat(im_mask,1,1,size(IM,3));
            %graphics(idx).UserData.YData(~isnan(graphics(idx).UserData.YData)) = mean(mean(im_mask,2,'omitnan'),1,'omitnan');
            graphics(idx).UserData.YData(1:end-1) = mean(mean(im_mask,2,'omitnan'),1,'omitnan');
    end
end

success = true;

end