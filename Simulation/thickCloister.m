function world = thickCloister(x,X,y,Y,h,n)

% THICKCLOISTER  Generates features in a 3D cloister shape.
%   THICKCLOISTER(XMIN,XMAX,YMIN,YMAX,H,N) generates a 3D cloister in the
%   limits indicated as parameters, with height H and with N points per
%   side.
%
%   See also CLOISTER.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch nargin
    case {1, 2, 3, 4}
        n = 9;
        h = 1;
    case 5
        n = 9;
end

plane = cloister(x,X,y,Y,n);
nlm = length(plane);
low = zeros(1,nlm);
high  = low + h;
world = [plane plane;low high];

% nid = 2*nlm;

% ids = 1:nid;

% id = 0;
% ids = zeros(1,nid);
% for i = 1:nid
%     id = id+floor(10*rand+1);
%     ids(i) = id;
% end

% world = [ids;world];



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

