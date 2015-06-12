function [u, s, U_p, U_k, U_d] = pinHole(p,k,d)

% PINHOLE Pin-hole camera model, with optional radial distortion.
%   U = PINHOLE(P) gives the projected pixel U of a point P in a canonical
%   pin-hole camera, that is, with calibration parameters
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
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
%   U = PINHOLE(P,K) allows the introduction of the camera's calibration
%   parameters:
%     K = [u0 v0 au av]'.
%
%   U = PINHOLE(P,K,D) allows the introduction of the camera's radial
%   distortion parameters:
%     D = [K2 K4 K6 ...]'
%   so that the new pixel is distorted following the distortion equation:
%     U_D = U * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U.^2), being U the projected point in the image plane
%   for a camera with unit focal length.
%
%   [U,S] = PINHOLE(...) returns the depth S from the camera center.
%
%   If P is a points matrix, PINHOLE(P,...) returns a pixel matrix U and a
%   depths row-vector S. P, U and S are defined as
%     P = [P1 ... Pn];   Pi = [xi;yi;zi]
%     U = [U1 ... Un];   Ui = [ui;vi]
%     S = [S1 ... Sn]
%
%   [U,S,U_p,U_k,U_d] returns the Jacobians of U wrt P, K and D. It only
%   works for single points P=[x;y;z].
%
%   See also PERSP_PROJECT, DISTORT, PIXELLISE, INVPINHOLE, PINHOLEIDP, INVDISTORTION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Point's depth
s = p(3,:);

if nargout <= 2 % only pixel

    switch nargin
        case 1
            u = persp_project(p);
        case 2
            u = pixellise(persp_project(p),k);
        case 3
            if ~isempty(d)
                u = pixellise(distort(persp_project(p),d),k);
            else
                u = pixellise(persp_project(p),k);
            end
    end


else % Jacobians

    if size(p,2) > 1
        error('Jacobians not available for multiple points')
    else

        switch nargin
            case 1
                [u, U_p] = persp_project(p);

            case 2
                [u1, U1_p]     = persp_project(p);
                [u, U_u1, U_k] = pixellise(u1,k);
                U_p            = U_u1*U1_p;

            case 3
                if ~isempty(d)
                    [u1, U1_p]        = persp_project(p);
                    [u2, U2_u1, U2_d] = distort(u1,d);
                    [u, U_u2, U_k]    = pixellise(u2,k);
                    U_d               = U_u2*U2_d;
                    U_p               = U_u2*U2_u1*U1_p;
                else
                    [u1, U1_p]     = persp_project(p);
                    [u, U_u1, U_k] = pixellise(u1,k);
                    U_p            = U_u1*U1_p;
                    U_d            = zeros(2,0);
                end

        end

    end

end

return

%% jacobians
syms x y z u0 v0 au av d2 d4 d6 real
p = [x;y;z];
k = [u0;v0;au;av];
d = [d2;d4;d6];

[u, s, U_p, U_k, U_d] = pinHole(p,k,d);

simplify(U_p - jacobian(u,p))
simplify(U_k - jacobian(u,k))
simplify(U_d - jacobian(u,d))



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

