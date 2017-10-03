function [] = saveCorrctedHDRImage(img_cr,hdr_cr,bname,suffix,pdir)
% saveCorrctedHDRImage(img_cr,hdr_ori,data_type,bname,suffix,pdir)
%   save corrected image and header
%   Inputs
%     img_cr: (LxSxB) image to be saved
%     hdr_cr: = header file associated with img_cr
%     bname: basename
%     suffix: suffix to be added to bname
%     pdir: directory to be saved

if hdr_cr.data_type==4
    img_cr = single(img_cr);
elseif hdr_cr.data_type==2
    img_cr = uint16(img_cr);
else
    error('The input data_type is not implemented');
end

bname_cr = [bname suffix];
envihdrwrite_yuki(hdr_cr,[pdir bname_cr '.hdr']);
envidatawrite(img_cr,[pdir bname_cr],hdr_cr);

end

