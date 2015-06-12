function v = thickVehicle(size)

%THICKVEHICLE Create a vehicle graphics 3D object.
%
%   THICKVEHICLE creates a thick triangle representing a vehicle
%   This triangle is heading towards vehicle principal axis
%   and is located at vehicle position. Initial configuration
%   is: position at origin and principal axis aligned with
%   world x axis.
%   
%   THICKVEHICLE(SIZE) allows for choosing a vehicle size. 
%   Default is 0.5

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 0
    size = 1;
end

v.vert0 = [ 1.0  0.0 0.0
           -0.5  0.5 0.0
           -0.5 -0.5 0.0
            1.0  0.0 0.5
           -0.5  0.5 0.5
           -0.5 -0.5 0.5] * size/1.5;
       
v.vert = v.vert0;
v.faces = [1 2 3 1
           4 5 6 4
           1 2 5 4 
           1 3 6 4 
           2 3 6 5];      



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

