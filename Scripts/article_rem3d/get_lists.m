function L = get_lists(rec_list,reg_group)
% generate list_files and list_regions based on recording list and region group

if strcmp(rec_list,'CORONAL')
    list_files = {'20190225_SD025_P202_R_nlab';'20190226_SD025_P101_R_nlab';'20190226_SD025_P201_R_nlab';'20190226_SD025_P301_R_nlab';'20190226_SD025_P302_R_nlab';
        '20190226_SD025_P401_R_nlab';'20190227_SD025_P102_R_nlab';'20190227_SD025_P201_R_nlab';'20190227_SD025_P202_R_nlab';'20190227_SD025_P501_R_nlab';
        '20190306_SD025_P301_R_nlab';'20190306_SD025_P401_R_nlab';'20190415_SD032_P201_R_nlab';'20190415_SD032_P202_R_nlab';'20190415_SD032_P301_R_nlab';
        '20190415_SD032_P302_R_nlab';'20190416_SD032_P102_R_nlab';'20190416_SD032_P201_R_nlab';'20190416_SD032_P202_R_nlab';'20190416_SD032_P203_R_nlab';
        '20190416_SD032_P301_R_nlab';'20190416_SD032_P302_R_nlab';'20190416_SD032_P303_R_nlab';'20190416_SD032_P402_R_nlab';'20190417_SD032_P102_R_nlab';
        '20190417_SD032_P103_R_nlab';'20190417_SD032_P202_R_nlab';'20190417_SD032_P203_R_nlab';'20190417_SD032_P301_R_nlab';'20190417_SD032_P302_R_nlab';
        '20190417_SD032_P303_R_nlab';'20190417_SD032_P401_R_nlab';'20190417_SD032_P402_R_nlab';'20190417_SD032_P403_R_nlab';'20190418_SD032_P102_R_nlab';
        '20190418_SD032_P103_R_nlab';'20190418_SD032_P201_R_nlab';'20190418_SD032_P202_R_nlab';'20190418_SD032_P203_R_nlab';'20190710_SD041_P201_R_nlab';
        '20190710_SD041_P301_R_nlab';'20190710_SD041_P401_R_nlab';'20190710_SD041_P402_R_nlab';'20190710_SD041_P501_R_nlab';'20190711_SD041_P103_R_nlab';
        '20190711_SD041_P401_R_nlab';'20190711_SD041_P402_R_nlab';'20190716_SD041_P201_R_nlab';'20190716_SD041_P203_R_nlab';'20190716_SD041_P301_R_nlab';
        '20190716_SD041_P302_R_nlab';'20190717_SD041_P103_R_nlab';'20190717_SD041_P104_R_nlab';'20190717_SD041_P201_R_nlab';'20190717_SD041_P401_R_nlab';
        '20190718_SD041_P201_R_nlab';'20190718_SD041_P202_R_nlab';'20190718_SD041_P302_R_nlab'};

elseif strcmp(rec_list,'SAGITTAL')
    list_files = {'20190228_SD025_P301_R_nlab';'20190228_SD025_P302_R_nlab';'20190301_SD025_P401_R_nlab';'20190301_SD025_P402_R_nlab';'20190418_SD032_P301_R_nlab';
        '20190418_SD032_P302_R_nlab';'20190418_SD032_P303_R_nlab';'20190418_SD032_P401_R_nlab';'20190419_SD032_P201_R_nlab';'20190419_SD032_P202_R_nlab';
        '20190419_SD032_P301_R_nlab';'20190419_SD032_P302_R_nlab';'20190419_SD032_P401_R_nlab';'20190419_SD032_P402_R_nlab'};
    
