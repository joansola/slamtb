function drawPnt(pntHandles,x,P,color)

% DRAWPNT  Draw 3D Gaussian point with covariance and label.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

posOffset = [0;0;.2];

% the expectation's mean:
set(pntHandles.mean,...
    'xdata',   x(1),...
    'ydata',   x(2),...
    'zdata',   x(3),...
    'color',   satColor(color),...
    'visible', 'on');

% the expectation's ellipse
[X,Y,Z] = cov3elli(x, P, 3, 10) ;
set(pntHandles.ellipse,...
    'xdata',   X,...
    'ydata',   Y,...
    'zdata',   Z,...
    'color',   color,...
    'visible', 'on');

% the label
set(pntHandles.label,...
    'position', x + posOffset,...
    'string',   num2str(Lmk.id),...
    'visible',  'on');



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

