pdir = 'F:\MicroHyperspec\SWIR data\captured\2016_08_05_07_31_48\';

hdr = envihdrread_yuki([pdir 'raw_rfwr.hdr']);

img = envidataread([pdir 'raw_rfwr'],hdr);

imRGB = img(:,:,fliplr(hdr.default_bands));
imRGB(imRGB>1) = 1;
imRGB(imRGB<0) = 0;

imRGB = permute(imRGB,[2 1 3]);
imRGB = flip(imRGB,1);

img = permute(img,[2 1 3]);
img = flip(img,1);

figure; ax_spc = subplot(1,1,1);

figure; imagesc(imRGB);
set(gca,'dataAspectRatio',[1 1 1]);
hdt = datacursormode(gcf);
% set(hdt.CurrentDataCursor, 'Marker','+', 'MarkerFaceColor','b');
set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,img,hdr.wavelength});
