function [p0,P0_l] = pluckerOrigin(L)

% PLUCKERORIGIN  Plucker line origin.
%   PLUCKERORIGIN(L) returns the closest point of the Plucker line L to the
%   origin of coordinates. This point is considered the origin for the
%   line's own 1D reference frame.
%
%   [p,P_l] = PLUCKERORIGIN(...) returns the Jacobian wrt the line L.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

n = L(1:3);
v = L(4:6);

if nargout == 1

    f = cross(v,n);
    g = dot(v,v);

    p0 = f/g;

else % Jac
    % numerator
    [f,F_v,F_n] = crossJ(v,n);
    % denominator
    g    = dot(v,v);
    G_v  = 2*v';

    % 3D point
    p0   = f/g;
    P0_f = 1/g;  % = eye(3)/g
    P0_g = -f/g^2;

    % Jacobians wrt n and v
    P0_n = P0_f*F_n;
    P0_v = P0_f*F_v + P0_g*G_v;

    % full Jacobian
    P0_l = [P0_n P0_v];
end

return

%%

syms nx ny nz vx vy vz real
L = [nx;ny;nz;vx;vy;vz];
[p0,P0_l] = pluckerOrigin(L);

simplify(P0_l - jacobian(p0,L))



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

