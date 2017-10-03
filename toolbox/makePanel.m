%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% double check if the values are correct!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
default_folder = '/Volumes/SED/data/headwall/MicroHyperspec/201607-08_iceland/iceland2016/SWIR data/captured';
[FileName,PathName,FilterIndex] = uigetfile({'*.bmp;*.png'},'Select RGB image',default_folder);
% pdir = 'E:\data\headwall\MicroHyperspec\201607-08_iceland\iceland2016\SWIR data\captured\GU20160726_120703_0101';
% imgBase = 'GU2611L_120703_RAW1ST1_R73G31B15';

if FileName
    pdir = PathName;
    [~,imgBase,ext] = fileparts(FileName);
    
    panelID = 'G1';
    methodID = 'M1';
    description = 'Panel mask for gray';
    operator = 'YI';
    
    prompt = {'Panel ID','method ID','description','operator'};
    dlg_title = 'Input some properties';
    num_lines = [1 50];
    defaultans = {panelID,methodID,description,operator};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    panelID = answer{1}; methodID = answer{2}; description = answer{3};
    operator = answer{4};
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % value setup
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sceneID = imgBase(1:14); stripID = imgBase(20:22);
    PMbasename = [sceneID '_' stripID '_PM' panelID '_' methodID];
    pmcbasename = [sceneID '_' stripID '_PC' panelID '_' methodID];

    pmMatpath = joinPath(pdir,[PMbasename '.mat']);
    pmpath = joinPath(pdir,[PMbasename '.BMP']);
    pcpath = joinPath(pdir,[pmcbasename '.BMP']);
    envidatapath = joinPath(pdir,[PMbasename '.IMG']);
    infoPath = joinPath(pdir,[PMbasename '.HDR']);
    
    btn = 'yes';
    if exist(pmMatpath,'file')
        btn = questdlg(sprintf('%s exist. Do you want to continue?',pmMatpath),'Warning','Yes','no','no');
    end

    switch lower(btn)
        case 'yes'
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % processing
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % read image
            flg_sel = 1;
            while flg_sel
                try
                    imgRGB = imread(joinPath(pdir,[imgBase ext]));
                    [PM,xi,yi,pmc] = createROI_man(imgRGB);
                    flg_sel = 0; flg_save = 1;
                catch
                     btn2 = questdlg('Cannot get ROI. Do you want to retry?','Retry','Yes','No','Yes');
                     switch btn2
                         case 'Yes'
                             flg_sel=1;
                         case 'No'
                             flg_sel =0; flg_save = 0;
                     end
                end
            end
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % saving
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if flg_save
                hdr = envihdrnew(...
                    'description',description,...
                    'lines',size(imgRGB,1),...
                    'samples',size(imgRGB,2),...
                    'bands',1,...
                    'file_type','ENVI Standard',...
                    'RHO_ORIGINAL_IMAGE', imgBase,...
                    'RHO_OPERATOR', operator,...
                    'RHO_DATE_PROCESSED',datestr(now),...
                    'RHO_PANEL_EXTRACT_METHOD','M1:createROI_man')

                save(pmMatpath,'PM','pmc','xi','yi');

                imwrite(PM,pmpath);
                imwrite(pmc,pcpath);

                envidatawrite(PM,envidatapath,hdr);
                envihdrwritex(hdr,infoPath);
            else
                msgbox('Processing is aborted');
            end
        case 'load and update'
            % read image
            imRGB = imread(joinPath(pdir,[imgBase ext]));
            load(pmMatpath,'PM','xi','yi');
            
            imRGB = double(imRGB);
            pmc = sc(cat(3,imRGB.*PM,imRGB),'prob');
            
             hdr = envihdrnew(...
                'description',description,...
                'lines',size(imRGB,1),...
                'samples',size(imRGB,2),...
                'bands',1,...
                'file_type','ENVI Standard',...
                'RHO_ORIGINAL_IMAGE', imgBase,...
                'RHO_OPERATOR', operator,...
                'RHO_DATE_PROCESSED',datestr(now),...
                'RHO_PANEL_EXTRACT_METHOD','M1:createROI_man')

            save(pmMatpath,'PM','pmc','xi','yi');

%             imwrite(PM,pmpath);
%             imwrite(pmc,pcpath);

            envidatawrite(PM,envidatapath,hdr);
            envihdrwritex(hdr,infoPath);
            
        otherwise
            msgbox('Processing is aborted');
    end
else
    
end
