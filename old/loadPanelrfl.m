function [white_rfl_rsmp,gray_rfl_rsmp,black_rfl_rsmp] = loadPanelrfl(hdr)

%--------------------------------------------------------------------------
% read spectralon reflectance data calibrated by Labsphere.
%--------------------------------------------------------------------------
if ismac
    pdir_labsphere = '/Users/yukiitoh/Box Sync/data/labsphere/';
elseif ispc
    pdir_labsphere = 'C:/Users/yuki/Box Sync/data/labsphere/';
end
% pdir_labsphere = '/Users/yukiitoh/Box Sync/data/ancillary/labsphere/';

white_rfl_fpath = [pdir_labsphere '99AA02-0316-4282_10in/SRT-99-100.txt'];
[ white_rfl ] = spectralonRead( white_rfl_fpath );

gray_rfl_fpath = [pdir_labsphere '50AA10416_10in/SRT-50-100.txt'];
[ gray_rfl ] = spectralonRead( gray_rfl_fpath );

black_rfl_fpath = [pdir_labsphere '05AA010716_10in/SRT-05-100.txt'];
[ black_rfl ] = spectralonRead( black_rfl_fpath );

%%
%--------------------------------------------------------------------------
% interpolate the spectralon data to MicroHyperspec
% using Gaussian convolution.
%--------------------------------------------------------------------------
% check average wavelength pitch
w = mean(hdr.wavelength(2:end)-hdr.wavelength(1:end-1));

switch hdr.serial_number
    case 'uVS-234'
        fwhm = w*5; % full width half maximum (fwhm) for vnir
    case 'uVS-232'
        fwhm = w*1; % fwhm for swir
    otherwise
        error('serial number is invalid');
end

% interpolation
[ white_rfl_rsmp ] = interpGaussConv( white_rfl(:,1),white_rfl(:,2),hdr.wavelength',fwhm );
[ gray_rfl_rsmp ] = interpGaussConv( gray_rfl(:,1),gray_rfl(:,2),hdr.wavelength',fwhm );
[ black_rfl_rsmp ] = interpGaussConv( black_rfl(:,1),black_rfl(:,2),hdr.wavelength',fwhm );

end