function [ data ] = spectralonRead( fpath )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [ data ] = spectralonRead( fpath )
%   Read a text file storing calibrated reflectance of the spectralon
%   manufactured by Labsphere
%   Inputs
%     fpath: path to the text file
%   Outputs
%     data: [L x 2], first column is the wavelength and the second is the
%           refelectance
%   ----------------
%   The text file looks like
%
%   05AA010716	
%   250	0.0371
%   251	0.0372
%   252	0.0370
%   253	0.0368
%   254	0.0368
%   255	0.0368
%       :
%       :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen(fpath,'r');
data = [];
flg = 1;
tline = fgets(fid); % skip the first line
while flg
    tline = fgets(fid);
    if ~ischar(tline)
        flg = 0;
    else
    t = str2double(strsplit(tline(1:end-1),'\t'));
    data = [data;t];
    end
end

fclose(fid);

end

