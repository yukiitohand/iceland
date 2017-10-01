rootdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames(3:end);

for i=2:length(dnames)
    d = dnames{i};
    flip_image(rootdir,d,'raw','L','RAW1ST1',operator);
end