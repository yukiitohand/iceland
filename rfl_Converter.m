function [hsi] = rfl_Converter(pdir,basename,meth,initial,varargin)
%  [hsi] = rfl_Converter(pdir,basename,mode,initial)
%    wrapper for reflectance conversion
%  Input Parameters
%    pdir: directry we are working on
%    basename: basename of the image we process
%    meth: specify method to use; 1: white simple conversion, 2: using
%          three panels
%    inital: put your initial
%  Optional Parameters
%    'PANELOVERWRITE' : boolean, whether or not to perform manual selection of
%                       panels again or not; (default) false
%  Output Parameters
%    hsi: struct of the hyperspectral image, two fields
%         'img', and 'hdr'
%

paneloverwrite = false;
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'PANELOVERWRITE'
                paneloverwrite = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end
    end
end


imgPath = joinPath(pdir,basename);
hdrPath = joinPath(pdir,[basename,'.hdr']);
hdr = envihdrreadx(hdrPath);

img = envidataread(imgPath,hdr);
img = permute(img,[2 1 3]);

img = flip(img,1);
R = img(:,:,hdr.default_bands(3)) / 7;
G = img(:,:,hdr.default_bands(2)) / 13;
B = img(:,:,hdr.default_bands(1)) /20;
imRGB = cat(3, R,G,B);
imRGB(imRGB<0) = 0;

% conversion
switch meth
    case 1
        suffix = '_rfwr3';
        [BW_w,xi_w,yi_w] = extractPanel_man(pdir,imRGB,'white','OVERWRITE',paneloverwrite);
        [white_rfl_rsmp,~,~] = loadPanelrfl(hdr);
        [im_cor,hdr_cor] = whiteRatioing(hdr,img,BW_w,white_rfl_rsmp);
    case 2
        suffix = '_rf3r1';
        [BW_w,xi_w,yi_w] = extractPanel_man(pdir,imRGB,'white','OVERWRITE',paneloverwrite);
        [BW_g,xi_g,yi_g] = extractPanel_man(pdir,imRGB,'gray','OVERWRITE',paneloverwrite);
        [BW_k,xi_k,yi_k] = extractPanel_man(pdir,imRGB,'black','OVERWRITE',paneloverwrite);
        [white_rfl_rsmp,gray_rfl_rsmp,black_rfl_rsmp] = loadPanelrfl(hdr);
        
    otherwise
        error('The mode is not recognized');
end

%
hdr_cor = hdrupdate(hdr_cor,'RHO_INITIAL',initial);

% save
basename_new = [basename suffix];

imgPath_new = joinPath(pdir,basename_new);
hdrPath_new = joinPath(pdir,[basename_new, 'hdr']);

envidatawrite(img_cor,imgPath_new,hdr_cor);
envihdrwritex(hdr_cor,hdrPath_new);

hsi = [];
hsi.img = im_cor;
hsi.hdr = hdr_cor;

end

function [BW,xi,yi] = extractPanel_man(pdir,imRGB,color,varargin)
% [BW,xi,yi] = extractPanel_man(pdir,imRGB,color,varargin)
%   extract the location of panels manually using ROI tool in MATLAB
%    Input Parameters
%      pdir: directroy where we are working on, string
%      imRGB: RGB image on which the panel is detected, image array
%      color: color of the panel, string
%    Output Parameters
%      BW: Boolean image, true is the position of the panel, same size as
%          the imRGB
%      xi, yi: 1d array to represent the coordinate values of vertexes.
%    Optional Parameters
%      'OVERWRITE' : boolean, whether or not to perform manual detection
%                    again or not; (default) false

overwrite = false;
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'OVERWRITE'
                overwrite = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end
    end
end

fpathMaskdata = joinPath(pdir,sprintf('panel_mask_%s.mat','color'));
cache_exist = exist(fpathMaskdata,'file');
if cache_exist && ~overwrite
    load(fpathMaskdata);
else
    fig = figure; imagesc(imRGB);
    set(gca,'dataAspectRatio',[1 1 1]);
    title(sprintf('Focus, pan, and locate the %s panel!!',color));
    flg = 1;
    while flg
        [BW, xi, yi] = roipoly();
        if isempty(BW)
            title(sprintf('Try again (%s)',color));
        else
            flg = 0;
        end
    end

    clf(fig);
    fpath_im_color_mask = joinPath(pdir,sprintf('panel_%s_mask.bmp',color));
    imwrite(BW,fpath_im_color_mask);

    fig = figure; 
    img_combine = sc(cat(3,imRGB.*BW,imRGB),'prob');
    title(sprintf('Selected image mask (%s)',color));
    fpath_im_color_comb = joinPath(pdir,sprintf('panel_%s_comb.bmp',color));
    imwrite(img_combine,fpath_im_color_comb);
    title('Are you satisfied with this? (Press enter)');
    set(gca,'dataAspectRatio',[1 1 1]);
    pause;
    clf(fig);

    save(fpathMaskdata,'BW','xi','yi');
end
    
end