function f = cloister(xmin,xmax,ymin,ymax,n)

% CLOISTER  Generates features in a 2D cloister shape.
%   CLOISTER(XMIN,XMAX,YMIN,YMAX,N) generates a 2D cloister in the limits
%   indicated as parameters. 
%
%   N is the number of rows and columns; it defaults to N = 9.
%
%   See also THICKCLOISTER.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 5
    n = 9;
end

% Center of cloister
x0 = (xmin+xmax)/2;
y0 = (ymin+ymax)/2;

% Size of cloister
hsize = xmax-xmin;
vsize = ymax-ymin;
tsize = diag([hsize vsize]);

% Integer ordinates of points
outer = (-(n-3)/2 : (n-3)/2);
inner = (-(n-3)/2 : (n-5)/2);

% Outer north coordinates
No = [outer; (n-1)/2*ones(1,numel(outer))];
% Inner north
Ni = [inner ; (n-3)/2*ones(1,numel(inner))];
% East (rotate 90 degrees the North points)
E = [0 -1;1 0] * [No Ni];
% South and West are negatives of N and E respectively.
points = [No Ni E -No -Ni -E];

% Rescale
f = tsize*points/(n-1);

% Move
f(1,:) = f(1,:) + x0;
f(2,:) = f(2,:) + y0;



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

