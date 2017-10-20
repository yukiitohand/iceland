function [ ] = mergeHWMicroHyperspecVNIR( pdir, basenameNew, varargin )
% [ ] = mergeHWMicroHyperspecVNIR( pdir, basenameNew, varargin )
%   Merge two consequetive images collected by Headwall MicroHypespec VNIR
%   imager.
%   Input Parameters
%       pdir: directory
%       basenameNew: basename for the new image file
%       varargin: images to be merged
%     

imgNewPath = joinPath(pdir,basenameNew);
hdrNewPath = joinPath(pdir,[basenameNew '.hdr']);

for i=1:length(varargin)
    basename = varargin{i};
    hdrPath = joinPath(pdir,[basename '.hdr']);
    hdr = envihdrreadx(hdrPath);
    if i==1
        hdrNew = hdr;
    else
        hdrNew = hdrupdate(hdrNew,'lines',hdrNew.lines+hdr.lines);
    end
    
    imgPath = joinPath(pdir, basename);
    
    for l=1:hdr.lines
        iml = lazyEnviReadl(imgPath,hdr,l);
        a = lazyEnviWritel(imgNewPath,iml,hdrNew,l,'a');
    end
end

envihdrwritex(hdrNew,hdrNewPath);

end

