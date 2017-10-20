rootdir = '/Volumes/LaCie/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

d = 'GU20160727_100551_0201';
mbase = master_base_iceland(d,'L');

% imsfx0 = 'RFL0ST1';
% hsi0 = HSI([mbase imsfx0],joinPath(rootdir,d));
% hsi0.img(abs(hsi0.img)>1.5) = nan;

imsfx1 = 'RFL1WST1';
hsi1 = HSI([mbase imsfx1],joinPath(rootdir,d));


imsfx2 = 'RFL2ST1';
hsi2 = HSI([mbase imsfx2],joinPath(rootdir,d));

rgb = hsi2.lazyEnviReadRGB([125 85 49]);

hsiview_v2(rgb,{hsi1,hsi2},{imsfx1,imsfx2});

