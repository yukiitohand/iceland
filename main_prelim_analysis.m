
dpath = 'E:/MicroHyperspec/SWIR data/captured/';
dpath = 'C:/headwall/SWIR data/captured/';

d = 'jrs_avg21_15.08.06.6_2_2015_11_20_14_38_52/';
% d = 'JRS_avg10_15.08.06.7_1_2015_11_25_11_53_53/';
% d = 'jrs_avg21_15.08.02.01_1_2015_11_20_14_07_20/';
d = 'JRS_avg10_15.08.06.6_1_2015_11_25_11_48_16/';
d = 'JRS_avg10_15.08.06.7_1_2015_11_25_11_53_53/';
d = '2016_07_19_14_07_28/';
% 
% 
% 
d = '2016_07_19_14_09_35/';
% d = '2016_07_19_14_12_48/';d = '1frame_2016_07_19_14_06_17/';
% 
% d = '1frame_2016_07_19_14_07_29/';
% d = '2016_07_19_14_09_35/'; %

d = '2016_07_19_14_06_17/';
d = '2016_07_19_14_07_28/';
d = '2016_07_19_14_09_35/';
 d = '2016_07_19_14_12_48/';

hsi_file = [dpath d 'data'];
hdr_file = [hsi_file '.hdr'];
[hdr] = envihdrread_yuki(hdr_file);
[hsi] = envidataread(hsi_file,hdr);
% hsi = hsi./10000;
% hsi2d = reshape(hsi,[hdr.samples*hdr.lines,hdr.bands])';


hsirgb = hsi(:,:,[62 36 15]);
hsirgb(hsirgb>1) = 1; hsirgb(hsirgb<0) = 0;
figRGB = figure;
% set_figsize(figRGB,600,700);
% move_fig(figRGB,-1263,100);
imagesc(hsirgb);
set(gca,'dataAspectRatio',[1 1 1]);

spc_fig = figure('Name','Spectra');
% set_figsize(spc_fig,500,660);
move_fig(spc_fig,-641,100);
ax_spc = subplot(1,1,1);
hdt = datacursormode(figRGB);

set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,hsi,hdr.wavelength});


%% large image
dpath = 'C:/headwall/VNIR data/captured/';

d = '1frame_2016_07_19_14_07_29/';
% read image geo-reference (map) information of the image
[hdr] = envihdrread_yuki([dpath d 'data.hdr']);

img = lazyEnviReadRGB([dpath d 'data'],hdr,[125,86,47]);
imgNew = img;
imgNew(imgNew>1) = 1;


figRGB = figure;
% set_figsize(figRGB,600,700);
% move_fig(figRGB,-1263,100);
imagesc(imgNew);
set(gca,'dataAspectRatio',[1 1 1]);

spc_fig = figure('Name','Spectra');
% set_figsize(spc_fig,500,660);
% move_fig(spc_fig,-641,100);
ax_spc = subplot(1,1,1);
hdt = datacursormode(figRGB);

set(hdt,'UpdateFcn',{@map_cursor_large,ax_spc,hdr,[dpath d 'data'],hdr.wavelength});


