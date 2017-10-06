rootdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

exceptions = {'GU20160727_100551_0201','HV20160729_144053_0301',...
    'HV20160802_111250_0101','HV20160802_113125_0102'};


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute reference spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_img = 'RAD1ST1';
suffix_PM = 'ST1_PMG1_M1';
description = 'Radiance spectrum in the gray panel mask';
prompt = {'Operator','sensorID','suffix_img','suffix_PM','description'};
dlg_title = 'Is this correct?';
num_lines = [1 50];
defaultans = {operator,sensorID,suffix_img,suffix_PM,description};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

operator = answer{1}; sensorID = answer{2}; suffix_img = answer{3};
suffix_PM = answer{4}; description = answer{4};

for i=1:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),exceptions))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
        PMbasename = [baseID sensorID '_' dcell{2} '_' suffix_PM];
        [spc,hdrspc] = computeSPCroimean(pdir,imgbasename,PMbasename,operator,description);
    end
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute reference spectrum exceptions 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dnames = {'GU20160727_100551_0201',...
          'HV20160802_111250_0101'};
dnames = {'HV20160729_144053_0301',...
          'HV20160802_113125_0102'};
operator = 'YI';
sensorID = 'L';
suffix_img = 'RWD2ST1';
suffix_PM = 'ST1_PMW1_M1';
description = 'DN spectrum (dark subtracted) in the white panel mask';
prompt = {'Operator','sensorID','suffix_img','suffix_PM','description'};
dlg_title = 'Is this correct?';
num_lines = [1 50];
defaultans = {operator,sensorID,suffix_img,suffix_PM,description};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

operator = answer{1}; sensorID = answer{2}; suffix_img = answer{3};
suffix_PM = answer{4}; description = answer{4};

for i=1:length(dnames)
    d = dnames{i};
    pdir = joinPath(rootdir,d);
    dcell = strsplit(d,'_');
    baseID = [d(1:2) d(9:10) d(20) d(22)];
    imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
    PMbasename = [baseID sensorID '_' dcell{2} '_' suffix_PM];
    [spc,hdrspc] = computeSPCroimean(pdir,imgbasename,PMbasename,operator,description);
end


