% EULERANGLES  Help on Euler angles for the Rotations/ toolbox.
%
%   We specify the Euler angles as a column 3-vector
%
%       e = [roll pitch yaw]',
%
%   where the 3D space is considered right-handed, and
%       roll   is a positive rotation around the X-axis, 
%       pitch  is a positive rotation around the Y-axis, and 
%       yaw    is a positive rotation around the Z-axis. 
%   
%   The orientation of a 3D solid with respect to the cartesian axes XYZ is
%   given by the following ordered sequence of three elementary rotations:
%
%       1. rotation around the Z-axis - the yaw angle;
%       2. rotation around the rotated Y-axis - the pitch angle;
%       3. rotation around the doubly rotated X-axis - the roll angle.
%
%   The three Euler angles are limited by gimbal lock. It is up to the user
%   to ensure that the following conditions are met before calling any
%   function with Euler angles:
%
%       -pi   <= roll  < pi
%       -pi/2 <= pitch < pi/2
%       -pi   <= yaw   < pi , or 0 <= yaw < 2pi
%
%   Interesting functions involving Euler angles are:
%
%       e2q, q2e        conversion to and from quaternion.
%       e2R, R2e        conversion to and from rotation matrix.
%       epose2qpose     Euler-based frame to quaternion-based frame.
%       qpose2epose     the inverse of the above.
%
%   See also E2Q, Q2E, E2R, R2E, EPOSE2QPOSE, QPOSE2EPOSE, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



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

