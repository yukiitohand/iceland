pdir = 'E:\data\headwall\MicroHyperspec\201607-08_iceland\iceland2016\SWIR data\captured\LY20160805_064115_0401';

basename = 'LY0541L_064115_RAD1ST1';

imgPath = joinPath(pdir,[basename,'.IMG']);
hdrPath = joinPath(pdir,[basename,'.HDR']);
hdr = envihdrreadx(hdrPath);

img = lazyEnviReadRGB(imgPath,hdr,[11 37 68]);

spc = lazyEnviRead(imgPath,hdr,299,95);

R = img(:,:,1)/21;
G = img(:,:,2)/12;
B = img(:,:,3)/8;
imRGB = cat(3, R,G,B);
imRGB(imRGB<0) = 0;


imgPath = joinPath(pdir,[basename '_R11G37B68.png']);

figure; img = sc(imRGB);

imwrite(img,imgPath);
