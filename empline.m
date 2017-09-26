function [im_cor,c] = empline(hdr,imgPath,BW_w,BW_g,BW_k,white_rfl_rsmp,gray_rfl_rsmp,black_rfl_rsmp)

img = envidataread_v2(imgPath,hdr);
img = permute(img,[2 1 3]);
img = flip(img,1);

img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
white_spcs = img2d(:,BW_w(:));
gray_spcs = img2d(:,BW_g(:));
black_spcs = img2d(:,BW_k(:));

white_spc = mean(white_spcs,2);
gray_spc = mean(gray_spcs,2);
black_spc = mean(black_spcs,2);

radMat = [white_spc gray_spc black_spc];
refMat = [white_rfl_rsmp gray_rfl_rsmp black_rfl_rsmp];

[c,refGen] = fnEmpiricalLineCalibration(radMat,refMat);

if verLessThan('matlab','9.1')
    img2d_cor = bsxfun(@times,img2d,c(:,2)) + c(:,1);
else
    img2d_cor = img2d.*c(:,2) + c(:,1);
end

im_cor = reshape(img2d_cor',hdr.samples,hdr.lines,hdr.bands);

end