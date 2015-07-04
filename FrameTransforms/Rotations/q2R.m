function [R,Rq] = q2R(q)

% Q2R  Quaternion to rotation matrix conversion.
%   R = Q2R(Q) builds the rotation matrix corresponding to the unit
%   quaternion Q. The obtained matrix R is such that the product:
%
%        rg = R * rb 
%
%   converts the body referenced vector  rb 
%     into the global referenced vector  rg
%
%   [R,Rq] = (...) returns the Jacobian wrt q.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

aa = q(1)^2;
ab = 2*q(1)*q(2);
ac = 2*q(1)*q(3);
ad = 2*q(1)*q(4);
bb = q(2)^2;
bc = 2*q(2)*q(3);
bd = 2*q(2)*q(4);
cc = q(3)^2;
cd = 2*q(3)*q(4);
dd = q(4)^2;

R  = [...
    aa+bb-cc-dd    bc-ad          bd+ac
    bc+ad          aa-bb+cc-dd    cd-ab
    bd-ac          cd+ab          aa-bb-cc+dd];

  
if nargout > 1
    
    [a2,b2,c2,d2] = deal(2*q(1),2*q(2),2*q(3),2*q(4));
    
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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

