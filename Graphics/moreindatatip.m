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



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

