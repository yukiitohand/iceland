pdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/2016_08_05_12_44_44/';

hdr = envihdrread_yuki(['raw_refl_0419.hdr']);

img = envidataread(['raw_refl_0419'],hdr);

imRGB = img(:,:,fliplr(hdr.default_bands));
imRGB(imRGB>1) = 1;
imRGB(imRGB<0) = 0;

imRGB = permute(imRGB,[2 1 3]);
imRGB = flip(imRGB,1);

img = permute(img,[2 1 3]);
img = flip(img,1);

noisyBands = [49:57 97:109 167:178];
img(:,:,noisyBands) = nan;

figure; ax_spc = subplot(1,1,1);

figure; imagesc(imRGB);
set(gca,'dataAspectRatio',[1 1 1]);
hdt = datacursormode(gcf);
% set(hdt.CurrentDataCursor, 'Marker','+', 'MarkerFaceColor','b');
set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,img,hdr.wavelength});



