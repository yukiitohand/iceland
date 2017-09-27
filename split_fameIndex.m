function [  ] = split_fameIndex( pdir,frameIndexbase,lsize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% lsize = splitsize;

frameIndexFile = joinPath(pdir,[frameIndexbase '.txt']);

fpr = fopen(frameIndexFile,'r');
ln1 = fgetl(fpr);
% lsize = 3000;
% reps = ceil(lines/lsize);
r = 1;
while ~feof(fpr)
    l_strt = lsize*(r-1)+1;
%     l_end = min(lsize*r,lines);
%     s = l_end-l_strt+1;
    basenamefw = sprintf('%s_%d.txt',frameIndexbase,l_strt-1);
    fpw = fopen(joinPath(pdir,basenamefw),'w');
    fprintf(fpw,'%s\n',ln1);
    s=1;
    while ~(s>lsize || feof(fpr))
        ln = fgetl(fpr);
        fprintf(fpw,'%s\n',ln);
        s = s+1;
    end
    fclose(fpw);
    r = r+1;
end
fclose(fpr);


end

