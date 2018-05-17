function initialize_Files()
% Initialize Preferences.mat
% Default Values used when Files.mat Files is missing or during Reset

FILES = struct('session',{},'recording',{},'parent',{},'fullpath',{},'info',{},'video',{},'dir_fus',{},'acq',{},'biq',{},...
    'ns1',{},'ns2',{},'ns3',{},'ns4',{},'ns5',{},'ns6',{},'nev',{},'ccf',{},'rcf',{},'nlab',{},'type',{});
CUR_FILE = 1;
str='<0>';

UiValues.CenterPanelPopup = 1;
UiValues.ProcessListPopup = 1;
UiValues.FigureListPopup = 1;
UiValues.RightPanelPopup = 1;
UiValues.TagSelection ='';
UiValues.LabelBox = 0;
UiValues.PatchBox = 0;
UiValues.MaskBox = 0;
UiValues.video_status = 'off';
UiValues_default = UiValues;

save('Files.mat','FILES','CUR_FILE','str','UiValues','UiValues_default');
fprintf('File Files.mat created %s.\n',fullfile(pwd,'Files.mat'));

end