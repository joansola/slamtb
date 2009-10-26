function R = v2R(v)
% V2R Rotation vector to rotation matrix conversion
%   V2R(V) computes the rotation matrix corresponding to the
%   rotation vector V. Uses rodrigues formula.

[a,u] = v2au(v); % u is always a column vector, regardless of the charactrer of v.

% intermediate results
ca  = cos(a);
sau = sin(a)*u;

% R = cos(a)*eye(3) + sin(a)*hat(u) + (1-cos(a))*u*u'; A shortcut is:
R = diag([ca;ca;ca]) + hat(sau) + ((1-ca)*u)*u';




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

