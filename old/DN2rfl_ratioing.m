function [ img_crd_rfrr ] = DN2rfl_ratioing(img,imgDark,rfrSpc_crd,rfrRfl)
%[ img_crd_rfrr ] = DN2rfl_ratioing(img,imgDark,rfrSpc_crd,rfrRfl)
%   calculate the reflectance of the image from DN by ratioing reference
%   spectrum in the image and multiplied with the calibrated reflectance
%   Inputs
%     img: raw DN image (LxSxB)
%     imgDark: dark measurements (1xSxB)
%     rfrSpc_crd: reference spectrum (DN) (Bx1)
%     rfrRfl: calibrated reflectance of the reference
%   Outputs
%     img_crd_rfrr: image cube with ReFlectance with Reference Rationing
%                   (LxSxB)

% dark subtraction
[ img_crd ] = subtract_dark( img,imgDark );

cff = rfrRfl'./rfrSpc_crd';

img_crd_rfrr = zeros(size(img_crd));
for i=1:size(img_crd,1)
    Y = squeeze(img_crd(i,:,:));
    R = bsxfun(@times,Y,cff);
    img_crd_rfrr(i,:,:) = R;
end

end

