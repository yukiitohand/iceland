function [] = flip_image(pdir,d,imgbasename_original,imgbasename_new,operator)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d = 'GU20160726_140221_0201';



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup file path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgPath_ori = joinPath(pdir,[imgbasename_original]);
hdrPath_ori = joinPath(pdir,[imgbasename_original '.hdr']);
imgPath = joinPath(pdir,[imgbasename_new '.IMG']);
hdrPath = joinPath(pdir,[imgbasename_new '.HDR']);

original_image = joinPath(d,imgbasename_original);
% tmp paths
% tmpimgPath = joinPath(pdir,[imgbasename_new '_tmp.IMG']);
% tmphdrPath = joinPath(pdir,[imgbasename_new '_tmp.HDR']);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read and process the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hdr_ori = envihdrreadx(hdrPath_ori);
img_ori = envidataread_v2(imgPath_ori,hdr_ori);

img = permute(img_ori,[2 1 3]);
img = flip(img,1);

hdr = hdr_ori;
hdr.lines = hdr_ori.samples;
hdr.samples = hdr_ori.lines;
hdr = hdrupdate(hdr,...
          'RHO_OPERATOR',operator,...
          'RHO_ORIGINAL_IMAGE',original_image,...
          'RHO_DATE_PROCESSED',datestr(now),...
          'RHO_COLLINEEXCHANGED',1,...
          'RHO_COL_FLIPPED',1);
%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
envihdrwritex(hdr,hdrPath);
envidatawrite(img,imgPath,hdr);

% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % replace original image and delete the temporary image
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% copyfile(tmphdrPath,hdrPath,'f');
% copyfile(tmpimgPath,imgPath,'f');
% 
% delete(tmphdrPath);
% delete(tmpimgPath);


