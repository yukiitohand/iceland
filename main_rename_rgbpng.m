rootdir = 'E:/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured/';

ds = dir(rootdir);

dnames = [{ds.name}];
dnames = dnames(3:end);

% suffix = 'RAW1ST1';
% sensorID = 'L';
% for i=25:length(dnames)
%     d = dnames{i};
%     dcell = strsplit(d,'_');
%     baseID = [d(1:2) d(9:10) d(20) d(22)];
%     
%     imgbasename_new = [baseID sensorID '_' dcell{2} '_' suffix];
%     sourcePath = joinPath(rootdir,d,'rawR73G31B15.png');
%     destPath = joinPath(rootdir,d,[imgbasename_new '_R73G31B15.png']);
%     movefile(sourcePath,destPath);
% end

%%

suffix_pmW = 'ST1_PMG1_M1';

suffix_pcW = 'ST1_PCG1_M1';

pmWsourcebase = 'panel_mask_gray';
pcWsourcebase = 'panel_black_comb';

sensorID = 'L';
for i=2:length(dnames)
    d = dnames{i};
    dcell = strsplit(d,'_');
    baseID = [d(1:2) d(9:10) d(20) d(22)];
    
    prefix = [baseID sensorID '_' dcell{2}];
    
    pmWsourcePath = joinPath(rootdir,d,[pmWsourcebase '.mat']);
    pmWdestbasename = [prefix '_' suffix_pmW];
    pmWdestPath = joinPath(rootdir,d,[pmWdestbasename '.mat']);
    btn = 'yes';
    if exist(pmWdestPath,'file')
        btn = questdlg(sprintf('%s exist. Do you want to continue?',pmWdestPath),'Warning','Yes','no','cancel');
    end
    switch lower(btn)
        case 'yes'
            if exist(pmWsourcePath,'file')
                load(pmWsourcePath,'BW','xi','yi');
                PM = BW;
                save(pmWdestPath,'PM','xi','yi');
            end
        otherwise
    end
    
%     pmWbmpPath = joinPath(rootdir,d,[pmWsourcebase '.bmp']);
%     pmWbmpdestPath = joinPath(rootdir,d,[pmWdestbasename '.BMP']);
%     btn='yes';
%     if exist(pmWbmpdestPath,'file')
%         btn = questdlg(sprintf('%s exist. Do you want to continue?',pmWbmpdestPath),'Warning','Yes','no','cancel');
%     end
%     switch lower(btn)
%         case 'yes'
%             if exist(pmWbmpPath,'file')
%                copyfile(pmWbmpPath,pmWbmpdestPath);
%             end
%         otherwise
%     end
%     
%     pcWbmpPath = joinPath(rootdir,d,[pcWsourcebase '.bmp']);
%     pcWdestbasename = [prefix '_' suffix_pcW];
%     pcWbmpdestPath = joinPath(rootdir,d,[pcWdestbasename '.BMP']);
%     btn = 'yes';
%     if exist(pcWbmpdestPath,'file')
%         btn = questdlg(sprintf('%s exist. Do you want to continue?',pcWbmpdestPath),'Warning','Yes','no','cancel');
%     end
%     switch lower(btn)
%         case 'yes'
%             if exist(pcWbmpPath,'file')
%                copyfile(pcWbmpPath,pcWbmpdestPath);
%             end
%         otherwise
%     end
%     
    
end