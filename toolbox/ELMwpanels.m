function [] = ELMwpanels(pdir,rfldir,imgbasename,imgbasename_new,operator,spcbasenames,rflbasenames,varargin)
% [] = ELMwpanels(pdir,rfldir,imgbasename,imgbasename_new,operator,spcbasenames,rflbasenames,varargin)
%   Perform empirical line correction and save images in the same folder.
%   Input Parameters
%      pdir: directory of the images
%      rfldir: directory of the reflectance files
%      imgbasename: basename of the image to be processed
%      imgbasename_new: basename of the processed image
%      operator: Intitial of the operator
%      spcbasenames: cell array, each element is the basename of the
%                    reference spectrum file.
%      rflbasenames: cell array, each element is the basename of the
%                    reflectance file.
%   Optional Parameters
%      'MODE': {'BATCH','LINEBYLINE'} how to perform processing. If 'BATCH' is
%              specified, the whole image is loaded onto memory, If 'LINEBYLINE' is
%              specified, correction is performed line by line
%              (default) 'BATCH'
%      'FORCE': boolean, if true, the file is overwritten without warning.
%               (default) false

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
force = 0;
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'MODE'
                mode_process = varargin{i+1};
            case 'FORCE'
                force = varargin{i+1};
%             case 'IMCODE'
%                 imcode = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end
    end
end

if length(spcbasenames)<2
    error('cannot perform ELM correction with 1 sample.');
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgPath = joinPath(pdir,[imgbasename '.IMG']);
hdrPath = joinPath(pdir,[imgbasename '.HDR']);

spcs = [];
for i=1:length(spcbasenames)
    spcsliPath = joinPath(pdir, [spcbasenames{i} '.sli']);
    spchdrPath = joinPath(pdir, [spcbasenames{i} '.hdr']);
    
    spcs(i).sliPath = spcsliPath;
    spcs(i).hdrPath = spchdrPath;
end

rfls = [];
for i=1:length(rflbasenames)
    rflsliPath = joinPath(rfldir, [rflbasenames{i} '.sli']);
    rflhdrPath = joinPath(rfldir, [rflbasenames{i} '.hdr']);
    rfls(i).sliPath = rflsliPath;
    rfls(i).hdrPath = rflhdrPath;
end

% imgcor_base = strrep(imgbasename,'RAD1','RFL3');
imgcorPath = joinPath(pdir,[imgbasename_new '.IMG']);
hdrcorPath = joinPath(pdir,[imgbasename_new '.HDR']);

btn = 'yes';
if ~force
    if exist(imgcorPath,'file')
        btn = questdlg(sprintf('%s exist. Do you want to continue?',imgcorPath));
    end
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
        for i=1:length(spcs)
            spchdr = envihdrreadx(spcs(i).hdrPath);
            spc = envidataread_v2(spcs(i).sliPath,spchdr);
            spc = squeeze(spc)';
            
            spcs(i).hdr = spchdr;
            spcs(i).spc = spc;
        end
        
        
        % read reflectance
        for i=1:length(rfls)
            rflhdr = envihdrreadx(rfls(i).hdrPath);
            rfl = envidataread_v2(rfls(i).sliPath,rflhdr);
            rfl = squeeze(rfl)';
            
            rfls(i).hdr = rflhdr;
            rfls(i).rfl = rfl;
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % processing and saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        radMat = cat(2,spcs.spc);
        refMat = cat(2,rfls.rfl);

        [c,refGen] = fnEmpiricalLineCalibration(radMat,refMat);
        
        ancillary_base = [imgbasename_new '_ancillary'];
        ancillary_path = joinPath(pdir,[ancillary_base '.mat']);
        
        hdrcor = hdrupdate(hdr,...
                    'RHO_ORIGINAL_IMAGE',imgbasename,...
                    'RHO_RFLCOV_ANCILLARY',ancillary_base,...
                    'RHO_RFLCOV_SPCs',cell1dstrprintf(spcbasenames,',','{}'),...
                    'RHO_RFLCOV_RFLs',cell1dstrprintf(rflbasenames,',','{}'),...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_RFLCOV_METHOD','ELMwpanels')
        
        switch upper(mode_process)
            case 'BATCH'
                hdrcor = hdrupdate(hdrcor,'data_type',4);
                img = envidataread_v2(imgPath,hdr);
                [img_cor] = applyEML_batch(img,hdr,c);
                envidatawrite(img_cor,imgcorPath,hdrcor);
            case 'LINEBYLINE'
                [hdrcor] = applyEML_lineByline(imgPath,hdrcor,imgcorPath,c,{'data_type',4},'f');
            otherwise
                error('Mode %s is not defined',mode_process);
        end
        
        envihdrwritex(hdrcor,hdrcorPath);
        save(ancillary_path,'c');
        

    otherwise
        msgbox('Processing is aborted');
end



