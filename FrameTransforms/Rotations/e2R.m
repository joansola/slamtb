function [R,Re] = e2R(e)

% E2R Euler angles to rotation matrix.
%   E2R(E) gives the rotation matrix body-to-world corresponding to the
%   body orientation given by the Euler angles vector E = [roll; pitch;
%   yaw]. The result is such that E2R(R2E(R)) = R and R2E(E2R(E)) = E.
%
%   [R,R_e] = E2R(E) returns the Jacobian wrt E.
%
%   See also R2E, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


r  = e(1); %roll
p  = e(2); %pitch
y  = e(3); %yaw

sr = sin(r);
cr = cos(r);
sp = sin(p);
cp = cos(p);
sy = sin(y);
cy = cos(y);

R= [cp*cy -cr*sy+sr*sp*cy  sr*sy+cr*sp*cy
    cp*sy  cr*cy+sr*sp*sy -sr*cy+cr*sp*sy
    -sp          sr*cp           cr*cp   ];


if nargout > 1

    Re = [...
        [                                   0,                      -sin(p)*cos(y),                      -cos(p)*sin(y)]
        [                                   0,                      -sin(p)*sin(y),                       cos(p)*cos(y)]
        [                                   0,                             -cos(p),                                   0]
        [  sin(r)*sin(y)+cos(r)*sin(p)*cos(y),                sin(r)*cos(p)*cos(y), -cos(r)*cos(y)-sin(r)*sin(p)*sin(y)]
        [ -sin(r)*cos(y)+cos(r)*sin(p)*sin(y),                sin(r)*cos(p)*sin(y), -cos(r)*sin(y)+sin(r)*sin(p)*cos(y)]
        [                       cos(r)*cos(p),                      -sin(r)*sin(p),                                   0]
        [  cos(r)*sin(y)-sin(r)*sin(p)*cos(y),                cos(r)*cos(p)*cos(y),  sin(r)*cos(y)-cos(r)*sin(p)*sin(y)]
        [ -cos(r)*cos(y)-sin(r)*sin(p)*sin(y),                cos(r)*cos(p)*sin(y),  sin(r)*sin(y)+cos(r)*sin(p)*cos(y)]
        [                      -sin(r)*cos(p),                      -cos(r)*sin(p),                                   0]];

end

return

%%

syms r p y real

e = [r;p;y];

R = e2R(e);

Re = simplify(jacobian(R,e))


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

