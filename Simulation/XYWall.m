function w = XYWall(x1,x2,y1,y2,z,nx,ny)
% XYWALL  3D Wall in XY plane at z. X1,X2,Y1,Y2 defines the dimensions of
% the wall and NX, NY are the number of lines along x-axis and y-axis,
% respectively.

%   Copyright 2015 Ellon Paiva Mendes @ LAAS-CNRS.

switch nargin
    case {1, 2, 3, 4, 5}
        nx = 9;
        ny = 9;
    case {6}
        ny = 9;
end

xs = linspace(x1,x2,nx);
ys = linspace(y1,y2,ny);
zs = z*ones(1,length(xs) * length(ys));

xys = zeros(2,length(xs) * length(ys));
for i = 1:length(ys)
   xys(:,(i-1)*length(xs)+1:i*length(xs)) = [xs; ys(i)*ones(size(xs))];
end

w = [xys; zs];
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

