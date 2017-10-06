rootdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);
sensorID = 'L';
operator = 'YI';
dnames = [{ds.name}];
dnames = dnames(3:end);

exceptions = {'GU20160727_100551_0201','HV20160729_144053_0301',...
    'HV20160802_111250_0101','HV20160802_113125_0102'};

for i=2:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),exceptions))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename_new = [baseID sensorID '_' dcell{2} '_' 'RAD1ST1'];
        flip_image(pdir,d,'raw_rd',imgbasename_new,operator);
    end
end


%% check signal
d = 'GU20160727_84245_0101';
pdir = joinPath(rootdir,d);
dcell = strsplit(d,'_');
baseID = [d(1:2) d(9:10) d(20) d(22)];
basename = [baseID sensorID '_' dcell{2} '_RAW1ST1'];
hdr = envihdrreadx(joinPath(pdir,[basename '.HDR']));
img = envidataread_v2(joinPath(pdir,[basename '.IMG']),hdr);

hsi = [];
hsi.hdr = hdr;
hsi.img = img;
hsiview(hsi.img(:,:,[11,73,140]),{hsi},{'aa'});