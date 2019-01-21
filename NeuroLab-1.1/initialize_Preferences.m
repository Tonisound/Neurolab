function success = initialize_Preferences()
% Initialize Preferences.mat
% Default Values used when Preference Files is missing or during Reset
success = false;

% Default options
str_disk_1 = fullfile('G:','DATA');
str_disk_2 = fullfile(filesep,'Volumes','ETNA','DATA');
str_disk_3 = fullfile(filesep,'Volumes','Toni_HD2','DATA_NLAB');
str_disk_4 = fullfile(filesep,'Users','tonio','Documents','DATA_NLAB');

str_save_1 = fullfile('D:','NEUROLAB');
str_save_2 = fullfile(filesep,'Users','tonio','Documents','NEUROLAB');

% Inputdlg to choose booting options
prompt={sprintf('(1) %s \n(2) %s \n(3) %s \n(4) %s',str_disk_1,str_disk_2,str_disk_3,str_disk_4);
    sprintf('(1) %s \n(2) %s',str_save_1,str_save_2)};
name = 'Booting options';
defaultans = {'1';'1'};
options.Interpreter = 'tex';
answer = inputdlg(prompt,name,[1 80],defaultans,options);

if isempty(answer)
    return;
end

switch strtrim(char(answer(1)))
    case '1'
        str_disk = str_disk_1;
    case '2'
        str_disk = str_disk_2;
    case '3'
        str_disk = str_disk_3;
    case '4'
        str_disk = str_disk_4;
    case ''
        return;
    otherwise
        str_disk = char(answer(1));
end 
switch strtrim(char(answer(2)))
    case '1'
        str_save = str_save_1;
    case '2'
        str_save = str_save_2;
    otherwise
        str_save = char(answer(2));
end

% Data Disk
%GParams.SEED = fullfile(str_disk,'DATA');
GParams.SEED = fullfile(str_disk);
GParams.SEED_SPIKO = fullfile(str_disk,'ATLAS_NLAB');
% Local Disk
GParams.DIR_SAVE = fullfile(str_save,'NLab_DATA');
GParams.DIR_FIG = fullfile(str_save,'NLab_Figures');
GParams.DIR_STATS = fullfile(str_save,'NLab_Statistics');
GParams.DIR_SYNT = fullfile(str_save,'NLab_Synthesis');
GParams.SEED_REGION = fullfile(str_save,'Nlab_Files','NRegions');
GParams.SEED_SWL = fullfile(str_save,'Nlab_Files','NReclists');
GParams.SEED_CONFIG = fullfile(str_save,'Nlab_Files','NConfigs');
GParams.sep_swl_1 = 'SEP1';
GParams.sep_swl_2 = 'SEP2';

% Checking if folder exist
% data disk
if ~exist(str_disk,'dir')
    warning('Data Disk not found [%s].\n',str_disk);
end

% save disk
if ~exist(str_save,'dir')
    %errordlg('Save Disk not found [%s].\n',str_save);
    h = questdlg(sprintf('Disk not found.\nNeurolab is about to create new save disk.\n[%s]',str_save),...
        'User confirmation required','Proceed', 'Cancel', 'Proceed');
    if strcmp(h,'Cancel')
        return;
    else
        folder_list = {GParams.DIR_SAVE;GParams.DIR_FIG;GParams.DIR_STATS;GParams.DIR_SYNT;...
            GParams.SEED_SPIKO;GParams.SEED_REGION;GParams.SEED_SWL;GParams.SEED_CONFIG};
        for j= 1:length(folder_list)
            folder = char(folder_list(j));
            if ~exist(folder,'dir')
                mkdir(folder);
                fprintf('New save folder created [%s].\n',folder);
            end
        end
    end
end

