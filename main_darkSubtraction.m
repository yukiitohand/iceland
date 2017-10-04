rootdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

dnames = {'GU20160727_100551_0201',...
          'HV20160729_144053_0301',...
          'HV20160802_111250_0101',...
          'HV20160802_113125_0102'};

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM / simpleRatio with 3 panels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_img_ds = 'RWD1ST1';
suffix_img_new = 'RWD2ST1';
darkbasename = 'darkReference';

for i=1:length(dnames)
    d = dnames{i};

    pdir = joinPath(rootdir,d);
    imgbasename = 'raw';
    dcell = strsplit(d,'_');
    baseID = [d(1:2) d(9:10) d(20) d(22)];
    imgbasename_ds = [baseID sensorID '_' dcell{2} '_' suffix_img_ds];
    imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix_img_new];

    darkSubtract(pdir,'raw',imgbasename_ds,operator,darkbasename,...
                'MODE','linebyline');
    flip_image(pdir,d,[imgbasename_ds],imgbasename_new,operator,'IMGEXT','IMG');
    
end

%%
d = 'HV20160729_144053_0301';
operator = 'YI';
sensorID = 'L';
suffix_img_ds = 'RWD1ST1';
suffix_img_new = 'RWD2ST1';
darkbasename = 'darkReference';
pdir = joinPath(rootdir,d);
dcell = strsplit(d,'_');
baseID = [d(1:2) d(9:10) d(20) d(22)];
imgbasename_ds = [baseID sensorID '_' dcell{2} '_' suffix_img_ds];
imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix_img_new];

darkSubtract(pdir,'raw_frfixed',imgbasename_ds,operator,darkbasename,...
            'MODE','linebyline');
flip_image(pdir,d,[imgbasename_ds],imgbasename_new,operator,'IMGEXT','IMG');