
list = {'GU20160726_120703_0101','G';...
        'GU20160726_122011_0102','G';...
        'GU20160727_084245_0101','W';...
        'LY20160806_113804_0101','W';...
        'LY20160806_122241_0102','W';...
        'LY20160806_131005_0201','W';...
        'LY20160806_133419_0202','W'};

d = 'LY20160806_133419_0202';
pdir = joinPath(rootdir,d);

dcell = strsplit(d,'_');
baseID = [d(1:2) d(9:10) d(20) d(22)];
imgbasename_new = [baseID sensorID '_' dcell{2} '_' 'DAT0ST1'];
flip_image(pdir,d,'data',imgbasename_new,operator,'Force',1);

imgcor_base = strrep(imgbasename_new,'DAT0','RFL0');
simpleMultiplyRFL(pdir,rfldir,imgbasename_new,imgcor_base,operator,rflWbasename,...
                    'MODE','linebyline','Force',1);

hdr = envihdrreadx(joinPath(pdir,[imgcor_base '.HDR']));
img = envidataread_v2(joinPath(pdir,[imgcor_base '.IMG']),hdr);

hsi = [];
hsi.hdr = hdr;
hsi.img = img;
hsiview(hsi.img(:,:,[11,73,140]),{hsi},{'aa'});