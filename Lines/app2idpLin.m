function idl = app2idpLin(p0,p1,p2)

% APP2IDL Anchor and points to inverse depth line conversion.
%   APP2IDL(P0,P1,P2) converts the line passing by the points P1 and P2
%   into the inverse-depth line anchored at point P0. the inverse depth
%   line is coded as
%
%       [P0;M1;R1;M2;R2]
%
%   where
%       P0 is the anchor point
%       Mi are the pitch and yaw director angles of the ray P0-Pi
%       Ri is the inverse of the distance from P0 to Pi

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% the director rays vectors
v1 = p1-p0;
v2 = p2-p0;

%The director rays angles
m1 = vec2py(v1);
m2 = vec2py(v2);

% The inverse of the distances
r1 = 1/norm(v1);
r2 = 1/norm(v2);

% the inverse-depth line
idl = [p0;m1;r1;m2;r2];



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

