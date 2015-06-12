function [py,PYv] = vec2py(v)

% VEC2PY  3D vector to pitch and yaw direction
%   [PY] = VEC2PY(V) returns a vector PY with the pitch and yaw angles of
%   the directed vector V wrt the frame where V is defined.
%
%   [PY,PYv] = VEC2PY(...) returns also the Jacobian wrt V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[x,y,z] = split(v);

xy2  = x^2 + y^2;
xyz2 = xy2 + z^2;

rxy = sqrt(xy2);

w   = whos('x');
if strcmp(w.class,'sym')
    % symbolic
    pitch = atan(z/rxy);
    yaw   = atan(y/x);
else
    % numeric
    pitch = atan2(z,rxy);
    yaw   = atan2(y,x);
end

py = [pitch;yaw];

if nargout == 2 % we want the Jacobian

    PYv = [...
        [ -z/rxy*x/xyz2, -z/rxy*y/xyz2,  rxy/xyz2]
        [        -y/xy2,         x/xy2,         0]];

end

return

%% Symbolic part for the Jacobian (uncomment symbolic lines above)

syms x y z real

v = [x;y;z];

py = vec2py(v);

PYv = simple(jacobian(py,v))

[py2,PYv2] = vec2py(v)

EPYv = simple(PYv-PYv2)



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

