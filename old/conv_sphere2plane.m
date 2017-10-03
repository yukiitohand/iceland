% convert degrees to radians;
stype = 'SWIR';
d = '2016_07_29_12_48_01';

pdirpath = 'E:/MicroHyperspec';

dirpath = [pdirpath '/' [stype ' data'] '/captured/' d '/'];

setting = envihdrread_yuki([dirpath 'settings.txt']);

hdr = envihdrread_yuki([dirpath 'raw.hdr']);
if strcmp(stype,'VNIR')
    r = 125; g = 85; b = 49;
%     if setting.POST_Col_binning == 3
%         r = 41; g = 28; b = 16;
%     end
elseif strcmp(stype,'SWIR')
    r = 73; g = 31; b = 15;
end
img = lazyEnviReadRGB([dirpath 'raw'],hdr,[r,g,b]);
img = double(img);

hdrDark = envihdrread_yuki([dirpath 'darkReference.hdr']);
dark = envidataread([dirpath 'darkReference'],hdrDark);
dark = double(dark);
% img(:,:,r) = bsxfun(@minus,img(:,:,1), dark(:,:,r));
% img(:,:,g) = bsxfun(@minus,img(:,:,1), dark(:,:,g));
% img(:,:,b) = bsxfun(@minus,img(:,:,1), dark(:,:,b));
imgRGB = flip(permute(img(:,:,:),[2,1,3]),1);
% if setting.POST_Col_binning == 3
%     imgRGBnew = zeros([size(imgRGB,1),floor(size(imgRGB,2)/3),3]);
%     for i=1:floor(size(imgRGB,2)/3)
%         imgRGBnew(:,i,:) = mean(imgRGB(:,3*i-2:3*i,:),2);
%     end
%     imgRGB = imgRGBnew;
% end
% imgRGBnew = zeros([size(imgRGB,1),floor(size(imgRGB,2)/10),3]);
% for i=1:floor(size(imgRGB,2)/10)
%     imgRGBnew(:,i,:) = mean(imgRGB(:,10*i-2:10*i,:),2);
% end
% imgRGB = imgRGBnew;
if strcmp(stype,'VNIR')
    imgRGB(:,:,1) = imgRGB(:,:,1)/28000;
    imgRGB(:,:,2) = imgRGB(:,:,2)/26000;
    imgRGB(:,:,3) = imgRGB(:,:,3)/16000;
elseif strcmp(stype,'SWIR')
%     imgRGB(:,:,1) = imgRGB(:,:,1)/66000;
%     imgRGB(:,:,2) = imgRGB(:,:,2)/66000;
%     imgRGB(:,:,3) = imgRGB(:,:,3)/66000;
    imgRGB(:,:,1) = imgRGB(:,:,1)/33000;
    imgRGB(:,:,2) = imgRGB(:,:,2)/44000;
    imgRGB(:,:,3) = imgRGB(:,:,3)/47000;
end
imgRGB(imgRGB>1) = 1;
figure; imagesc(imgRGB);
set(gca,'dataAspectRatio',[1 1 1]);
im = getimage(gca);
imwrite(im,[dirpath sprintf('rawR%dG%dB%d.png',r,g,b)]);

% projection onto a plane
% agl_strt = setting.Start_position_deg;
% agl_end = setting.Stop_position_deg;
% theta_strt = agl_strt/180*pi;
% theta_end = agl_end/180*pi;
% alpha = (theta_strt + theta_end)/2;
% top_agl = abs(theta_end-alpha);
% dtheta = (theta_end-theta_strt) / setting.Images;
% 
% pxl_brdrs_theta = theta_strt - alpha + dtheta * (0:setting.Images);
% % h = cos(top_agl);
% h = 1;
% pxl_brdrs_plane = tan(pxl_brdrs_theta).*h;
% 
% % pxl_brdrs_plane_new = sin(theta_strt - alpha):dtheta:sin(theta_end - alpha);
% pxl_brdrs_plane_new = tan(theta_strt - alpha):dtheta:tan(theta_end - alpha);
% 
% x = 0.5*(pxl_brdrs_plane(2:end) + pxl_brdrs_plane(1:end-1));
% x_new = 0.5*(pxl_brdrs_plane_new(2:end) + pxl_brdrs_plane_new(1:end-1));
% 
% img_new = zeros([hdr.samples,length(x_new)]);
% for i=1:hdr.samples
%     for b = 1:3
%         y = squeeze(imgRGB(i,:,b));
%         y_new = interp1(x,y,x_new,'spline');
%         img_new(i,:,b) = y_new;
%     end
% end
% 
% figure;
% img_new(img_new>1) = 1;
% figure; imagesc(img_new);
% set(gca,'dataAspectRatio',[1 1 1]);

