function [] = correctWithELM(pdir,rfldir,imgbasename,operator,spcWbasename,rflWbasename,spcGbasename,rflGbasename,spcKbasename,rflKbasename,varargin)

% pdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/GU20160726_120703_0101/';
% rfldir = '';

% imgbasename = 'GU2611L_120703_RAD1ST1';
% 
% spcWfilename = '';
% rflWfilename = '';
% 
% spcGfilename = '';
% rflGfilename = '';
% 
% spcKfilename = '';
% rflKfilename = '';

% operator = 'YI';

mode_process = 'BATCH';
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'MODE'
                mode_process = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgPath = joinPath(pdir,[imgbasename '.IMG']);
hdrPath = joinPath(pdir,[imgbasename '.HDR']);

spcWsliPath = joinPath(pdir, [spcWbasename '.sli']);
spcWhdrPath = joinPath(pdir, [spcWbasename '.hdr']);

rflWsliPath = joinPath(rfldir, [rflWbasename '.sli']);
rflWhdrPath = joinPath(rfldir, [rflWbasename '.hdr']);

spcGsliPath = joinPath(pdir, [spcGbasename '.sli']);
spcGhdrPath = joinPath(pdir, [spcGbasename '.hdr']);

rflGsliPath = joinPath(rfldir, [rflGbasename '.sli']);
rflGhdrPath = joinPath(rfldir, [rflGbasename '.hdr']);

spcKsliPath = joinPath(pdir, [spcKbasename '.sli']);
spcKhdrPath = joinPath(pdir, [spcKbasename '.hdr']);

rflKsliPath = joinPath(rfldir, [rflKbasename '.sli']);
rflKhdrPath = joinPath(rfldir, [rflKbasename '.hdr']);

imgcor_base = strrep(imgbasename,'RAD1','RFL2');
imgcorPath = joinPath(pdir,[imgcor_base '.IMG']);
hdrcorPath = joinPath(pdir,[imgcor_base '.HDR']);

btn = 'yes';
if exist(imgcorPath,'file')
    btn = questdlg(sprintf('%s exist. Do you want to continue?',imgcorPath));
end

switch lower(btn)
    case 'yes'
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read data
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read image
        hdr = envihdrreadx(hdrPath);
        
        
        % read spectrum
        spcWhdr = envihdrreadx(spcWhdrPath);
        spcW = envidataread_v2(spcWsliPath,spcWhdr);
        spcW = squeeze(spcW)';
        
        spcGhdr = envihdrreadx(spcGhdrPath);
        spcG = envidataread_v2(spcGsliPath,spcGhdr);
        spcG = squeeze(spcG)';
        
        spcKhdr = envihdrreadx(spcKhdrPath);
        spcK = envidataread_v2(spcKsliPath,spcKhdr);
        spcK = squeeze(spcK)';
        
        % read reflectance
        rflWhdr = envihdrreadx(rflWhdrPath);
        rflW = envidataread_v2(rflWsliPath,rflWhdr);
        rflW = squeeze(rflW)';
        
        rflGhdr = envihdrreadx(rflGhdrPath);
        rflG = envidataread_v2(rflGsliPath,rflGhdr);
        rflG = squeeze(rflG)';
        
        rflKhdr = envihdrreadx(rflKhdrPath);
        rflK = envidataread_v2(rflKsliPath,rflKhdr);
        rflK = squeeze(rflK)';
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % processing and saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        radMat = [spcW spcG spcK];
        refMat = [rflW rflG rflK];

        [c,refGen] = fnEmpiricalLineCalibration(radMat,refMat);
        
        hdrcor = hdrupdate(hdr,...
                    'RHO_ORIGINAL_IMAGE',imgbasename,...
                    'RHO_WHITE_SPC',spcWbasename,...
                    'RHO_WHITE_RFL',rflWbasename,...
                    'RHO_Gray_SPC',spcGbasename,...
                    'RHO_Gray_RFL',rflGbasename,...
                    'RHO_Black_SPC',spcKbasename,...
                    'RHO_Black_RFL',rflKbasename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_SPECTRUM_COMPUTING_METHOD','ELM with 3 panels_v1')
        
        switch upper(mode_process)
            case 'BATCH'
                hdrcor = hdrupdate(hdrcor,'data_type',4);
                img = envidataread_v2(imgPath,hdr);
                [img_cor] = applyEML(img,hdr,c);
%                 img2d = reshape(img,hdr.lines*hdr.samples,hdr.bands)';
%                 if verLessThan('matlab','9.1')
%                     img2d_cor = bsxfun(@times,img2d,c(:,2)) + c(:,1);
%                 else
%                     img2d_cor = img2d.*c(:,2) + c(:,1);
%                 end
%                 img_cor = reshape(img2d_cor',hdr.lines,hdr.samples,hdr.bands);
                envidatawrite(img_cor,imgcorPath,hdrcor);
            case 'LINEBYLINE'
                [hdrcor] = applyEML_lineByline(imgPath,hdrcor,imgcorPath,c,{'data_type',4});
            otherwise
                error('Mode %s is not defined',mode_process);
        end
        
        envihdrwritex(hdrcor,hdrcorPath);
        
        ancillary_base = [imgcor_base '_ancillary'];
        ancillary_path = joinPath(pdir,[ancillary_base '.mat']);
        save(ancillary_path,'c');
        

    otherwise
        msgbox('Processing is aborted');
end