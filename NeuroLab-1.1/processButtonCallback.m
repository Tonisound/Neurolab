function processButtonCallback(~,~,handles)
% 213 -- Process List Callbacks

global DIR_SAVE FILES CUR_FILE SEED_SPIKO ;
%global DIR_SAVE FILES CUR_FILE SEED SEED_REGION LAST_IM CUR_IM START_IM END_IM IM DIR_SYNT;

val = get(handles.ProcessListPopup,'Value');
str = get(handles.ProcessListPopup,'String');

switch strtrim(str(val,:))
    
    case 'Compute Normalized Movie'
        compute_normalizedmovie(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles);
            
    case 'Filter LFP for theta'
        filter_lfp_theta(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles);
        
    case 'Export LFP bands'
        export_lfp_bands(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles,1)
        
    case 'Export IMO file'
        export_imofile(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),SEED_SPIKO,FILES(CUR_FILE).session);
        
    case 'Load Anatomical Regions'
        load_regions(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles);
    
    case 'Load Cereplex Traces'
        load_lfptraces(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles);
        
    case 'Detect Vascular Surges'
        detect_vascular_surges(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab),handles);
        
    case 'Edit Anatomical Regions'
        edit_patches(handles);
    
    case 'Export Anatomical Regions'
        export_patches(handles);
        
end

end