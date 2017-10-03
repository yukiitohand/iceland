function [im_cor] = whiteRatioing(hdr,imgPath,BW_w,rfl_white)
% 
img = envidataread_v2(imgPath,hdr);
img = permute(img,[2 1 3]);
img = flip(img,1);

img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
white_spcs = img2d(:,BW_w(:));

white_spc = mean(white_spcs,2);

cff = white_spc./rfl_white;

img2d_cor = bsxfun(@rdivide,img2d,cff);

im_cor = reshape(img2d_cor',hdr.samples,hdr.lines,hdr.bands);

end