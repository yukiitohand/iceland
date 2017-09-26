function [modelMat,refGen] = fnEmpiricalLineCalibration(radMat,refMat)
%%
% fnEmpiricalLineCalibration.m
% This function is used to perform the ELM to learn the coefficients given
% a set of radiance spectra and the associated reflectance spectra
%
% ----------------------------------------------------------------------- %
% INPUT
% ----------------------------------------------------------------------- %
% radMat                  : - matrix where each column holds the radiance
%                             of a sample. 
% refMat                  : - matrix where each column holds the
%                             reflectance of the sample. (in same order as
%                             radMat)
% [NOTE] :- At this stage it is assumed that both reflectance and radiance
% spectra have the same length.
% ----------------------------------------------------------------------- %
% OUTPUT
% ----------------------------------------------------------------------- %
% modelMat                : - Holds the model parameters of each band
% refGen                  : - reflectance of training samples from the
%                             radiance
%
% Author Name   : - Arun M Saranathan
% Date Created  : - 09/15/2015
% Date Modified : - 07/25/2016
% Date Modified : - 09/25/2017 Yuki Itoh, 
% ----------------------------------------------------------------------- %

[L,N] = size(radMat);
%intiialize output variables
modelMat = zeros(L,2);
refGen = zeros(L,N);

% for each band learn the model parameters

for i=1:L
    x = radMat(i,:)';
    y = refMat(i,:)';
    X = [ones(length(x),1) x];
    % perform least squares regression to learn parameters
    b = X\y;
    % append as next row of modelMat
    modelMat(i,:)= b;
end
%check fit over training set
if verLessThan('matlab','9.1')
    refGen = b + bsxfun(@times,modelMat(:,2),radMat);
else
    refGen = modelMat(:,1) + modelMat(:,2).*radMat;
end

end %end -function