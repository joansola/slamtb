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
        [               0,    -sp*cy,          -cp*sy]
        [               0,    -sp*sy,           cp*cy]
        [               0,       -cp,               0]
        [  sr*sy+cr*sp*cy,  sr*cp*cy, -cr*cy-sr*sp*sy]
        [ -sr*cy+cr*sp*sy,  sr*cp*sy, -cr*sy+sr*sp*cy]
        [           cr*cp,    -sr*sp,               0]
        [  cr*sy-sr*sp*cy,  cr*cp*cy,  sr*cy-cr*sp*sy]
        [ -cr*cy-sr*sp*sy,  cr*cp*sy,  sr*sy+cr*sp*cy]
        [          -sr*cp,    -cr*sp,               0]];

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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

