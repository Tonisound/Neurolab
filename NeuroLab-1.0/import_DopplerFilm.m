function Doppler_film = import_DopplerFilm(F,handles,flag)
% Import Doppler mvoie from .acq file 
% Generates Configuration file Config.mat
% flag 0 - first import
% flag 1 - reimport

% Setting flag to 0 if unprecised
if nargin < 3
    flag =1;
end

global IM LAST_IM SEED DIR_SAVE;

% create Doppler.mat
if ~isempty(F.acq)
    file_mat = fullfile(SEED,F.parent,F.session,F.recording,F.dir_fus,regexprep(F.acq,'.acq','.mat'));
    file_acq = fullfile(SEED,F.parent,F.session,F.recording,F.dir_fus,F.acq);
    % rename .acq in .mat
    movefile(file_acq,file_mat);
    fprintf('Loading Doppler_film...');
    data = load(file_mat);
    fprintf(' done.\n');
    Doppler_film = permute(data.Acquisition.Data,[3,1,4,2]);
    % rename .mat in .acq
    movefile(file_mat,file_acq);
    
    % Checking Doppler
    ind_remove = check_Doppler(Doppler_film);
    Doppler_film(:,:,ind_remove) = NaN(size(Doppler_film,1),size(Doppler_film,2),sum(ind_remove));
    
    % Saving Doppler_film
    fprintf('Saving Doppler_film ...');
    save(fullfile(DIR_SAVE,F.nlab,'Doppler.mat'),'Doppler_film','ind_remove','-v7.3');
    handles.RightAxes.UserData.ind_remove = ind_remove;
    fprintf(' done.\n');
else
    warning('File .acq not found %s.\n',F.acq)
    Doppler_film = NaN(0,0,2);
end

% create and save Config.mat
if flag ==0
    START_IM = 1;
    CUR_IM = 1;
    END_IM = size(Doppler_film,3);
    LAST_IM = size(Doppler_film,3);
    X = size(Doppler_film,1);
    Y = size(Doppler_film,2);
    Current_Image = Doppler_film(X,Y,1);
    File = F;
    l = load('Files.mat','UiValues_default');
    UiValues = l.UiValues_default;
    save(fullfile(DIR_SAVE,F.nlab,'Config.mat'),...
        'START_IM','CUR_IM','END_IM','LAST_IM','X','Y','Current_Image','File','UiValues','-v7.3');
    fprintf('Config.mat saved.\n');
else
    % Updating global variables
    if handles.CenterPanelPopup.Value == 1
        IM = Doppler_film;
        LAST_IM = size(IM,3);
        actualize_traces(handles);
        actualize_plot(handles);
    end
    
end

end

function ind_remove = check_Doppler(Doppler_film)

% Check fUS
% Removing data points where variance is too high
t = (1:size(Doppler_film,3))';
test = permute(mean(mean(Doppler_film,2,'omitnan'),1,'omitnan'),[3,1,2]);
thresh = mean(test)+3*std(test);
ind_remove = test>thresh;
ind_keep = test<=thresh;
%test = (test-mean(test))/std(test);
%ind_remove = find(test.^2>9);

f = figure('Name','CheckDoppler');
ax = axes('Position',[.05 .2 .9 .75],'Parent',f);
ax.XLim = [.5,size(Doppler_film,3)+5];
ax.YLim = [min(test),max(test)];
ax.UserData = [];


line('XData',t,'YData',test,'Color','k','LineWidth',1,'Parent',ax);
l_thresh = line('XData',[.5,size(Doppler_film,3)+5],'YData',[thresh,thresh],'Color',[.5 .5 .5],'LineWidth',1,'Parent',ax);
l_keep = line('XData',t(ind_keep==1),'YData',test(ind_keep==1),'Color','b','Parent',ax);
l_rm = line('XData',t(ind_remove==1),'YData',test(ind_remove==1),'Color','r','LineStyle','none','Marker','o','Parent',ax);

okButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[.3 .025 .15 .1],'String','OK',...
    'Tag','okButton','Parent',f);
