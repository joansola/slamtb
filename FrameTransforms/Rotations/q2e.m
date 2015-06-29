function [e,E_q] = q2e(q)

% Q2E  Quaternion to Euler angles conversion.
%   Q2E(Q) returns an Euler angles vector [roll;pitch;yaw] corresponding to
%   the orientation quaternion Q.
%
%   [E,Jq] = Q2E(Q) returns also the Jacobian matrix.
%
%   See also QUATERNION, EULERANGLES, R2Q, E2Q, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



a  = q(1);
b  = q(2);
c  = q(3);
d  = q(4);

y1 =  2*c*d + 2*a*b;
x1 =  a^2   - b^2   - c^2 + d^2;
z2 = -2*b*d + 2*a*c;
y3 =  2*b*c + 2*a*d;
x3 =  a^2   + b^2   - c^2 - d^2;

w  = whos('q');

if strcmp(w.class,'sym')
    
    e = [ atan(y1/x1)
          asin(z2)
          atan(y3/x3) ];
      
else
    
    e = [ atan2(y1,x1)
          asin(z2)
          atan2(y3,x3) ];
      
end

if nargout >1 
    
    dx1dq  = [ 2*a, -2*b, -2*c,  2*d];
    dy1dq  = [ 2*b,  2*a,  2*d,  2*c];
    dz2dq  = [ 2*c, -2*d,  2*a, -2*b];
    dx3dq  = [ 2*a,  2*b, -2*c, -2*d];
    dy3dq  = [ 2*d,  2*c,  2*b,  2*a];
    
    de1dx1 = -y1/(x1^2 + y1^2);
    de1dy1 =  x1/(x1^2 + y1^2);
    de2dz2 =   1/sqrt(1-z2^2);
    de3dx3 = -y3/(x3^2 + y3^2);
    de3dy3 =  x3/(x3^2 + y3^2);
    
    de1dq  = de1dx1*dx1dq + de1dy1*dy1dq;
    de2dq  = de2dz2*dz2dq;
    de3dq  = de3dx3*dx3dq + de3dy3*dy3dq;
    
    E_q    = [de1dq;de2dq;de3dq];
end

return

%% jac

syms a b c d real
q=[a;b;c;d];
[e,E_q] = q2e(q);
simplify(E_q-jacobian(e,q))



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

