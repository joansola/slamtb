function [i,I_u,I_s,I_k,I_c] = invPinHoleIdp(u,s,k,c)

% INVPINHOLEIDP Inverse pin-hole camera model for IDP, with radial distortion correction.
%   I = INVPINHOLEIDP(U,S) gives the retroprojected IDP I of a pixel U at
%   depth S (S is actually the inverse depth), from a canonical pin-hole
%   camera, that is, with calibration parameters
%     u0 = 0 v0 = 0 au = 1 av = 1
%   It uses reference frames {RDF,RD} (right-down-front for the 3D world
%   points and right-down for the pixel), according to this scheme:
%
%         / z (forward)
%        /
%       +------- x                 +------- u
%       |                          |
%       |      3D : P=[x;y;z]      |     image : U=[u;v]
%       | y                        | v
%
%   I = INVPINHOLEIDP(U,S,K) allows the introduction of the camera's
%   calibration parameters:
%     K = [u0 v0 au av]'
%
%   I = INVPINHOLEIDP(U,S,K,C) allows the introduction of the camera's radial
%   distortion correction parameters:
%     C = [c2 c4 c6 ...]'
%   so that the new pixel is corrected following the distortion equation:
%     U = U_D * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U_D.^2), being U_D the distorted pixel in the image
%   plane for a camera with unit focal length.
%
%   If U is a pixels matrix, INVPINHOLEIDP(U,...) returns a IDPS matrix I,
%   with these matrices defined as
%     U = [U1 ... Un];   Ui = [ui;vi]
%     I = [I1 ... In];   Ii = [Xi;Yi;Zi,pi,yi,ri]
%   where pi, yi are pitch and yaw angles of the IDP ray, and ri is the
%   inverse of the distance (wrongly named "inverse depth")
%
%   [I,I_u,I_s,I_k,I_c] returns the Jacobians of I wrt U, S, K and C. It
%   only works for single pixels U=[u;v], and for distortion correction
%   vectors C of up to 3 parameters C=[c2;c4;c6]. See UNDISTORT for
%   information on longer distortion vectors.
%
%   See also RETRO, UNDISTORT, DEPIXELLISE, PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargout == 1 % only point

    switch nargin
        case 2
            v = retro(u,1);
        case 3
            v = retro(depixellise(u,k),1);
        case 4
            v = retro(undistort(depixellise(u,k),c),1);
    end
    py = vec2py(v);
    i  = [0;0;0;py;s];

else % Jacobians

    if size(u,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        switch nargin
            case 2
                [v, V_u]  = invPinHole(u,1);
                [py,PY_v] = vec2py(v);
                i    = [0;0;0;py;s];
                I_py = [zeros(3,2);eye(2);zeros(1,2)];
                I_s  = [0;0;0;0;0;1];
                I_v  = I_py*PY_v;
                I_u  = I_v*V_u;

            case 3
                [v, V_u, V_1, V_k] = invPinHole(u,1,k);
                [py,PY_v] = vec2py(v);
                i    = [0;0;0;py;s];
                I_py = [zeros(3,2);eye(2);zeros(1,2)];
                I_s  = [0;0;0;0;0;1];
                I_v  = I_py*PY_v;
                I_u  = I_v*V_u;
                I_k  = I_v*V_k;

            case 4
                [v, V_u, V_1, V_k, V_c] = invPinHole(u,1,k,c);
                [py,PY_v] = vec2py(v);
                i    = [0;0;0;py;s];
                I_py = [zeros(3,2);eye(2);zeros(1,2)];
                I_s  = [0;0;0;0;0;1];
                I_v  = I_py*PY_v;
                I_u  = I_v*V_u;
                I_k  = I_v*V_k;
                I_c  = I_v*V_c;

        end
    end

end

return

%% jac
syms u v s u0 v0 au av c2 c4 c6 real
U=[u;v];
k=[u0;v0;au;av];
c=[c2;c4;c6];

% [i,I_u,I_s] = invPinHoleIdp(U,s);
[i,I_u,I_s,I_k] = invPinHoleIdp(U,s,k);
% [i,I_u,I_s,I_k,I_c] = invPinHoleIdp(U,s,k,c);

simplify(I_u - jacobian(i,U))
simplify(I_s - jacobian(i,s))
simplify(I_k - jacobian(i,k))
simplify(I_c - jacobian(i,c))



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

