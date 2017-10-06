rootdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

d = 'LY20160805_064115_0401';
mbase = master_base_iceland(d,'L');

% imsfx0 = 'RFL0ST1';
% hsi0 = envireadx(joinPath(rootdir,d,[mbase imsfx0]));
% hsi0.img(abs(hsi0.img)>1.5) = nan;
% 
imsfx2g = 'RFL2ST1';
hsi2g = envireadx(joinPath(rootdir,d,[mbase imsfx2g]));
% 
hsi2g.img(abs(hsi2g.img)>1.5) = nan;
hsi2g.img(hsi2g.img<0) = nan;

imsfx1g = 'RFL1WST1';
hsi1g = envireadx(joinPath(rootdir,d,[mbase imsfx1g]));
hsi1g.img(abs(hsi1g.img)>1.5) = nan;

hsiraw = envireadx(joinPath(rootdir,d,[mbase 'RAW1ST1']));

hsiview(hsi1g.img(:,:,[11 37 68]),{hsiraw},{'raw'});