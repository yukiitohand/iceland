if ismac
    drive = '/Volumes/SED/';
elseif ispc
    drive = 'F:/';
end

date_time = '2016_08_05_12_44_44';
pdir = [drive sprintf('data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/%s/',date_time)];

%%
bname = 'raw';

% read header and image files.
hdr = envihdrread_yuki([pdir bname '.hdr']);
imgRGB = lazyEnviReadRGB([pdir bname],hdr, [125 86 49]);
imgRGB = double(imgRGB);

% read dark image
hdrDark = envihdrreadx([pdir 'darkReference.hdr']);
imgDark = envidataread([pdir 'darkReference'],hdrDark);

% here we show how to preview the hyperspectral image and spectra in an way
% like Envi.
imgRGBcr = imgRGB;
imgRGBcr(imgRGBcr<0) = 0;
imgRGBcr(:,:,1) = imgRGB(:,:,1)/40000;
imgRGBcr(:,:,2) = imgRGB(:,:,2)/40000;
imgRGBcr(:,:,3) = imgRGB(:,:,3)/30000;
imgRGBcr(imgRGBcr>1) = 1;
figure; ax_spc = subplot(1,1,1);
figure; imagesc(double(imgRGBcr));
set(gca,'dataAspectRatio',[1 1 1]);
hdt = datacursormode(gcf);
% set(hdt.CurrentDataCursor, 'Marker','+', 'MarkerFaceColor','b');
% set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,img_corrd,1:hdr.bands});
set(hdt,'UpdateFcn',{@map_cursor_large,ax_spc,hdr,[pdir bname],1:hdr.bands});


%%
%--------------------------------------------------------------------------
% read spectralon reflectance data calibrated by Labsphere.
%--------------------------------------------------------------------------
if ismac
    pdir_labsphere = '/Users/yukiitoh/Box Sync/data/labsphere/';
elseif ispc
    pdir_labsphere = 'C:/Users/yuki/Box Sync/data/labsphere/';
end
% pdir_labsphere = '/Users/yukiitoh/Box Sync/data/ancillary/labsphere/';

white_rfl_fpath = [pdir_labsphere '99AA02-0316-4282_10in/SRT-99-100.txt'];
[ white_rfl ] = spectralonRead( white_rfl_fpath );

gray_rfl_fpath = [pdir_labsphere '50AA10416_10in/SRT-50-100.txt'];
[ gray_rfl ] = spectralonRead( gray_rfl_fpath );

black_rfl_fpath = [pdir_labsphere '05AA010716_10in/SRT-05-100.txt'];
[ black_rfl ] = spectralonRead( black_rfl_fpath );

%%
%--------------------------------------------------------------------------
% interpolate the spectralon data to MicroHyperspec
% using Gaussian convolution.
%--------------------------------------------------------------------------
% check average wavelength pitch
w = mean(hdr.wavelength(2:end)-hdr.wavelength(1:end-1));
fwhm = w*5; % full width half maximum (fwhm) for vnir
fwhm = w*1; % fwhm for swir

% interpolation
[ white_rfl_rsmp ] = interpGaussConv( white_rfl(:,1),white_rfl(:,2),hdr.wavelength',fwhm );
[ gray_rfl_rsmp ] = interpGaussConv( gray_rfl(:,1),gray_rfl(:,2),hdr.wavelength',fwhm );
[ black_rfl_rsmp ] = interpGaussConv( black_rfl(:,1),black_rfl(:,2),hdr.wavelength',fwhm );

figure; 
% plot(white_rfl(:,1),white_rfl(:,2));
hold on;
plot(hdr.wavelength',white_rfl_rsmp,'r-');
plot(hdr.wavelength,gray_rfl_rsmp,'b-');
plot(hdr.wavelength,black_rfl_rsmp,'k-');
% 
% figure; plot(white_rfl_rsmp./gray_rfl_rsmp);

%%
%--------------------------------------------------------------------------
% roi_ul and roi_lr specify the upper left and lower right corners in the
% region where reference panels are contained.
%--------------------------------------------------------------------------
roi_ul = [2650 200]; roi_lr = [2910 300];
% roi_ul(1) = roi_ul(1)-6000; roi_lr(1) = roi_lr(1)-6000;
%%
yx_white = [2795 253]; th_white = 500;
% yx_white(1) = yx_white(1)-6000;
% [ white_im2, residual_map_white2 ] = get_rfrDNSpc_residualHardThresholding(img_roi,imgDark_roi,yx_white-roi_ul+1,th_white);
[ ave_rfrSpc, residual_map ] = get_rfrDNSpc_residualHardThresholding_largeimage(hdr,[pdir bname],imgDark,roi_ul,roi_lr,yx_white,th_white);

%%
% black
% yx_black = [1348 172];
% ref_black = squeeze(img_corrd(yx_black(1),yx_black(2),:));
% th_black = 50;

%%
% gray
% yx_gray = [1651 312];
% ref_gray = squeeze(img_corrd(yx_gray(1),yx_gray(2),:));
% th_gray = 150;

%%
% path radiance correction
% a = gray_rfl_rsmp./white_rfl_rsmp;
% x = (gray-a.*white)./(1-a);
% 
% figure; plot(a);
% 
% figure; plot(x);

%%
% correction & save
hdr_cr = hdrupdate(hdr,'FWHM',fwhm,'threshold',th_white,'yx_white',yx_white,'data_type',4);

% [ img_crd_rfrr ] = DN2rfl_ratioing(img,imgDark,ave_rfrSpc,white_rfl_rsmp);
% saveCorrctedHDRImage(img_crd_rfrr,hdr_cr,bname,'_rfwr3',pdir);

DN2rfl_ratioing_save_largeimage( hdr,[pdir bname],hdr_cr,imgDark,ave_rfrSpc,white_rfl_rsmp,bname,'_rfwr2',pdir )

%%
% check the image is correct
bname_rfrr = ['raw_rfwr2'];

hdr_rfrr = envihdrread_yuki([pdir bname_rfrr '.hdr']);
imgb = lazyEnviReadb([pdir bname_rfrr],hdr_rfrr, [125]);
imgRGB_rfrr = lazyEnviReadRGB([pdir bname_rfrr],hdr_rfrr, [125 86 49]);
imgRGB_rfrr = double(imgRGB_rfrr);


imgRGB_rfrr_cr = imgRGB_rfrr;
imgRGB_rfrr_cr(imgRGB_rfrr_cr<0) = 0;
imgRGB_rfrr_cr(imgRGB_rfrr_cr>1) = 1;
figure; ax_spc = subplot(1,1,1);
figure; imagesc(double(imgRGB_rfrr_cr));
set(gca,'dataAspectRatio',[1 1 1]);
hdt = datacursormode(gcf);
% set(hdt.CurrentDataCursor, 'Marker','+', 'MarkerFaceColor','b');
% set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,img_corrd,1:hdr.bands});
set(hdt,'UpdateFcn',{@map_cursor_large,ax_spc,hdr_rfrr,[pdir bname_rfrr],hdr_rfrr.wavelength});

%%
