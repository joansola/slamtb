function [ahm, AHM_u, AHM_s, AHM_k, AHM_c] = invPinHoleAhm(u,s,k,c)

% INVPINHOLEAHM Retro-project anchored homogeneous point AHP.
%   AHM = INVPINHOLEAHM(U,S) gives the retroprojected anchored homogeneous
%   point (AHM) of a pixel U at depth S (S is actually the inverse
%   depth), from a canonical pin-hole camera, that is, with calibration
%   parameters
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
%   AHM = INVPINHOLEAHM(U,S,K) allows the introduction of the camera's
%   calibration parameters:
%     K = [u0 v0 au av]'
%
%   AHM = INVPINHOLEAHM(U,S,K,C) allows the introduction of the camera's radial
%   distortion correction parameters:
%     C = [c2 c4 c6 ...]'
%   so that the new pixel is corrected following the distortion equation:
%     U = U_D * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U_D.^2), being U_D the distorted pixel in the image
%   plane for a camera with unit focal length.
%
%   If U is a pixels matrix, INVPINHOLEAHM(U,...) returns a AHMS matrix AHM,
%   with these matrices defined as
%     U = [U1 ... Un];   Ui = [ui;vi]
%     AHM = [AHM1 ... AHMn];   AHMi = [Xi;Yi;Zi,pi,yi,ri]
%   where pi, yi are pitch and yaw angles of the AHM ray, and ri is the
%   inverse of the distance (wrongly named "inverse depth")
%
%   [AHM,AHM_u,AHM_s,AHM_k,AHM_c] returns the Jacobians of AHM wrt U, S, K and C. It
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
    n = normvec(v);
    ahm  = [0;0;0;n;s];

else % Jacobians

    if size(u,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        switch nargin
            case 2
                [v, V_u] = invPinHole(u,1);
                [n,N_v]  = normvec(v,1);
                ahm      = [0;0;0;n;s];
                AHM_v    = [zeros(3,3);N_v;zeros(1,3)];
                AHM_s    = [0;0;0;0;0;0;1];
                AHM_u    = AHM_v*V_u;

            case 3
                [v, V_u, V_1, V_k] = invPinHole(u,1,k);
                [n,N_v]  = normvec(v,1);
                ahm      = [0;0;0;n;s];
                AHM_v    = [zeros(3,3);N_v;zeros(1,3)];
                AHM_s    = [0;0;0;0;0;0;1];
                AHM_u    = AHM_v*V_u;
                AHM_k    = AHM_v*V_k;

            case 4
                [v, V_u, V_1, V_k, V_c] = invPinHole(u,1,k,c);
                [n,N_v]  = normvec(v,1);
                ahm      = [0;0;0;n;s];
                AHM_v    = [zeros(3,3);N_v;zeros(1,3)];
                AHM_s    = [0;0;0;0;0;0;1];
                AHM_u    = AHM_v*V_u;
                AHM_k    = AHM_v*V_k;
                AHM_c    = AHM_v*V_c;

        end
    end

end

return

%% jacobians
syms u v s u0 v0 au av c2 c4 c6 real
U=[u;v];
k=[u0;v0;au;av];
c=[c2;c4;c6];

% [ahm,AHM_u,AHM_s] = invPinHoleAhm(U,s);
[ahm,AHM_u,AHM_s,AHM_k] = invPinHoleAhm(U,s,k);
% [ahm,AHM_u,AHM_s,AHM_k,AHM_c] = invPinHoleAhm(U,s,k,c);

simplify(AHM_u - jacobian(ahm,U))
simplify(AHM_s - jacobian(ahm,s))
simplify(AHM_k - jacobian(ahm,k))
% simplify(AHM_c - jacobian(ahm,c))



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

