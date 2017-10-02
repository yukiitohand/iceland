rootdir = 'E:/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);
% 13 has too much light variations

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute reference spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_img = 'RAD1ST1';
suffix_PM = 'ST1_PMK1_M1';
description = 'Radiance spectrum in the black panel mask';
for i=1:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),{'HV20160802_113125_0102','HV20160729_144053_0301'}))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
        PMbasename = [baseID sensorID '_' dcell{2} '_' suffix_PM];
        [spc,hdrspc] = computeSPC(pdir,imgbasename,PMbasename,operator,description);
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exceptions = {'GU20160727_100551_0201','HV20160729_144053_0301',...
    'HV20160802_111250_0101','HV20160802_113125_0102'};


operator = 'YI';
sensorID = 'L';
suffix_spcW = 'PMW1_M1_SPC1';
suffix_spcG = 'PMG1_M1_SPC1';
suffix_spcK = 'PMK1_M1_SPC1';
suffix_img = 'RAD1ST1';
rfldir = '/Users/yukiitoh/Box Sync/data/labsphere';
rfldir = 'C:/Users/yuki/Box Sync/data/labsphere';
rflWbasename = 'SPW1RFL_201605_HWUVS232201607_1';
rflGbasename = 'SPG1RFL_201607_HWUVS232201607_1';
rflKbasename = 'SPK1RFL_201607_HWUVS232201607_1';

for i=28:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),exceptions))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
    %     PMbasename = [baseID sensorID '_' dcell{2} '_' suffix_PM];
        spcWbasename = [imgbasename '_' suffix_spcW];
        spcGbasename = [imgbasename '_' suffix_spcG];
        spcKbasename = [imgbasename '_' suffix_spcK];
        correctWithELM(pdir,rfldir,imgbasename,operator,...
                    spcWbasename,rflWbasename,...
                    spcGbasename,rflGbasename,...
                    spcKbasename,rflKbasename,...
                    'MODE','linebyline');
    end
end

