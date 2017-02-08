function [ yq ] = interpGaussian( x,y,xq,fwhm )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
sigma = 2*sqrt(2*log(2))*fwhm;
yq = zeros([length(xq),1]);
for i =1:length(xq)
    c = normpdf(x,xq(i),sigma);
    c_sum = sum(c);
    yq(i) = sum(c.*y) /c_sum;
end

end

