function [ data ] = spectralonRead( fpath )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
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

