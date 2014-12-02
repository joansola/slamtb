function handle = createSimLmkGraphics(SimLmk,colr,ax,showSimLmk)

%CREATESIMLMKGRAPHICS Create simulated landmark graphics.
%   CREATESIMLMKGRAPHICS(SIMLMK,LBLCLR) creates the graphics objects for
%   the simulated landmarks SIMLMK. The function supports opints and
%   segments graphics, as specified by SIMLMK.opints and SIMLMK.segments.
%
%   CREATESIMLMKGRAPHICS(...,AX) creates the graphics at axes AX.
%
%   [PH,LH] = CREATESIMLMKGRAPHICS returns handles to the 'line' graphics
%   objects. PH for one 'line' object with all points. 'SH' for N 'line'
%   objects, one for each segment.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 3
    ax = gca;
end

% points
if ~isempty(SimLmk.points.coord) && showSimLmk
    ph = line(...
        'parent',       ax,...
        'xdata',        SimLmk.points.coord(1,:),...
        'ydata',        SimLmk.points.coord(2,:),...
        'zdata',        SimLmk.points.coord(3,:),...
        'color',        colr,...
        'linestyle',    'none',...
        'marker',       '+',...
        'markersize',   4);
else
    ph = line('vis','off');
end

% segments
if ~isempty(SimLmk.segments.coord) && showSimLmk
    sh = drawSegmentsObject(SimLmk.segments.coord,colr,2);
else
    sh = [];
end

% all graphics
handle = [ph;sh];



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

