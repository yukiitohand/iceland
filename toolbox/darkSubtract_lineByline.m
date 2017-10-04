function [hdrcor] = darkSubtract_lineByline(imgPath,hdr,imgcorPath,imgDark,varargin)
% perform dark subtraction line-by-line
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
%     [hdrcor] = darkSubtract_lineByline(imgPath,hdr,imgcorPath,imgDark,hdrcomponents)
%     [hdrcor] = darkSubtract_lineByline(imgPath,hdr,imgcorPath,imgDark,hdrcomponents,'f')
%     [hdrcor] = darkSubtract_lineByline(imgPath,hdr,imgcorPath,imgDark,[],'f')

hdrcomponents = {};
force = '';
if ~isempty(varargin)
    hdrcomponents = varargin{1};
    if length(varargin)==2
        force = varargin{2};
    end
end

imgDark = squeeze(imgDark)';

[hdrcor] = envi_lineByline(hdr,imgPath,imgcorPath,{@ds_lineByline,imgDark},hdrcomponents,force);

end

function [iml_cor] = ds_lineByline(iml,l,imgDark)
% apply dark subtraction for one line
%   iml: image [bands x sample]
%   l; line
%   imgDark: dark measurement (BxS)]
%   iml_cor: corrected image
iml_cor = iml - imgDark;
end