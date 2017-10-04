function [hdrcor] = simpleMultiply_lineByline(imgPath,hdr,imgcorPath,cff,varargin)
% perform simple spectrum times by line and dump the image
% directly to the disk.
%   Input Parameters
%      imgPath: path to the original image
%      hdr: header information for original file
%      imgcorPath: path to the new corrected image
%      c: coefficient vector for multiplication [L x 1], 
%   Optional parameters
%      hdrcomponents: if any update of the hdr components is done, such as
%      data_type change, cell array, {key, value, key, value}
%      'f' : means force
%   Output parameters
%      hdrcor: updated header 
%   Usage
%     [hdrcor] = simpleMultiply_lineByline(imgPath,hdr,imgcorPath,cff,hdrcomponents)
%     [hdrcor] = simpleMultiply_lineByline(imgPath,hdr,imgcorPath,cff,hdrcomponents,'f')
%     [hdrcor] = simpleMultiply_lineByline(imgPath,hdr,imgcorPath,cff,[],'f')

hdrcomponents = {};
force = '';
if ~isempty(varargin)
    hdrcomponents = varargin{1};
    if length(varargin)==2
        force = varargin{2};
    end
end 

[hdrcor] = envi_lineByline(hdr,imgPath,imgcorPath,{@sm_lineByline,cff},hdrcomponents,force);

end

function [iml_cor] = sm_lineByline(iml,l,cff)
% apply simple multiplication for one line
%   iml: image [bands x sample]
%   l; line
%   c: coefficient for correction [L x 2], first column is the bias and
%      the second column is the multiplier
%   iml_cor: corrected image

    if verLessThan('matlab','9.1')
        iml_cor = bsxfun(@times,iml,cff);
    else
        iml_cor = iml.*cff;
    end
end