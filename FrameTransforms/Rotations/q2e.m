function [e,E_q] = q2e(q)

% Q2E  Quaternion to Euler angles conversion.
%   Q2E(Q) returns an Euler angles vector [roll;pitch;yaw] corresponding to
%   the orientation quaternion Q.
%
%   [E,Jq] = Q2E(Q) returns also the Jacobian matrix.
%
%   See also QUATERNION, EULERANGLES, R2Q, E2Q, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Revised 2018 Joan Sola - handle full gimbal range (2pi, pi, 2pi)



a  = q(1); % a: real part
b  = q(2);
c  = q(3);
d  = q(4);

r32 =  2*c*d + 2*a*b;
r33 =  a^2   - b^2   - c^2 + d^2;
r31 =  2*b*d - 2*a*c;
r21 =  2*b*c + 2*a*d;
r11 =  a^2   + b^2   - c^2 - d^2;

n   = sqrt(r11^2+r21^2);

e   = [ atan2( r32,r33)
        atan2(-r31, n)
        atan2( r21,r11) ];
    
if nargout >1 
    
    % partials of R wrt q
    dr11dq  = [  2*a,  2*b, -2*c, -2*d];
    dr21dq  = [  2*d,  2*c,  2*b,  2*a];
    dr31dq  = [ -2*c,  2*d, -2*a,  2*b];
    dr32dq  = [  2*b,  2*a,  2*d,  2*c];
    dr33dq  = [  2*a, -2*b, -2*c,  2*d];
    
    % partials of n wrt R elements
    dndr11 = r11/n;
    dndr21 = r21/n;
    
    % partials of e wrt n
    de2dn   = r31/(n^2 + r31^2);
    
    % partials of e wrt R elements
    de1dr32 =  r33/(r33^2 + r32^2);
    de1dr33 = -r32/(r33^2 + r32^2);
    de2dr31 = -n /(n^2 + r31^2);
    de3dr11 = -r21/(r11^2 + r21^2);
    de3dr21 =  r11/(r11^2 + r21^2);
    
    % chain rule: rows of Jacobian
    de1dq  = de1dr33*dr33dq + de1dr32*dr32dq;
    de2dq  = de2dr31*dr31dq + de2dn*(dndr11*dr11dq+dndr21*dr21dq);
    de3dq  = de3dr11*dr11dq + de3dr21*dr21dq;
    
    % assemble Jacobian
    E_q    = [de1dq;de2dq;de3dq];
end

return

%% jac

syms a b c d real
q=[a;b;c;d];
[e,E_q] = q2e(q);
simplify(E_q-jacobian(e,q))

%% test
for i = 1 : 1000
    e = [2/3;1/3;2/3] .* randn(3,1);
    eo = q2e(e2q(e));
    if any(e-eo > 1e-10) % Should never enter this IF
        e
        eo
        disp('###########')
    end
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