GDisp.W = .80;
GDisp.H = .80;
GDisp.w0 = .30;
GDisp.h0 = .15;
GDisp.coeff_increase = 4;
g_colors = get(groot,'DefaultAxesColorOrder');
GDisp.colors = cell(15,1);
GDisp.colors(1:6,:) = {'[1 0 0]';'[0 0 1]';'[0 1 0]';'[1 0 1]';'[0 1 1]';'[1 1 0]'};
GDisp.colors(7:10,:) = {rgb2char(g_colors(1,:));rgb2char(g_colors(2,:));rgb2char(g_colors(3,:));rgb2char(g_colors(4,:))};
GDisp.colors(11:15,:) = {rgb2char(g_colors(5,:));rgb2char(g_colors(6,:));rgb2char(g_colors(7,:));'[.5 .5 .5]';'[1 1 0]'};
GDisp.colors_info = {'red';'blue';'green';'magenta';'cyan';'yellow';'c1';'c2';'c3';'c4';'c5';'c6';'c7';'panelColor';'labelColor'};
GDisp.dotstyle = {'.';'o';'x';'+';'*';'s';'d';'v';'^';'<';'>';'p';'h';'';''};
GDisp.dotstyle_info = {'point';'circle';'x-mark';'plus';'star';'square';'diamond';
    'triangle(down)';'triangle(up)';'triangle(left)';'triangle(right)';'pentagram';'hexagram';'';''};
GDisp.linestyle = {'-';':';'-.';'--';'';'';'';'';'';'';'';'';'';'';''};
GDisp.linestyle_info = {'solid';'dotted';'dashdot';'dashed';'';'';'';'';'';'';'';'';'';'';''};

GTraces.videospeed = 20;
GTraces.NPix_max = 10;
GTraces.NReg_max = 10;
GTraces.NChan_max = 20;
GTraces.FrameRate = 1;
GTraces.CompressionFormat = 'Motion JPEG AVI';
GTraces.CompressionFormat_index = 1;
GTraces.ImageSaveFormat = 'jpeg';
GTraces.ImageSaveExtension = '.jpg';
GTraces.ImageSaveFormat_index = 1;
GTraces.GraphicLoadFormat = 'Graphic_objects.mat';
GTraces.GraphicLoadFormat_index = 1;
GTraces.GraphicSaveFormat = 'Graphic_objects.mat';
GTraces.GraphicSaveFormat_index = 1;
GTraces.GaussianSmoothing = 1;

GImport.burst_thresh = 10;
GImport.resamp_cont = .5;
GImport.resamp_burst = .2;
GImport.Doppler_normalization_index = 1;
GImport.Doppler_normalization = 'std';
GImport.Doppler_loading_index = 1;
GImport.Doppler_loading = 'full';
GImport.Video_loading_index = 1;
GImport.Video_loading = 'full';
GImport.LFP_loading_index = 2;
GImport.LFP_loading = 'ns2';

GFilt.broad_inf = 1;
GFilt.broad_sup = 250;
GFilt.broad_smooth = .5;
GFilt.delta_inf = 1;
GFilt.delta_sup = 4;
GFilt.delta_smooth = .5;
GFilt.theta_inf = 6;
GFilt.theta_sup = 10;
GFilt.theta_smooth = .5;
GFilt.gammalow_inf = 30;
GFilt.gammalow_sup = 50;
GFilt.gammalow_smooth = .1;
GFilt.gammamid_inf = 55;
GFilt.gammamid_sup = 95;
GFilt.gammamid_smooth = .05;
GFilt.gammahigh_inf = 105;
GFilt.gammahigh_sup = 150;
GFilt.gammahigh_smooth = .02;
GFilt.ripple_inf = 150;
GFilt.ripple_sup = 300;
GFilt.ripple_smooth = .01;

GImport_default = GImport;
GParams_default = GParams;
GDisp_default = GDisp;
GTraces_default = GTraces;
GFilt_default = GFilt;
selected_tab = 'General';

save('Preferences.mat','GParams','GDisp','GTraces','GImport','GFilt',...
    'GParams_default','GDisp_default','GTraces_default','GImport_default','GFilt_default','selected_tab');
fprintf('File Preferences.mat created %s.\n',fullfile(pwd,'Preferences.mat'));
success = true;

end