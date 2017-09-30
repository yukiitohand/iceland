%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% double check if the values are correct!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[FileName,PathName,FilterIndex] = uigetfile({'*.bmp;*.png'},'Select RGB image');
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
    PMbasename = [imgBase '_PM' panelID '_' methodID];
    pmcbasename = [imgBase '_PC' panelID '_' methodID];

    pmMatpath = joinPath(pdir,[PMbasename '.mat']);
    pmpath = joinPath(pdir,[PMbasename '.BMP']);
    pcpath = joinPath(pdir,[pmcbasename '.BMP']);
    envidatapath = joinPath(pdir,[PMbasename '.IMG']);
    infoPath = joinPath(pdir,[PMbasename '.HDR']);
    
    btn = 'yes';
    if exist(pmMatpath,'file')
        btn = questdlg(sprintf('%s exist. Do you want to continue?',pmMatpath));
    end

    switch lower(btn)
        case 'yes'
            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % processing
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % read image
            im = imread(joinPath(pdir,[imgBase ext]));
            [PM,xi,yi,pmc] = createROI_man(im);

            %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % saving
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        otherwise
            msgbox('Processing is aborted');
    end
else
    
end
