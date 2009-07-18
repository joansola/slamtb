function [R,Rq] = q2R(q)

% Q2R  Quaternion to rotation matrix conversion.
%   R = Q2R(Q) builds the rotation matrix corresponding to the unit
%   quaternion Q. The obtained matrix R is such that the product:
%
%        re = R * rb 
%
%   converts the body referenced vector  rb 
%      into the earth referenced vector  re
%
%   [R,Rq] = (...) returns the Jacobian wrt q.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[a,b,c,d] = split(q);

aa = a^2;
ab = 2*a*b;
ac = 2*a*c;
ad = 2*a*d;
bb = b^2;
bc = 2*b*c;
bd = 2*b*d;
cc = c^2;
cd = 2*c*d;
dd = d^2;

R  = [...
    aa+bb-cc-dd    bc-ad          bd+ac
    bc+ad          aa-bb+cc-dd    cd-ab
    bd-ac          cd+ab          aa-bb-cc+dd];

  
if nargout > 1
    
    [a2,b2,c2,d2] = deal(2*a,2*b,2*c,2*d);
    
    Rq = [...
        [  a2,  b2, -c2, -d2]
        [  d2,  c2,  b2,  a2]
        [ -c2,  d2, -a2,  b2]
        [ -d2,  c2,  b2, -a2]
        [  a2, -b2,  c2, -d2]
        [  b2,  a2,  d2,  c2]
        [  c2,  d2,  a2,  b2]
        [ -b2, -a2,  d2,  c2]
        [  a2, -b2, -c2,  d2]];
    
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

