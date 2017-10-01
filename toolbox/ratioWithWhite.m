pdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/GU20160726_120703_0101/';

spcWbasename = '';

imgbasename = 'GU2611L_120703_RAD1ST1';

spcWfilename = '';
rflWfilename = '';

operator = 'YI';


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgPath = joinPath(pdir,[imgbasename '.IMG']);
hdrPath = joinPath(pdir,[imgbasename '.HDR']);

spcWsliPath = joinPath(pdir, [spcWbasename '.sli']);
spcWhdrPath = joinPath(pdir, [spcWbasename '.hdr']);

rflWsliPath = joinPath(pdir, [rflWbasename '.sli']);
rflWhdrPath = joinPath(pdir, [rflWbasename '.hdr']);

imgcor_base = strrep(imgbasename,'RAD1','RFL1');
imgcorPath = joinPath(pdir,[imgcor_base '.IMG']);
hdrcorPath = joinPath(pdir,[imgcor_base '.HDR']);

btn = 'yes';
if exist(spcsliPath,'file')
    btn = questdlg(sprintf('%s exist. Do you want to continue?',spcsliPath));
end

switch lower(btn)
    case 'yes'
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % processing
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read image
        hdr = envihdrreadx(hdrPath);
        img = envidatareadx(imgPath);
        
        % read spectrum
        spcWhdr = envihdrreadx(spcWsliPath);
        spcW = envidatareadx(spcWsliPath,spcWhdr);
        spcW = squeeze(spcW);
        
        % read reflectance
        rflWhdr = envihdrreadx(rflWsliPath);
        rflW = envidatareadx(rflWsliPath,spcWhdr);
        rflW = squeeze(rflW);
        
        cff = rflW./spcW;
        
        img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
        img2d_cor = bsxfun(@times,img2d,cff);
        img_cor = reshape(img2d_cor',hdr.samples,hdr.lines,hdr.bands);
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hdrcor = hdrupdate(hdr,...
                    'RHO_ORIGINAL_IMAGE', imgbasename,...
                    'RHO_White_SPC',spcWfilename,...
                    'RHO_White_RFL',rflWfilename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_SPECTRUM_COMPUTING_METHOD','rationWithWhite_v1')

        envidatawrite(img_cor,imgcorPath,hdrcor);
        envihdrwritex(hdrcor,hdrcorPath);
    otherwise
        msgbox('Processing is aborted');
end
        