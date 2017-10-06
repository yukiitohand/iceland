function [hdrcor] = flipimage_bandByband(imgPath,hdr,imgcorPath,varargin)
% perform flip image band by band (cannot perform line by line)
% directly to the disk.
%   Input Parameters
%      imgPath: path to the original image
%      hdr: header information for original file
%      imgcorPath: path to the new corrected image
%   Optional parameters
%      hdrcomponents: if any update of the hdr components is done, such as
%      data_type change, cell array, {key, value, key, value}
%      'f' : means force
%   Output parameters
%      hdrcor: updated header 
%   Usage
%     [hdrcor] = flipimage_bandByband(imgPath,hdr,imgcorPath)
%     [hdrcor] = flipimage_bandByband(imgPath,hdr,imgcorPath,hdrcomponents)
%     [hdrcor] = flipimage_bandByband(imgPath,hdr,imgcorPath,hdrcomponents,'f')
%     [hdrcor] = flipimage_bandByband(imgPath,hdr,imgcorPath,[],'f')

hdrcomponents = {};
force = '';
if ~isempty(varargin)
    hdrcomponents = varargin{1};
    if length(varargin)==2
        force = varargin{2};
    end
end

[hdrcor] = envi_bandByband(hdr,imgPath,imgcorPath,{@imfl_bandByband},hdrcomponents,force);

end

function [imb_cor] = imfl_bandByband(imb,b)
% apply image flip for one bad
%   imb: image [lines x sample]
%   b; band
%   iml_cor: corrected image
imb_cor = imb';
imb_cor = flipud(imb_cor);
end