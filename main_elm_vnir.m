rootdir = '/Volume2/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/VNIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames([3:end]);

exceptions = {'GU20160726_094555_0101','LY20160804_131027_0202',...
    'GU20160726_151016_0201','GU20160726_153217_0202'};

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM / simpleRatio with 3 panels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'S';
suffix_spcW = 'PMW1_M1_SPC1';
suffix_spcG = 'PMG1_M1_SPC1';
suffix_spcK = 'PMK1_M1_SPC1';
suffix_img = 'RAD1ST1';
suffix_img_new = 'RFL1WST1';
% rfldir = '/Users/yukiitoh/Box Sync/data/labsphere';
rfldir = '/Volume2/data/labsphere';
rflWbasename = 'SPW1RFL_201605_HWUVS234201607_5_BIN5';
rflGbasename = 'SPG1RFL_201607_HWUVS234201607_5_BIN5';
rflKbasename = 'SPK1RFL_201607_HWUVS234201607_5_BIN5';

for i=1:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),exceptions))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
        imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix_img_new];
        spcWbasename = [imgbasename '_' suffix_spcW];
        spcGbasename = [imgbasename '_' suffix_spcG];
        spcKbasename = [imgbasename '_' suffix_spcK];
%         ELMwpanels(pdir,rfldir,imgbasename,imgbasename_new,operator,...
%                     {spcWbasename,spcGbasename,spcKbasename},...
%                     {rflWbasename,rflGbasename,rflKbasename},...
%                     'MODE','linebyline','Force',1);
        simpleRatio(pdir,rfldir,imgbasename,imgbasename_new,operator,...
                    spcWbasename,rflWbasename,...
                    'MODE','linebyline','Force',1);
    end
end

%% processing for exceptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM / simpleRatio with 2 panels, {gray and black}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
operator = 'YI';
sensorID = 'L';
suffix_spcG = 'PMG1_M1_SPC1';
suffix_spcK = 'PMK1_M1_SPC1';
suffix_img = 'RAD1ST1';
suffix_img_new = 'RFL2GST1';
rfldir = '/Users/yukiitoh/Box Sync/data/labsphere';
% rfldir = 'C:/Users/yuki/Box Sync/data/labsphere';
rflGbasename = 'SPG1RFL_201607_HWUVS232201607_1';
rflKbasename = 'SPK1RFL_201607_HWUVS232201607_1';

dnames = {'GU20160726_120703_0101',...
          'GU20160726_122011_0102',...
          'GU20160726_140221_0201',...
          'GU20160726_141241_0202',...
          'HV20160802_133652_0202'};

for i=1:length(dnames)
    d = dnames{i};
    if any(cellfun(@(x) strcmpi(d,x),exceptions))
        
    else
        pdir = joinPath(rootdir,d);
        dcell = strsplit(d,'_');
        baseID = [d(1:2) d(9:10) d(20) d(22)];
        imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
        imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix_img_new];
%         spcWbasename = [imgbasename '_' suffix_spcW];
        spcGbasename = [imgbasename '_' suffix_spcG];
        spcKbasename = [imgbasename '_' suffix_spcK];
        ELMwpanels(pdir,rfldir,imgbasename,imgbasename_new,operator,...
                    {spcGbasename,spcKbasename},...
                    {rflGbasename,rflKbasename},...
                    'MODE','linebyline','Force',1);
%         simpleRatio(pdir,rfldir,imgbasename,imgbasename_new,operator,...
%                     spcGbasename,rflGbasename,...
%                     'MODE','linebyline','Force',1);
    end
end


%% processing for exceptions part2 coversion directly from DNs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peform ELM / simpleRatio with 3 panels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnames = {'GU20160727_100551_0201',...
          'HV20160802_111250_0101'};
      
dnames = {'HV20160729_144053_0301'};
operator = 'YI';
sensorID = 'L';
suffix_spcW = 'PMW1_M1_SPC1';
suffix_spcG = 'PMG1_M1_SPC1';
suffix_spcK = 'PMK1_M1_SPC1';
suffix_img = 'RWD2ST1';
suffix_img_new = 'RFL1WST1';
rfldir = '/Users/yukiitoh/Box Sync/data/labsphere';
% rfldir = 'C:/Users/yuki/Box Sync/data/labsphere';
rflWbasename = 'SPW1RFL_201605_HWUVS232201607_1';
rflGbasename = 'SPG1RFL_201607_HWUVS232201607_1';
rflKbasename = 'SPK1RFL_201607_HWUVS232201607_1';

for i=1:length(dnames)
    d = dnames{i};

    pdir = joinPath(rootdir,d);
    dcell = strsplit(d,'_');
    baseID = [d(1:2) d(9:10) d(20) d(22)];
    imgbasename = [baseID sensorID '_' dcell{2} '_' suffix_img];
    imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix_img_new];
    spcWbasename = [imgbasename '_' suffix_spcW];
    spcGbasename = [imgbasename '_' suffix_spcG];
    spcKbasename = [imgbasename '_' suffix_spcK];
%     ELMwpanels(pdir,rfldir,imgbasename,imgbasename_new,operator,...
%                 {spcWbasename,spcGbasename,spcKbasename},...
%                 {rflWbasename,rflGbasename,rflKbasename},...
%                 'MODE','linebyline','Force',1);
    simpleRatio(pdir,rfldir,imgbasename,imgbasename_new,operator,...
                spcWbasename,rflWbasename,...
                'MODE','linebyline','Force',1);
end