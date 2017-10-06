function [ ] = DN2rfl_ratioing_save_largeimage( hdr,datafile,hdr_cr,imgDark,rfrSpc_crd,rfrRfl,bname,suffix,pdir )
% [ ] = DN2rfl_ratioing_save_largeimage( hdr,datafile,hdr_cr,imgDark,rfrSpc_crd,rfrRfl,bname,suffix,pdir )
%   perform multiplication of the image with reference spectrum in the
%   image with calibrated reflectance for the reference. This is a function
%   for a large image that cannot be loaded onto memory.

%     Input
%        hdr: header file for the image
%        datafile: path to the image
%        hdr_cr: header file associated with new image file
%        imgDark: dark image (1xLxS)
%        rfrSpc_crd: reference spectrum (DN) (Bx1)
%        rfrRfl: calibrated reflectance of the reference
%        bname: basename
%        suffix: suffix to be added to bname
%        pdir: directory to be saved

% delete if there exists a file with same folder.
bname_cr = [bname suffix];
if exist([pdir bname_cr],'file')
    prompt = '%s exists. Do you want to proceed?(y/n)';
    flg = 1;
    while flg
        ans = input(prompt,'s');
        if strcmp(lower(ans),'y')
            delete([pdir bname_cr],[pdir bname_cr '.hdr']); flg=0;
        elseif strcmp(lower(ans),'n')
            return;
        else
            fprintf('Your input is invalid. Type carefully.\n');
        end
    end
end

% save header file
envihdrwrite_yuki(hdr_cr,[pdir bname_cr '.hdr']);

% ratioing and saving
cff = rfrRfl'./rfrSpc_crd';
for l=1:hdr.lines
    Y = lazyEnviReadl(datafile,hdr,l); % read image line
    Y = reshape(Y',[1 hdr.samples hdr.bands]);
    Y = double(Y);
    Y_crd = subtract_dark( Y,imgDark );
    Y_crd = squeeze(Y_crd);
    Y_crd_rfrr = bsxfun(@times,Y_crd,cff);
    
    if hdr_cr.data_type==4
        Y_crd_rfrr = single(Y_crd_rfrr);
    elseif hdr_cr.data_type==2
        Y_crd_rfrr = uint16(Y_crd_rfrr);
    else
        error('The input data_type is not implemented');
    end
    
    lazyEnviWritel([pdir bname_cr],Y_crd_rfrr',hdr_cr,l,'a');
    
end



end

