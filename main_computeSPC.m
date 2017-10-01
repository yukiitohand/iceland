rootdir = 'C:/Users/yuki/tmp/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames(3:end);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute reference spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_img = 'RAD1ST1';
suffix_PM = 'ST1_PMG1_M1';
description = 'Radiance spectrum in the gray panel mask';
for i=1:length(dnames)
    d = dnames{i};
    pdir = joinPath(rootdir,d);
    dcell = strsplit(d,'_');
    baseID = [d(1:2) d(9:10) d(20) d(22)];
    imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
    PMbasename = [baseID sensorID '_' dcell{2} '_' suffix_PM];
    [spc,hdrspc] = computeSPC(pdir,imgbasename,PMbasename,operator,description);
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_spcW = 'PMW1_M1_SPC1';
suffix_spcG = 'PMG1_M1_SPC1';
suffix_spcK = 'PMK1_M1_SPC1';
suffix_img = 'RAD1ST1';
rfldir = 'C:\Users\yuki\Box Sync\data\labsphere';
rflWbasename = 'SPW1RFL_201605_HWUVS232201607_1';
rflGbasename = 'SPG1RFL_201607_HWUVS232201607_1';
rflKbasename = 'SPK1RFL_201607_HWUVS232201607_1';

for i=2:length(dnames)
    d = dnames{i};
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
                spcKbasename,rflKbasename);
end

