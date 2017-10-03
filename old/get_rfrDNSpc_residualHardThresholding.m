function [ ave_rfrSpc, residual_map ] = get_rfrDNSpc_residualHardThresholding( img_roi,imgDark_roi, yx_rfr_roi, th)
% [ ave_rfrSpc, residual_map ] = get_rfrDNSpc_residualHardThresholding( img_roi, yx_rfr_roi, th)
%   automatic method for computing averaged reference spectrum in the
%   scene. use norm of the residual and hard thresholding to select pixles
%   to be averaged.
%     Input
%        img_roi (L,S,B) hyperspectral image (region of interest)
%        imgDark_roi (1,S,B) dark measurement (region of interest)
%        yx_rfr_roi: coordinate of the reference spectrum for the img_roi
%        th: threshold used for hard thresholding
%     Output
%        ave_rfrSpc (B,1) averaged reference spectrum in the scene
%        residual map: (L,S) map of the residual of pixel spectra with
%        reference spectrum

% dark subtraction
[ img_roi_crd ] = subtract_dark( img_roi,imgDark_roi );

rfrSpc = squeeze(img_roi_crd(yx_rfr_roi(1),yx_rfr_roi(2),:));

residual_map = zeros(size(img_roi,1),size(img_roi,2));
bands = length(rfrSpc);
for i=1:size(img_roi_crd,1)
    Y = squeeze(img_roi_crd(i,:,:))';
    rVec = bsxfun(@minus,Y,rfrSpc);
    r = vnorms(rVec,1)/sqrt(bands);
    residual_map(i,:) = r;
end

% figure; imagesc(residual_map<th);
% set(gca,'dataAspectRatio',[1 1 1]);

% figure;
% hist(residual_map(:),th);

img_roi_crd_2d = reshape(img_roi_crd,[size(img_roi_crd,1)*size(img_roi_crd,2),size(img_roi_crd,3)])';
map_thresholded = residual_map<th;
map_thresholded = map_thresholded(:)';

% figure; plot(img_roi2d(:,idx_ref));

ave_rfrSpc = mean(img_roi_crd_2d(:,map_thresholded),2);

end

