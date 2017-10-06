function [] = flip_image(pdir,d,imgbasename,imgbasename_new,operator,varargin)
% flip line and sample axis. After that, the first axis is flipped.

mode_process = 'BATCH';
force = 0;
imgext = '';
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'MODE'
                mode_process = varargin{i+1};
            case 'FORCE'
                force = varargin{i+1};
            case 'IMGEXT'
                imgext = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setup file path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgPath = joinPath(pdir,[imgbasename '.' imgext]);
hdrPath = joinPath(pdir,[imgbasename '.hdr']);
imgNewPath = joinPath(pdir,[imgbasename_new '.IMG']);
hdrNewPath = joinPath(pdir,[imgbasename_new '.HDR']);

original_image = joinPath(d,imgbasename);
% tmp paths
% tmpimgPath = joinPath(pdir,[imgbasename_new '_tmp.IMG']);
% tmphdrPath = joinPath(pdir,[imgbasename_new '_tmp.HDR']);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read and process the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
btn = 'yes';
if ~force
    if exist(imgNewPath,'file')
        btn = questdlg(sprintf('%s exist. Do you want to continue?',imgNewPath));
    end
end

switch lower(btn)
    case 'yes'
        hdr = envihdrreadx(hdrPath);

        hdrcor = hdrupdate(hdr,...
                  'RHO_OPERATOR',operator,...
                  'RHO_ORIGINAL_IMAGE',original_image,...
                  'RHO_DATE_PROCESSED',datestr(now),...
                  'RHO_COLLINEEXCHANGED',1,...
                  'RHO_COL_FLIPPED',1);
%
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % save image
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch upper(mode_process)
            case 'BATCH'
                hdrcor.lines = hdr.samples;
                hdrcor.samples = hdr.lines;
                img = envidataread_v2(imgPath,hdr);
                imgcor = permute(img,[2 1 3]);
                imgcor = flip(imgcor,1);
                
                envidatawrite(imgcor,imgNewPath,hdrcor);
            case 'BANDBYBAND'
                [hdrcor] = flipimage_bandByband(imgPath,hdrcor,imgNewPath,...
                           {'lines',hdr.samples,'samples',hdr.lines,},'f');
                
            otherwise
                error('Mode %s is not defined',mode_process);
        end
        envihdrwritex(hdrcor,hdrNewPath);
        
    otherwise
        msgbox('Processing is aborted');
end




