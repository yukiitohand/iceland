function [spc,hdrspc] = computeSPCroimean(pdir,imgbasename,PMbasename,operator,description)
% [spc,hdrspc] = computeSPCroimean(pdir,imgbasename,PMbasename,operator,description)
%   Take the spectra in the region of interest and peform simple average
%   and output to file.
%   Input Parameters
%      pdir: directory of the images
%      imgbasename: basename of the image to be processed
%      PMbasename: basename of the region of interest file
%      operator: Intitial of the operator
%      description: description to be saved in the header.
%   Output Parameters
%      spc: 1d-array of the spectrum
%      hdrspc: struct, containing header information

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
                    'wavelength_units',hdr.wavelength_units,...
                    'wavelength',hdr.wavelength,...
                    'RHO_ORIGINAL_IMAGE', imgbasename,...
                    'RHO_PANEL_MASK',PMbasename,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_SPECTRUM_COMPUTING_METHOD','roimean');

        

        envidatawrite(spc,spcsliPath,hdrspc);
        envihdrwritex(hdrspc,spchdrPath);
    otherwise
        msgbox('Processing is aborted');
        spc = []; hdrspc = [];
end
        