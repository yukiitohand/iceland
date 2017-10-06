pdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/2016_08_05_12_44_44/';

hdr = envihdrreadx(['raw_refl_0419.hdr']);

img = envidataread(['raw_refl_0419'],hdr);

img = permute(img,[2 1 3]);

img = flip(img,1);

imRGB = img(:,:,fliplr(hdr.default_bands));
imRGB(imRGB>1) = 1;
imRGB(imRGB<0) = 0;


% noisyBands = [49:57 97:109 167:178];
img(:,:,noisyBands) = nan;

figure; ax_spc = subplot(1,1,1);


hdt = datacursormode(gcf);
% set(hdt.CurrentDataCursor, 'Marker','+', 'MarkerFaceColor','b');
set(hdt,'UpdateFcn',{@map_cursor_default,ax_spc,img,hdr.wavelength});


[BW,xi,yi] = extractPanel(imRGB,'white');




save(ancillarypath,'BW_white','xi_white','yi_white',...
                   'BW_gray','xi_gray','yi_gray',...
                   'BW_black','xi_black','yi_black');


%

function [BW,xi,yi] = extractPanel(imRGB,color)

fig = figure; imagesc(imRGB);
set(gca,'dataAspectRatio',[1 1 1]);
title(sprintf('Focus, pan, and locate the %s panel!!',color));
flg = 1;
while flg
    [BW, xi, yi] = roipoly();
    if isempty(BW)
        title(sprintf('Try again (%s)',color));
    else
        flg = 0;
    end
end

clf(

fname_im_color_mask = joinPath(pdir,'im_white_mask.bmp');
imwrite(BW,'im_white_mask.bmp');

figure; img_combine = sc(cat(3,imRGB.*BW,imRGB),'prob');
title(sprintf('Selected image mask (%s)',color));

imwrite(img_combine,'im_white_mask.bmp');
% title('Are you satisfied with this?');
% set(gca,'dataAspectRatio',[1 1 1]);
clf fig;

end