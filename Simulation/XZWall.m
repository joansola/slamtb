function w = XZWall(x1,x2,z1,z2,y,nx,nz)
% XZWALL  3D Wall in XZ plane at y. X1,X2,Z1,Z2 defines the dimensions of
% the wall and NX, NZ are the number of lines along x-axis and z-axis,
% respectively.

%   Copyright 2015 Ellon Paiva Mendes @ LAAS-CNRS.

switch nargin
    case {1, 2, 3, 4, 5}
        nx = 9;
        nz = 9;
    case {6}
        nz = 9;
end

xs = linspace(x1,x2,nx);
zs = linspace(z1,z2,nz);
ys = y*ones(1,length(xs) * length(zs));

xzs = zeros(2,length(xs) * length(zs));
for i = 1:length(zs)
   xzs(:,(i-1)*length(xs)+1:i*length(xs)) = [xs; zs(i)*ones(size(xs))];
end

w = [xzs(1,:); ys; xzs(2,:)];
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

