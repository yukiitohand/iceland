basenames = {'SPECTRALONW1201605','SPECTRALONG1201607','SPECTRALONK1201607'};

hdrHWfile = 'E:\data\headwall\MicroHyperspec\201607-08_iceland\iceland2016\VNIR data\captured\2016_08_04_12_43_42\raw.hdr';
hdrHWfile = 'E:\data\headwall\MicroHyperspec\201607-08_iceland\iceland2016\SWIR data\captured\GU20160726_120703_0101\raw.hdr';

hdrHW = envihdrreadx(hdrHWfile); pixelfwhm = 5;
for i=1:length(basenames)
    basename = basenames{i};
    
    hdr = envihdrreadx([basename '.hdr']);
    spc = envidataread_v2([basename '.sli'],hdr);
    spc = squeeze(spc);
    
    w = mean(hdrHW.wavelength(2:end)-hdrHW.wavelength(1:end-1));
    switch hdrHW.Serial_Number
        case 'uVS-234'
            pixelfwhm = 5;
            fwhm = w*pixelfwhm; % full width half maximum (fwhm) for vnir
        case 'uVS-232'
            pixelfwhm = 1;
            fwhm = w*pixelfwhm; % fwhm for swir
        otherwise
            error('serial number is invalid');
    end
    
    [ spc_rsmp ] = interpGaussConv( hdr.wavelength',spc', hdrHW.wavelength',fwhm );
    
    
    
    spc_rsmp = reshape(spc_rsmp,[1,hdrHW.bands,1]);
    spc_rsmp = single(spc_rsmp);
    
    hdrNew = hdr;
    hdrNew.description = [hdr.description(1:end-1) sprintf('  Interpolated to the wavelength of %s calibrated on 201607 by Headwall\n}',hdrHW.Serial_Number)];
    hdrNew.samples = hdr.samples;
    hdrNew.wavelength = hdrHW.wavelength;
    hdrNew.wavelength_units = 'nm';
    hdrNew.RHO_OPERATOR = 'YI';
    hdrNew.RHO_INTERPOLATION_METHOD = 'interpGaussConv';
    hdrNew.RHO_INTERPOLATION_PIXELFWHM = pixelfwhm;
    hdrNew.RHO_INTERPOLATION_FWHM = fwhm;
    hdrNew.RHO_ORIGINAL_FILE = basename;
    
    switch hdrHW.Serial_Number
        case 'uVS-234'
            suffix = sprintf('_HWUVS234201607_%d',pixelfwhm);
        case 'uVS-232'
            suffix = sprintf('_HWUVS232201607_%d',pixelfwhm);
        otherwise
            error('serial number is invalid');
    end
    
    basenameNew = [basename suffix];
    
    envihdrwritex(hdrNew,[basenameNew '.hdr']);
    envidatawrite(spc_rsmp,[basenameNew '.sli'],hdrNew);
    
end