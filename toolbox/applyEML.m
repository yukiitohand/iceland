function [img_cor] = applyEML(img,hdr,c)
% perform empirical line correction line by line and dump the image
% directly to the disk.
%   Input Parameters
%      img: hyperspectral image (lines x samples x bands)  
%      hdr: header information for the image
%      c: coefficient for correction [L x 2], first column is the bias and
%         the second column is the multiplier
%   Output parameters
%      img_cor: corrected image (lines x samples x bands)  

img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
if verLessThan('matlab','9.1')
    img2d_cor = bsxfun(@plus,bsxfun(@times,img2d,c(:,2)), c(:,1));
else
    img2d_cor = img2d.*c(:,2) + c(:,1);
end
img_cor = reshape(img2d_cor',hdr.lines,hdr.samples,hdr.bands);

end