cancelButton = uicontrol('Style','pushbutton','Units','normalized',...
    'Position',[.55 .025 .15 .1],'String','Skip',...
    'Tag','cancelButton','Parent',f);
set(okButton,'Callback',{@okButton_callback});
set(cancelButton,'Callback',{@cancelButton_callback});
set(ax,'ButtonDownFcn',{@axes_clickFcn});

    function okButton_callback(~,~)
        %ax.UserData = l_rm.XData;
        close(f);
    end

    function cancelButton_callback(~,~)
        ind_remove = false(size(ind_remove));
        close(f);
    end

    function axes_clickFcn(hObj,~)
        pt_rp = get(hObj,'CurrentPoint');
        Xlim = get(hObj,'XLim');
        Ylim = get(hObj,'YLim');
        
        if(pt_rp(1,1)>Xlim(1) && pt_rp(1,1)<Xlim(2) && pt_rp(1,2)>Ylim(1) && pt_rp(1,2)<Ylim(2))
            thresh = pt_rp(1,2);
            ind_remove = test>thresh;
            ind_keep = test<=thresh;
            %Updating lines
            l_thresh.YData = [thresh, thresh];
            l_keep.XData = t(ind_keep==1);
            l_keep.YData = test(ind_keep==1);
            l_rm.XData = t(ind_remove==1);
            l_rm.YData = test(ind_remove==1);
        end
    end

waitfor(f);
return;

end

% Interpolate usinf ind_keep
% tic
% for i =1:size(Doppler_film,1)
%     for j =1:size(Doppler_film,2)
%         test = permute(Doppler_film(i,j,:),[3,1,2]);
%         test_interp = interp1(t(ind_keep),test(ind_keep),t);
%         test_interp = permute(test_interp,[2,3,1]);
%         Doppler_checked(i,j,:) = test_interp;
%     end
% end
% toc
%Doppler_checked = f.UserData;

% % Doppler Resampling
% delta_t = time_ref.Y(2)-time_ref.Y(1);
% if n_burst==1
%     rate = round(delta_t/GImport.resamp_cont);
% else
%     rate = round(delta_t/GImport.resamp_burst);
% end
% if rate>1
%     promptMessage = sprintf('fUSLab is about to resample by factor %d,\nThis will modify Doppler_film.\nDo you want to continue ?',rate);
%     button = questdlg(promptMessage, 'Continue', 'Continue', 'Cancel', 'Continue');
%     if strcmpi(button, 'Cancel')
%         return;
%     end
%     
%     % Reshaping Doppler_film
%     temp=[];
%     Doppler_line = reshape(permute(Doppler_film,[3,1,2]),[size(Doppler_film,3) size(IM,1)*size(Doppler_film,2)]);
%     Doppler_dummy = [Doppler_line;Doppler_line(end,:)];
%     Doppler_line = resample(Doppler_dummy,rate,1);
%     Doppler_line = Doppler_line(1:end-rate,:);
%     Doppler_resample = zeros(size(IM,1),size(IM,2),size(Doppler_line,1));
%     for k = 1:size(Doppler_line,1)
%         Doppler_resample(:,:,k) = reshape(Doppler_line(k,:),[size(IM,1),size(IM,2)]);
%         temp=[temp;time_ref.Y(ceil(k/rate))+(delta_t/rate*mod(k-1,rate))];
%     end
%     % Removing last image
%     for i = flip(length_burst*rate*(1:n_burst)')
%         Doppler_resample(:,:,i)=[];
%         temp(i)=[];
%     end
%     Doppler_film = Doppler_resample;
%     
%     % Reshaping time_ref
%     time_ref.Y = temp;
%     time_ref.X = (1:length(temp))';
%     time_ref.nb_images = length(time_ref.Y);
%     length_burst = length_burst*rate-1;
%         
% end
% 
% % Updating global variables
% IM = Doppler_film;
% LAST_IM = size(IM,3);
% % Saving Doppler_film
% save(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Doppler.mat'),'Doppler_film','-v7.3');
% fprintf('Doppler_film saved at %s.mat\n',fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Doppler.mat'));
