pdir = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/GU20160726_120703_0101/';

PMbasename = 'GU2611L_120703_ST1_PMW1_M1';

imgbasename = 'GU2611L_120703_RAD1ST1';

operator = 'YI';


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pmMatpath = joinPath(pdir,[PMbasename '.mat']);

imgPath = joinPath(pdir,[imgbasename '.IMG']);
hdrPath = joinPath(pdir,[imgbasename '.HDR']);

pmID = PMbasename(20:26);

spcbasename = [imgbasename '_' pmID '_SPC1'];

spcsliPath = joinPath(pdir, [spcbasename '.sli']);
spchdrPath = joinPath(pdir, [spcbasename '.hdr']);

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
        load(pmMatpath,'PM');
        [spc] = roimean(PM,imgPath,hdr,'MODE','SmallBatch');
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % saving
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hdrspc = envihdrnew(...
                    'description',description,...
                    'lines',1,...
                    'samples',length(spc),...
                    'bands',1,...
                    'header_offset',0,...
                    'data_type',4,...
                    'interleave','bsq',...
                    'file_type','ENVI Spectral Library',...
                    'RHO_ORIGINAL_IMAGE', imgbasename,...
                    'RHO_PANEL_MASK',PMbasename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_SPECTRUM_COMPUTING_METHOD','roimean')

        envidatawrite(spc,spcslipath,hdrspc);
        envihdrwritex(hdrspc,spchdrPath);
    otherwise
        msgbox('Processing is aborted');
end
        