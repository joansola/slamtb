function c = camGraphics(csize,euler)

%CAMGRAPHICS Create a camera graphics 3D object.
%   CAMGRAPHICS creates a solid representing a camera. The objective is
%   heading towards the camera optical axis and is located at camera
%   position. Initial configuration is: position at origin and optical
%   axis aligned with world's Z axis.
%
%   The result is a structure with fields:
%       .vert0  the vertices in camera frame.
%       .vert   the vertices in world frame.
%       .faces  the definition of faces.
%
%   Fields .vert and .faces are used to draw the object via the PATCH
%   command. Further object repositionning is accomplished with DRAWOBJECT.
%
%   CAMGRAPHICS(SIZE) allows for choosing the camera size. Default is 0.1.
%
%   CAMGRAPHICS(SIZE,EULER) admits a different orientation to the default
%   one. To make the camera look in the X-axis direction, use EULER =
%   [-pi/2 0 -pi/2].
%
%   See also PATCH, SET, DRAWOBJECT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 2
    euler = zeros(3,1);
    if nargin < 1
        csize = 0.1;
    end
end


d = .6; % objective diameter
f = .5; % objective length
h = .8; % body height
w = 1;  % body width
t = .3; % body thickness

% objective vertices
a         = (0:pi/4:2*pi-pi/4)';
na        = length(a);
circle    = d/2*[cos(a),sin(a)];
objective = [circle,zeros(na,1);circle,f*ones(na,1)];

% body vertices
rect      = [1 1;-1 1;-1 -1;1 -1]*diag([w h])/2;
body      = [rect,zeros(4,1);rect,-t*ones(4,1)];

% rotation matrix
R = e2R(euler);

% vertices in camera frame
vert0     = [body;objective]*R';

% graphics structure - vertices and faces
c.vert0   = csize*vert0;
c.vert    = c.vert0;
c.faces   = [ ...
    01 02 03 04
    05 06 07 08
    01 02 06 05
    02 03 07 06
    03 04 08 07
    04 01 05 08
    09 10 18 17
    10 11 19 18
    11 12 20 19
    12 13 21 20
    13 14 22 21
    14 15 23 22
    15 16 24 23
    16 09 17 24];



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

