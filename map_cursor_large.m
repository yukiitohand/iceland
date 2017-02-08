function output_txt = map_cursor_large(obj,event_obj,ax_spc,hdr,datapath,wv)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');
output_txt = {['X: ',num2str(pos(1),4)],...
    ['Y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

% plot spectra
spc = lazyEnviRead(datapath,hdr,pos(1),pos(2));
plot(ax_spc,wv,spc,'r-');
hold(ax_spc,'on');
axis(ax_spc,'tight');
% ylim(ax_spc,[0,1]);
hold(ax_spc,'off');
xlabel(ax_spc,'Wavelength');
ylabel(ax_spc,'Reflectance');
legend(ax_spc,{'Image spectrum'});


end