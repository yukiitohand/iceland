function [im_cor,hdr_cor] = whiteRatioing(hdr,img,BW_w,rfl_white)
% 

img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
white_spcs = img2d(:,BW_w(:));

white_spc = mean(white_spcs,2);

cff = white_spc./rfl_white;

img2d_cor = bsxfun(@rdivide,img2d,cff);

hdr_cor = hdrupdate(hdr,'RHO_METHOD','white_ratioing');
im_cor = reshape(img2d_cor',hdr.lines,hdr.samples,hdr.bands);

end