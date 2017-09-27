function [] = splitVNIRImage(fileList,operator)

lsize = 3000;

for i=1:length(fileList)
    file = fileList{i};
    [pdir,bname,ext] = fileparts(file);
    
    split_fameIndex( pdir,'frameIndex',lsize);
    
    orifilepath = joinPath(pdir,bname);
    split_image(pdir,bname,lsize,'RHO_ORIGINALIMAGE',orifilepath,'RHO_OPERATOR',operator,'RHO_SPLITSIZE',lsize);
    
end

end