function [ ave_rfrSpc_crd, residual_map,rfrSpc ] = get_rfrDNSpc_residualHardThresholding_largeimage( hdr,datafile,imgDark,roi_ul,roi_lr,yx_rfr,th)
% [ ave_rfrSpc, residual_map ] = get_rfrDNSpc_residualHardThresholding_largeimage( hdr,datafile,imgDark,roi_ul,roi_lr, yx_rfr, th)
%   automatic method for computing averaged reference spectrum in the
%   scene. use norm of the residual and hard thresholding to select pixles
%   to be averaged. This is optimized for large images that cannot be
%   loaded onto memory.
%     Input
%        hdr: header file for the image
%        datafile: path to the image
%        imgDark: dark image (1xLxS)
%        roi_ul: coordinate of the upper left of the region of interest
%        roi_lr: coordinate of the lower right of the region of interest
%        yx_rfr: coordinate of the reference spectrum to be compared
%        th: threshold used for hard thresholding
%     Output
%        ave_rfrSpc_crd (B,1) averaged reference spectrum in the scene
%        residual_map: (L,S) map of the residual of pixel spectra with
%        reference spectrum
%        rfrSpc_crd: (B,1) reference spectrum

% Read reference spectrum
rfrSpc = lazyEnviRead(datafile,hdr,yx_rfr(2),yx_rfr(1));
bands = length(rfrSpc);
rfrSpc = reshape(rfrSpc,[1,1,bands]);
% dark subtraction for the reference spectrum
[ rfrSpc_crd ] = subtract_dark( rfrSpc,imgDark(1,yx_rfr(2),:) );
rfrSpc_crd = squeeze(rfrSpc_crd);

roi_size = roi_lr-roi_ul+1;
residual_map = zeros(roi_size);

cum_rfrSpc_crd = zeros(size(rfrSpc_crd));
imgDark_roi = double(imgDark(:,roi_ul(2):roi_lr(2),:));
for i=1:roi_size(1)
    l = roi_ul(1)+i-1;
    Y = lazyEnviReadl(datafile,hdr,l); % read image line
    Y_roi = Y(:,roi_ul(2):roi_lr(2));
    Y_roi = reshape(Y_roi',[1 roi_size(2) bands]);
    Y_roi = double(Y_roi);
    Y_roi_crd = subtract_dark( Y_roi,imgDark_roi );
    Y_roi_crd = squeeze(Y_roi_crd)';
    rVec = bsxfun(@minus,Y_roi_crd,rfrSpc_crd);
    r = vnorms(rVec,1)/sqrt(bands);
    residual_map(i,:) = r;
    
    % compute cumulative sum
    if any(r<th)
        cum_rfrSpc_crd = cum_rfrSpc_crd + sum(Y_roi_crd(:,r<th),2);
    end
end

map_thresholded = residual_map<th;
map_thresholded = map_thresholded(:);

ave_rfrSpc_crd = cum_rfrSpc_crd / sum(map_thresholded);
end

