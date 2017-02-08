
date_time = '2016_07_29_14_40_53';
pdir = sprintf('F:/MicroHyperspec/SWIR data/captured/%s/',date_time);

bname = 'raw';
hdr = envihdrread_yuki([pdir bname '.hdr']);
%img = envidataread([pdir bname],hdr);

bnameNew =[bname '_frfixed'];


lines = hdr.lines;
lines_new = floor(lines/10);
hdrNew = hdr;
hdrNew.lines = lines_new;

for l=1:lines_new
    imglNew = zeros([hdr.bands,hdr.samples]);
    for i=1:10
        imgl = lazyEnviReadl([pdir bname],hdr,i+10*(l-1));
        imglNew = imglNew + double(imgl);
    end
    
    imglNew = uint16(imglNew/10);
    lazyEnviWritel([pdir bnameNew],imglNew,hdrNew,l,'a');
end


envihdrwrite_yuki(hdrNew,[pdir bnameNew '.hdr']);