function [q,Qa,Qu] = au2q(a,u)
%AU2Q Rotated angle and rotation axis vector to quaternion.
%   Q = AU2Q(A,U) gives the quaternion representing a rotation
%   of A rad around the axis defined by the unit vector U.
%
%   [Q,Qa,Qu] = AU2Q(...) returns the Jacobians wrt A and U.

q = [  cos(a/2)
    u*sin(a/2)];

if nargout > 1

    Qa = [-sin(a/2)/2
        u*cos(a/2)/2];

    Qu = [0 0 0;eye(3)*sin(a/2)];

end


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

