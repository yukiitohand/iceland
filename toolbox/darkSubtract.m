function [] = darkSubtract(pdir,imgbasename,imgbasename_new,operator,darkbasename,varargin)


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

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgPath = joinPath(pdir,[imgbasename]);
hdrPath = joinPath(pdir,[imgbasename '.HDR']);

darkPath = joinPath(pdir,[darkbasename]);
darkhdrPath = joinPath(pdir,[darkbasename '.hdr']);

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
        if isfield(hdr, 'RHO_COLLINEEXCHANGED') && isfield(hdr, 'RHO_COL_FLIPPED')
            flg_flip_image = hdr.RHO_COLLINEEXCHANGED' * hdr.RHO_COL_FLIPPED;
        else
            flg_flip_image = 0;
        end
        darkhdr = envihdrreadx(darkhdrPath);
        dark = envidataread_v2(darkPath,darkhdr);
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % processing and saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hdrcor = hdrupdate(hdr,...
                    'RHO_ORIGINAL_IMAGE',imgbasename,...
                    'RHO_DARK_SUBTRACTED',darkbasename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_RFLCOV_METHOD','dark_subtracted')
        
        switch upper(mode_process)
            case 'BATCH'
                hdrcor = hdrupdate(hdrcor,'data_type',12);
                img = envidataread_v2(imgPath,hdr);
                [img_cor] = darkSubtract_batch(img,dark);
                envidatawrite(img_cor,imgcorPath,hdrcor);
            case 'LINEBYLINE'
                [hdrcor] = darkSubtract_lineByline(imgPath,hdrcor,imgcorPath,...
                                               dark,{'data_type',12},'f');
%             case 'BANDBYBAND'
%                 [hdrcor] = darkSubtract_bandByband(imgPath,hdrcor,imgcorPath,...
%                                                dark,{'data_type',12},'f');
            otherwise
                error('Mode %s is not defined',mode_process);
        end
        
        envihdrwritex(hdrcor,hdrcorPath);
        

    otherwise
        msgbox('Processing is aborted');
end