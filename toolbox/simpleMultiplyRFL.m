function [] = simpleMultiplyRFL(pdir,rfldir,imgbasename,imgbasename_new,operator,rflbasename,varargin)

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

rflsliPath = joinPath(rfldir, [rflbasename '.sli']);
rflhdrPath = joinPath(rfldir, [rflbasename '.hdr']);

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
        

        % read reflectance
        rflhdr = envihdrreadx(rflhdrPath);
        rfl = envidataread_v2(rflsliPath,rflhdr);
        rfl = squeeze(rfl)';
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % processing and saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         ancillary_base = [imgcor_base '_ancillary'];
%         ancillary_path = joinPath(pdir,[ancillary_base '.mat']);
        
        hdrcor = hdrupdate(hdr,...
                    'RHO_ORIGINAL_IMAGE',imgbasename,...
                    'RHO_MultRfl',rflbasename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_RFLCOV_METHOD','simpleMultiplyRFL')
        
        switch upper(mode_process)
            case 'BATCH'
                hdrcor = hdrupdate(hdrcor,'data_type',4);
                img = envidataread_v2(imgPath,hdr);
                [img_cor] = simpleMultiply_batch(img,hdr,rfl);
                envidatawrite(img_cor,imgcorPath,hdrcor);
            case 'LINEBYLINE'
                [hdrcor] = simpleMultiply_lineByline(imgPath,hdrcor,imgcorPath,rfl,{'data_type',4},'f');
            otherwise
                error('Mode %s is not defined',mode_process);
        end
        
        envihdrwritex(hdrcor,hdrcorPath);
%         save(ancillary_path,'cff');
        

    otherwise
        msgbox('Processing is aborted');
end
end