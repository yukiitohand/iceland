
if ismac
    rootdir = '/Volumes/LaCie/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';
elseif isunix
    rootdir = '/Volume2/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/VNIR data/captured';
end



ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

d = 'LY20160805_070816_0401';
mbase = master_base_iceland(d,'S');

% imsfx0 = 'RFL0ST1';
% hsi0 = HSI([mbase imsfx0],joinPath(rootdir,d));
% hsi0.img(abs(hsi0.img)>1.5) = nan;

imsfx1 = 'RFL1WST1';
hsi1 = HSI([mbase imsfx1],joinPath(rootdir,d));


imsfx2 = 'RFL2ST1';
hsi2 = HSI([mbase imsfx2],joinPath(rootdir,d));

% rgb = hsi2.lazyEnviReadRGB([125 85 49]);
rgb2 = hsi2.lazyEnviReadRGB([25,17,9]);
hsiview_v2(rgb2,{hsi1,hsi2},{imsfx1,imsfx2});

