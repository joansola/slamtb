function handleStr = createLmkGraphics(Lmk,labelColor,ax)

%CREATELMKGRAPHICS Create landmark graphics.
%   CREATELMKGRAPHICS(LMK,LBLCLR) creates the graphics objects for the
%   landmark LMK: a 3-sigma ellipsoid, a mean point, and a label with color
%   LBLCLR.
%
%   CREATELMKGRAPHICS(...,AX) creates the graphics at axes AX.
%
%   HSTR = CREATELMKGRAPHICS returns a structure of handles for the three
%   objects plus a flag for drawn landmarks:
%       HSTR.drawn      is landmark drawn?
%       HSTR.mean       the mean
%       HSTR.ellipse()  the 3-sigma ellipsoids
%       HSTR.label      the label.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    ax = gca;
end

handleStr.drawn = false;     % flag for drawn landmark

handleStr.mean = line(...    % for the means, point or segment
    'parent',       ax,...
    'xdata',        [],...
    'ydata',        [],...
    'zdata',        [],...
    'linestyle',    '-',...
    'linewidth',    2,...
    'marker',       '.',...
    'visible',      'off');

handleStr.ellipse(1) = line(...  % for covariances, point or segment
    'parent',       ax,...
    'xdata',        [],...
    'ydata',        [],...
    'zdata',        [],...
    'linestyle',    '-',...
    'marker',       'none',...
    'visible',      'off');

handleStr.ellipse(2) = line(... % for covariances, only for segments
    'parent',       ax,...
    'xdata',        [],...
    'ydata',        [],...
    'zdata',        [],...
    'linestyle',    '-',...
    'marker',       'none',...
    'visible',      'off');

handleStr.label = text(...    % for the label, point or segment
    'parent',              ax,...
    'string',              num2str(Lmk.lmk),...
    'color',               labelColor,...
    'fontsize',            10,...
    'fontweight',          'normal',...
    'horizontalalignment', 'center',...
    'visible',             'off');



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

