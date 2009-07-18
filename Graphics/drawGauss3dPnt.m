function drawGauss3dPnt(hnds,x,P,color,label,posOffset,ns,NP)

% DRAWGAUSS3DPNT  Draw Gaussian 3d point
%   DRAWGAUSS2DPNT(HNDS,X,P,COLOR,LABEL,LOFF) draws the Gaussian 3d point
%   defined in handles HNDS, at position X, with an ellipsoid corresponding
%   to covariances matrix P (with 10 points and 3-sigma size), with color
%   COLOR, with a label LABEL at LOFF pixels from the point X.
%
%   The handles are in structure HNDS as follows:
%       .mean    handle for the point's mean
%       .ellipse handle for the ellipsoid
%       .label   handle for the label
%
%   DRAWGAUSS3DPNT(...,NS,NP) accepts the sigma size NS and the number of
%   points NP for drawing the ellipse.

if nargin < 8
    NP = 10;
    if nargin < 7
        ns = 3;
    end
end

% the mean:
set(hnds.mean,...
    'xdata',   x(1),...
    'ydata',   x(2),...
    'zdata',   x(3),...
    'color',   color.mean,...
    'marker',  '.',...
    'visible', 'on');

% the ellipsoid
[X,Y,Z] = cov3elli(x, P, ns, NP) ;
set(hnds.ellipse,...
    'xdata',   X,...
    'ydata',   Y,...
    'zdata',   Z,...
    'color',   color.ellip,...
    'visible', 'on');

% the label
set(hnds.label,...
    'position', x + posOffset,...
    'string',   label,...
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