elseif strcmp(rec_list,'ALL')
    list_files = {'20190225_SD025_P202_R_nlab';'20190226_SD025_P101_R_nlab';'20190226_SD025_P201_R_nlab';'20190226_SD025_P301_R_nlab';'20190226_SD025_P302_R_nlab';
        '20190226_SD025_P401_R_nlab';'20190227_SD025_P102_R_nlab';'20190227_SD025_P201_R_nlab';'20190227_SD025_P202_R_nlab';'20190227_SD025_P501_R_nlab';
        '20190228_SD025_P301_R_nlab';'20190228_SD025_P302_R_nlab';'20190301_SD025_P401_R_nlab';'20190301_SD025_P402_R_nlab';'20190306_SD025_P301_R_nlab';
        '20190306_SD025_P401_R_nlab';'20190415_SD032_P201_R_nlab';'20190415_SD032_P202_R_nlab';'20190415_SD032_P301_R_nlab';'20190415_SD032_P302_R_nlab';
        '20190416_SD032_P102_R_nlab';'20190416_SD032_P201_R_nlab';'20190416_SD032_P202_R_nlab';'20190416_SD032_P203_R_nlab';'20190416_SD032_P301_R_nlab';
        '20190416_SD032_P302_R_nlab';'20190416_SD032_P303_R_nlab';'20190416_SD032_P402_R_nlab';'20190417_SD032_P102_R_nlab';'20190417_SD032_P103_R_nlab';
        '20190417_SD032_P202_R_nlab';'20190417_SD032_P203_R_nlab';'20190417_SD032_P301_R_nlab';'20190417_SD032_P302_R_nlab';'20190417_SD032_P303_R_nlab';
        '20190417_SD032_P401_R_nlab';'20190417_SD032_P402_R_nlab';'20190417_SD032_P403_R_nlab';'20190418_SD032_P102_R_nlab';'20190418_SD032_P103_R_nlab';
        '20190418_SD032_P201_R_nlab';'20190418_SD032_P202_R_nlab';'20190418_SD032_P203_R_nlab';'20190418_SD032_P301_R_nlab';'20190418_SD032_P302_R_nlab';
        '20190418_SD032_P303_R_nlab';'20190418_SD032_P401_R_nlab';'20190419_SD032_P201_R_nlab';'20190419_SD032_P202_R_nlab';'20190419_SD032_P301_R_nlab';
        '20190419_SD032_P302_R_nlab';'20190419_SD032_P401_R_nlab';'20190419_SD032_P402_R_nlab';'20190710_SD041_P201_R_nlab';'20190710_SD041_P301_R_nlab';
        '20190710_SD041_P401_R_nlab';'20190710_SD041_P402_R_nlab';'20190710_SD041_P501_R_nlab';'20190711_SD041_P103_R_nlab';'20190711_SD041_P401_R_nlab';
        '20190711_SD041_P402_R_nlab';'20190716_SD041_P201_R_nlab';'20190716_SD041_P203_R_nlab';'20190716_SD041_P301_R_nlab';'20190716_SD041_P302_R_nlab';
        '20190717_SD041_P103_R_nlab';'20190717_SD041_P104_R_nlab';'20190717_SD041_P201_R_nlab';'20190717_SD041_P401_R_nlab';'20190718_SD041_P201_R_nlab';
        '20190718_SD041_P202_R_nlab';'20190718_SD041_P302_R_nlab'};
else
    list_files = [];
end
L.list_files = list_files;

% list_regions
if strcmp(reg_group,'GROUPS')
    list_regions = {'OrbitalCtx';'LimbicCtx';'CingulateCtx';'MotorCtx';'InsularCtx';'SomatoSensoryCtx';...
        'PiriformCtx';'RetrosplenialCtx';'AssociationCtx';'ParietalCtx';'AuditoryCtx';'RhinalCtx';'VisualCtx';
        'SeptalNuclei';'DentateGyrus';'CA3';'CA2';'CA1';
        'CaudatePutamen';'GlobusPallidus';'SubstantiaNigra';%'BasalGanglia';
        'Thalamus';'GeniculateNuclei';'PretectalNuclei';'SuperiorColliculus';'ZonaIncerta';'PAG';'AnteriorAmygdala';'PosteriorAmygdala';
        'Hypothalamus';'PreopticArea';'OlfactoryNuclei';'MammillaryNuclei'};
    label_regions = {'OrCx';'LiCx';'CCx';'MCx';'ICx';'SSCx';...
        'PiCx';'RsCx';'AsCx';'PaCx';'AuCtx';'RhCx';'VCx';
        'Sep';'DG';'CA3';'CA2';'CA1';
        'CPu';'GP';'SNi';%'BGa';
        'Th';'GN';'PN';'SC';'ZI';'PAG';'AAm';'PAm';
        'Hyth';'POA';'ON';'MN'};
    
