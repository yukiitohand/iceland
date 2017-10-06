function [ img_crd ] = subtract_dark( img,imgDark )
% [ img_crd ] = subtract_dark( img,imgDark )
%   subtract dark from the image
%   Inputs
%     img: hyperspectral image (DN) (LxSxB)
%     imgDark: dark measurement (1xSxB)

if size(img,2)~=size(imgDark,2) || size(img,3)~=size(imgDark,3)
    error('The size of the img and imgDark does not match.');
end
% dark subtraction
img_crd = zeros(size(img));

L = size(img,1);
for i=1:L
    img_crd(i,:,:) = img(i,:,:)-imgDark;
end


end

