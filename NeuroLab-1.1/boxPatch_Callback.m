function boxPatch_Callback(src,~,handles)
% 402 -- Callback Label CheckBox

load('Preferences.mat','GColors');
% Find all visible patches
% hm = findobj(handles.CenterAxes,'Type','Patch','-and','Tag','Region');
hm1 = findobj(handles.CenterAxes,'Type','Patch','-and','Tag','Region');
hm2 = findobj(handles.CenterAxes,'Type','Patch','-and','Tag','RegionGroup');
hm = [hm1;hm2];

for i=1:length(hm)
    if src.Value
        hm(i).FaceAlpha = GColors.patch_transparency;
        hm(i).EdgeColor = GColors.patch_color;
        hm(i).LineWidth = GColors.patch_width;
        hm(i).Visible ='on';  
    else
        hm(i).Visible = 'off'; 
    end
end

end