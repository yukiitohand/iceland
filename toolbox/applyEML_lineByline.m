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
%   Output parameters
%      hdrcor: updated header 
%   Usage
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath)
%     [hdrcor] = applyEML_lineByline(imgPath,hdr,imgcorPath,c,hdrcomponents)


hdrcomponents = {};
if ~isempty(varargin)
    hdrcomponents = varargin{1};
end

[hdrcor] = envi_linebyline(hdr,imgPath,imgcorPath,{@eml_lineByline,c},hdrcomponents);

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