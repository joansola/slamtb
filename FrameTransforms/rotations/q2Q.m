function Q = q2Q(q)

% Q2Q  Quaternion to quaternion matrix conversion.
%   Q = Q2Q(q) gives the matrix Q so that the quaternion product
%   q1 x q2 is equivalent to the matrix product:
%
%       q1 x q2 == q2Q(q1) * q2
%
%   If q = [a b c d]' this matrix is
%
%       Q = [ a -b -c -d
%             b  a -d  c
%             c  d  a -b
%             d -c  b  a ];
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


Q = [ q(1) -q(2) -q(3) -q(4)
      q(2)  q(1) -q(4)  q(3)
      q(3)  q(4)  q(1) -q(2)
      q(4) -q(3)  q(2)  q(1) ];
  


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

