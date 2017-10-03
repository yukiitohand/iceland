function [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath,c,varargin)
% perform empirical line correction line by line and dump the image
% directly to the disk.
%   Input Parameters
%      imgPath: path to the original image
%      hdr: header information for original file
%      imgcorPath: path to the new corrected image
%      c: coefficient for correction [L x 2], first column is the bias and
%         the second column is the multiplier
%   Optional parameters
%      hdrcomponents: if any update of the hdr components is done, such as
%      data_type change, cell array, {key, value, key, value}
%      'f' : means force
%   Output parameters
%      hdrcor: updated header 
%   Usage
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath)
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath,c,hdrcomponents)
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath,c,hdrcomponents,'f')
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath,c,[],'f')

hdrcomponents = {};
force = '';
if ~isempty(varargin)
    hdrcomponents = varargin{1};
    if length(varargin)==2
        force = varargin{2};
    end
end 

[hdrcor] = envi_lineByline(hdr,imgPath,imgcorPath,{@eml_lineByline,c},hdrcomponents,force);

end

function [iml_cor] = eml_lineByline(iml,l,c)
% apply EML correction for one line
%   iml: image [bands x sample]
%   l; line
%   c: coefficient for correction [L x 2], first column is the bias and
%      the second column is the multiplier
%   iml_cor: corrected image

    if verLessThan('matlab','9.1')
        iml_cor = bsxfun(@plus,bsxfun(@times,iml,c(:,2)), c(:,1));
    else
        iml_cor = iml.*c(:,2) + c(:,1);
    end
end