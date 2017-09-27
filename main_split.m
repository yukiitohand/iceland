pd = 'E:\data\headwall\MicroHyperspec\201607-08_iceland\iceland2016\VNIR data\captured';
pd = strrep(pd,'\','/');
d = dir(pd);
for i=1:length(d)
dirNameList{i} = d(i).name;
end
dirNameList = dirNameList(3:end);

for i=1:length(dirNameList)
a = joinPath(pd,dirNameList{i},'raw');
a = strrep(a,'\','/');
fpathList{i} = a;
end

splitVNIRImage(fpathList,'YI');