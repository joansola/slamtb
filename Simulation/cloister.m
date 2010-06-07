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

x0 = (xmin+xmax)/2;
y0 = (ymin+ymax)/2;

hsize = xmax-xmin;
vsize = ymax-ymin;
tsize = diag([hsize vsize]);

midle  = (n-5)/2;
int    = (n-3)/2;
ext    = (n-1)/2;
cmidle = [-midle:midle];
cint   = [cmidle int];
cext   = [-int cint];
zint   = zeros(1,n-3);
zext   = zeros(1,n-2);

northint = [cint;zint+int];
northext = [cext;zext+ext];

southint = [-cint;zint-int];
southext = [-cext;zext-ext];

eastint  = [zint+int;-cint];
eastext  = [zext+ext;-cext];

westint  = [zint-int;cint];
westext  = [zext-ext;cext];


f = [northint northext southint southext eastint eastext westint westext];

f = tsize*f/(n-1);

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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

