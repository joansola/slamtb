function moreindatatip
% MOREINDATATIP  Display index information in the data tip.
%
% Extends the displayed text of the datatip to get the index of the clicked
% point. The extension remains until the figure is deleted. If datatip(s)
% was previously present, a message prompts the user to right-click on the
% figure to delete all datatips in order to switch on the capabilities of
% the datatip.
%
% may 2006
% Jean-luc.dellis@u-picardie.fr

dcm_obj = datacursormode(gcf);
if ~isempty(findall(gca,'type','hggroup','marker','square'))% if there is datatip, please delete it
    info_struct = getCursorInfo(dcm_obj);
    xdat=get(info_struct.Target,'xdata');
    ydat=get(info_struct.Target,'ydata');
    zdat=get(info_struct.Target,'zdata');
    if isempty(zdat),zdat=zeros(size(xdat));set(info_struct.Target,'zdata',zdat),end
    index=info_struct.DataIndex;
    ht=text(xdat(index)*1.05,ydat(index)*1.05,zdat(index)*1.05,...
        {'right-click on the figure';'to ''delete all datatips''';'in order to get more'},...
        'backgroundcolor',[1,0,0.5],'tag','attention');
end
set(dcm_obj,'enable','on','updatefcn',@myupdatefcn,'displaystyle','datatip')
%-------------------------------------------------------------------------%
function txt = myupdatefcn(empt,event_obj)
% Change the text displayed in the datatip. Note than the actual coordinates
% are displyed rather the position field of the info_struct.
ht=findobj('tag','attention');
if ~isempty(ht),delete(ht),end
dcm_obj = datacursormode(gcf);
info_struct = getCursorInfo(dcm_obj);
xdat=get(info_struct.Target,'xdata');
ydat=get(info_struct.Target,'ydata');
zdat=get(info_struct.Target,'zdata');
index=info_struct.DataIndex;
    if isempty(zdat)
     txt = {['X: ',num2str(xdat(index))],...
       ['Y: ',num2str(ydat(index))],...
       ['index: ',num2str(index)]};
    else
    txt = {['X: ',num2str(xdat(index))],...
       ['Y: ',num2str(ydat(index))],...
       ['Z: ',num2str(zdat(index))],...
       ['index: ',num2str(index)]};
    end









