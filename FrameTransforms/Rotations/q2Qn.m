function Q = q2Qn(q)

% Q2QN  Quaternion to quaternion matrix conversion.
%   Q = Q2QN(q) gives the matrix Qn so that the quaternion product
%   q1 x q2 is equivalent to the matrix product:
%
%       q1 x q2 == q2Qn(q2) * q1
%
%   If q = [a b c d]' this matrix is
%
%       Q = [ a -b -c -d
%             b  a  d -c
%             c -d  a  b
%             d  c -b  a ];
%
%   See also QUATERNION, Q2Q, R2Q, Q2E, Q2V.

%   Copyright 2014 Joan Sola.


Q = [ q(1) -q(2) -q(3) -q(4)
      q(2)  q(1)  q(4) -q(3)
      q(3) -q(4)  q(1)  q(2)
      q(4)  q(3) -q(2)  q(1) ];
  



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

