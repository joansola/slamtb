function v = wing(size)

%WING Create a wing graphics 3D object.
%   WING creates a multi-patch object representing a plane, sort of a
%   hang-glider wing.
%   
%   WING(SIZE) allows for choosing the wing's size. Default is 1.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 0
    size = 1;
end

v.vert0 = [ 0.6  0.0 0.0
           -0.6  1.0 0.0
           -0.4  0.0 0.0
           -0.6 -1.0 0.0
           -0.4  0.0 0.3
            0.0  0.0 0.0] * size/2;
       
v.vert = v.vert0;
v.faces = [1 2 3 4
           3 5 6 3];      



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

