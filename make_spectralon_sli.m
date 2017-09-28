
if ismac
    pdir_labsphere = '/Users/yukiitoh/Box Sync/data/labsphere/';
elseif ispc
    pdir_labsphere = 'C:/Users/yuki/Box Sync/data/labsphere/';
end
% pdir_labsphere = '/Users/yukiitoh/Box Sync/data/ancillary/labsphere/';

white_rfl_fpath = [pdir_labsphere '99AA02-0316-4282_10in/SRT-99-100.txt'];
[ white_rfl ] = spectralonRead( white_rfl_fpath );

hdr = [];
hdr.description = sprintf('{\n    Reflectance of 10in 99%% Spectralon Panel Calibrated by Labsphere.\n    ID: 99AA02-0316-4282.\n    Reference: 99AA02-0316.pdf, SRT-99-100.txt\n}');
hdr.bands = 1;
hdr.samples = size(white_rfl,1);
hdr.lines = 1;
hdr.header_offset = 0;
hdr.file_type = 'ENVI Spectral Library';
hdr.data_type = 4;
hdr.interleave = 'bsq';
hdr.byte_order = 0;
hdr.data_ignore_value = 65535;
hdr.spectra_names = sprintf('{\n  99AA02-0316-4282\n}');
hdr.wavelength_units = 'nm';
hdr.wavelength = white_rfl(:,1);


spc_white = reshape(white_rfl(:,2),[hdr.lines,hdr.samples,hdr.bands]);
spc_white = single(spc_white);
basename_w = 'SPECTRALONW1201605';
envihdrwritex(hdr,[basename_w '.hdr']);
envidatawrite(spc_white,[basename_w '.sli'],hdr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gray_rfl_fpath = [pdir_labsphere '50AA10416_10in/SRT-50-100.txt'];
[ gray_rfl ] = spectralonRead( gray_rfl_fpath );

hdr = [];
hdr.description = sprintf('{\n    Reflectance of 10in 50%% Spectralon Panel Calibrated by Labsphere.\n    ID: 50AA10416.\n    Reference: 50AA10416 Certificate.pdf, SRT-50-100.txt\n}');
hdr.bands = 1;
hdr.samples = size(gray_rfl,1);
hdr.lines = 1;
hdr.header_offset = 0;
hdr.file_type = 'ENVI Spectral Library';
hdr.data_type = 4;
hdr.interleave = 'bsq';
hdr.byte_order = 0;
hdr.data_ignore_value = 65535;
hdr.spectra_names = sprintf('{\n  50AA10416\n}');
hdr.wavelength_units = 'nm';
hdr.wavelength = gray_rfl(:,1);


spc_gray = reshape(gray_rfl(:,2),[hdr.lines,hdr.samples,hdr.bands]);
spc_gray = single(spc_gray);
basename_g = 'SPECTRALONG1201607';
envihdrwritex(hdr,[basename_g '.hdr']);
envidatawrite(spc_gray,[basename_g '.sli'],hdr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
black_rfl_fpath = [pdir_labsphere '05AA010716_10in/SRT-05-100.txt'];
[ black_rfl ] = spectralonRead( black_rfl_fpath );
hdr = [];
hdr.description = sprintf('{\n    Reflectance of 10in 5%% Spectralon Panel Calibrated by Labsphere.\n    ID: 05AA010716.\n    Reference: 05AA010716 CAL CERT.pdf, SRT-05-100.txt\n}');
hdr.bands = 1;
hdr.samples = size(black_rfl,1);
hdr.lines = 1;
hdr.header_offset = 0;
hdr.file_type = 'ENVI Spectral Library';
hdr.data_type = 4;
hdr.interleave = 'bsq';
hdr.byte_order = 0;
hdr.data_ignore_value = 65535;
hdr.spectra_names = sprintf('{\n  05AA010716\n}');
hdr.wavelength_units = 'nm';
hdr.wavelength = black_rfl(:,1);


spc_black = reshape(black_rfl(:,2),[hdr.lines,hdr.samples,hdr.bands]);
spc_black = single(spc_black);
basename_k = 'SPECTRALONK1201607';
envihdrwritex(hdr,[basename_k '.hdr']);
envidatawrite(spc_black,[basename_k '.sli'],hdr);

