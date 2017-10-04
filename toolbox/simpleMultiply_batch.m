function [img_cor] = simpleMultiply_batch(img,hdr,cff)
% perform empirical line correction line by line and dump the image
% directly to the disk.
%   Input Parameters
%      img: hyperspectral image (lines x samples x bands)  
%      hdr: header information for the image
%      cff: coefficient vector for multiplication [L x 1], 
%   Output parameters
%      img_cor: corrected image (lines x samples x bands)  

img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
if verLessThan('matlab','9.1')
    img2d_cor = bsxfun(@times,img2d,cff);
else
    img2d_cor = img2d.*cff;
end
img_cor = reshape(img2d_cor',hdr.lines,hdr.samples,hdr.bands);

end