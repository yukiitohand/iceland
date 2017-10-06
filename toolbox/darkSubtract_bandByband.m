function [hdrcor] = darkSubtract_bandByband(imgPath,hdr,imgcorPath,imgDark,varargin)
% perform dark subtraction band-by-band
% directly to the disk.
%   Input Parameters
%      imgPath: path to the original image
%      hdr: header information for original file
%      imgcorPath: path to the new corrected image
%      imgDark: dark measurement (1xSxB)]
%   Optional parameters
%      hdrcomponents: if any update of the hdr components is done, such as
%      data_type change, cell array, {key, value, key, value}
%      'f' : means force
%   Output parameters
%      hdrcor: updated header 
%   Usage
%     [hdrcor] = darkSubtract_bandByband(imgPath,hdr,imgcorPath,imgDark,hdrcomponents)
%     [hdrcor] = darkSubtract_bandByband(imgPath,hdr,imgcorPath,imgDark,hdrcomponents,'f')
%     [hdrcor] = darkSubtract_bandByband(imgPath,hdr,imgcorPath,imgDark,[],'f')

hdrcomponents = {};
force = '';
if ~isempty(varargin)
    hdrcomponents = varargin{1};
    if length(varargin)==2
        force = varargin{2};
    end
end

imgDark = squeeze(imgDark)';

[hdrcor] = envi_bandByband(hdr,imgPath,imgcorPath,{@ds_bandByband,imgDark},hdrcomponents,force);

end

function [imb_cor] = ds_bandByband(imb,b,imgDark)
% apply dark subtraction for one band
%   iml: image [bands x sample]
%   l; line
%   imgDark: dark measurement (BxS)]
%   iml_cor: corrected image
if verLessThan('matlab','9.1')
    imb_cor = bsxfun(@minus,imgDark);
else
    imb_cor = imb - imgDark;
end
end