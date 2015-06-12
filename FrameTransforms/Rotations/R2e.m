function e = R2e(R)

% R2E  Rotation matrix to Euler angles conversion.
%   R2E(R) returns the euler angles vector [roll;pitch;yaw] corresponding
%   to the orientation of the rotation matrix R. The result is such that
%   E2R(R2E(R)) = R and R2E(E2R(E)) = E.
%
%   See also E2R, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



s = whos('R');

if (strcmp(s.class,'sym'))
    roll  = atan(R(3,2)/R(3,3));
    pitch = asin(-R(3,1));
    yaw   = atan(R(2,1)/R(1,1));
else
    roll  = atan2(R(3,2),R(3,3));
    pitch = asin(-R(3,1));
    yaw   = atan2(R(2,1),R(1,1));
end

e = [roll;pitch;yaw];



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