elseif strcmp(reg_group,'LEFT-GROUPS')
    list_regions = {'OrbitalCtx-L';'LimbicCtx-L';'CingulateCtx-L';'MotorCtx-L';'InsularCtx-L';'SomatoSensoryCtx-L';...
        'PiriformCtx-L';'RetrosplenialCtx-L';'AssociationCtx-L';'ParietalCtx-L';'AuditoryCtx-L';'RhinalCtx-L';'VisualCtx-L';
        'SeptalNuclei-L';'DentateGyrus-L';'CA3-L';'CA2-L';'CA1-L';
        'CaudatePutamen-L';'GlobusPallidus-L';'SubstantiaNigra-L';%'BasalGanglia-L';
        'Thalamus-L';'GeniculateNuclei-L';'PretectalNuclei-L';'SuperiorColliculus-L';'ZonaIncerta-L';'PAG-L';'AnteriorAmygdala-L';'PosteriorAmygdala-L';
        'Hypothalamus-L';'PreopticArea-L';'OlfactoryNuclei-L';'MammillaryNuclei-L'};
    label_regions = {'OrCx-L';'LiCx-L';'CCx-L';'MCx-L';'ICx-L';'SSCx-L';...
        'PiCx-L';'RsCx-L';'AsCx-L';'PaCx-L';'AuCtx-L';'RhCx-L';'VCx-L';
        'Sep-L';'DG-L';'CA3-L';'CA2-L';'CA1-L';
        'CPu-L';'GP-L';'SNi-L';%'BGa-L';
        'Th-L';'GN-L';'PN-L';'SC-L';'ZI-L';'PAG-L';'AAm-L';'PAm-L';
        'Hyth-L';'POA-L';'ON-L';'MN-L'};
    
elseif strcmp(reg_group,'RIGHT-GROUPS')
    list_regions = {'OrbitalCtx-R';'LimbicCtx-R';'CingulateCtx-R';'MotorCtx-R';'InsularCtx-R';'SomatoSensoryCtx-R';...
        'PiriformCtx-R';'RetrosplenialCtx-R';'AssociationCtx-R';'ParietalCtx-R';'AuditoryCtx-R';'RhinalCtx-R';'VisualCtx-R';
        'SeptalNuclei-R';'DentateGyrus-R';'CA3-R';'CA2-R';'CA1-R';
        'CaudatePutamen-R';'GlobusPallidus-R';'SubstantiaNigra-R';%'BasalGanglia-R';
        'Thalamus-R';'GeniculateNuclei-R';'PretectalNuclei-R';'SuperiorColliculus-R';'ZonaIncerta-R';'PAG-R';'AnteriorAmygdala-R';'PosteriorAmygdala-R';
        'Hypothalamus-R';'PreopticArea-R';'OlfactoryNuclei-R';'MammillaryNuclei-R'};
    label_regions = {'OrCx-R';'LiCx-R';'CCx-R';'MCx-R';'ICx-R';'SSCx-R';...
        'PiCx-R';'RsCx-R';'AsCx-R';'PaCx-R';'AuCtx-R';'RhCx-R';'VCx-R';
        'Sep-R';'DG-R';'CA3-R';'CA2-R';'CA1-R';
        'CPu-R';'GP-R';'SNi-R';%'BGa-R';
        'Th-R';'GN-R';'PN-R';'SC-R';'ZI-R';'PAG-R';'AAm-R';'PAm-R';
        'Hyth-R';'POA-R';'ON-R';'MN-R'};
    
elseif strcmp(reg_group,'REGIONS')
    list_regions = generate_lists('AtlasType','ratcoronal','DisplayObj','regions','DisplayMode','bilateral');
    label_regions=list_regions;
    
elseif strcmp(reg_group,'LEFT-REGIONS')
    l1 = generate_lists('AtlasType','ratcoronal','DisplayObj','regions','DisplayMode','unilateral');
    list_regions = l1(endsWith(l1,'-L'));
    label_regions=list_regions;
    
elseif strcmp(reg_group,'RIGHT-REGIONS')
    l1 = generate_lists('AtlasType','ratcoronal','DisplayObj','regions','DisplayMode','unilateral');
    list_regions = l1(endsWith(l1,'-R'));
    label_regions=list_regions;
    
elseif strcmp(reg_group,'VESSEL-GROUPS')
    %list_regions = {'Ventricules';'Vessels';'ach';'acer';'mcer';'basalvessel';'vessel';'lhia'};
    list_regions = {'Ventricules-L';'Ventricules-R';...
        'ach-L';'ach-R';'acer-L';'acer-R';'mcer-L';'mcer-R';...
        'basalvessel-L';'basalvessel-R';'vessel-L';'vessel-R';'lhia-L';'lhia-R'};
    label_regions=list_regions;

else
    list_regions = [];
    label_regions = [];
end
L.list_regions = list_regions;
L.label_regions = label_regions;

end