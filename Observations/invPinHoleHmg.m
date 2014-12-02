function [hmg, HMG_u, HMG_s, HMG_k, HMG_c] = invPinHoleHmg(u,s,k,c)

% INVPINHOLEHMG Retro-project anchored homogeneous point AHP.
%   HMG = INVPINHOLEHMG(U,S) gives the retroprojected anchored homogeneous
%   point (HMG) of a pixel U at inverse-depth S, from a canonical pin-hole
%   camera, that is, with calibration parameters
%     u0 = 0, v0 = 0, au = 1, av = 1
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
%   HMG = INVPINHOLEHMG(U,S,K) allows the introduction of the camera's
%   calibration parameters:
%     K = [u0 v0 au av]'
%
%   HMG = INVPINHOLEHMG(U,S,K,C) allows the introduction of the camera's radial
%   distortion correction parameters:
%     C = [c2 c4 c6 ...]'
%   so that the new pixel is corrected following the distortion equation:
%     U = U_D * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U_D.^2), being U_D the distorted pixel in the image
%   plane for a camera with unit focal length.
%
%   If U is a pixels matrix, INVPINHOLEHMG(U,...) returns a HMGS matrix HMG,
%   with these matrices defined as
%     U   = [U1 ... Un];       Ui   = [ui;vi]
%     HMG = [HMG1 ... HMGn];   HMGi = [xi,yi,zi,ri]
%   where xi, yi, zi are the non-homogeneous parts of HMG, defining the
%   optical ray, and ri is the inverse of the distance (wrongly named
%   "inverse depth")
%
%   [HMG,HMG_u,HMG_s,HMG_k,HMG_c] returns the Jacobians of HMG wrt U, S, K and C. It
%   only works for single pixels U=[u;v], and for distortion correction
%   vectors C of up to 3 parameters C=[c2;c4;c6]. See UNDISTORT for
%   information on longer distortion vectors.
%
%   See also RETRO, UNDISTORT, DEPIXELLISE, PINHOLEHMG.

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
    hmg  = [n;s];

else % Jacobians

    if size(u,2) > 1
        error('Jacobians not available for multiple pixels')
    else

        switch nargin
            case 2
                [v, V_u] = invPinHole(u,1);
                [n,N_v]  = normvec(v,1);
                hmg      = [n;s];
                HMG_v    = [N_v;zeros(1,3)];
                HMG_s    = [0;0;0;1];
                HMG_u    = HMG_v*V_u;

            case 3
                [v, V_u, V_1, V_k] = invPinHole(u,1,k);
                [n,N_v]  = normvec(v,1);
                hmg      = [n;s];
                HMG_v    = [N_v;zeros(1,3)];
                HMG_s    = [0;0;0;1];
                HMG_u    = HMG_v*V_u;
                HMG_k    = HMG_v*V_k;

            case 4
                [v, V_u, V_1, V_k, V_c] = invPinHole(u,1,k,c);
                [n,N_v]  = normvec(v,1);
                hmg      = [n;s];
                HMG_v    = [N_v;zeros(1,3)];
                HMG_s    = [0;0;0;1];
                HMG_u    = HMG_v*V_u;
                HMG_k    = HMG_v*V_k;
                HMG_c    = HMG_v*V_c;

        end
    end

end

return

%% jacobians
syms u v s u0 v0 au av c2 c4 c6 real
U=[u;v];
k=[u0;v0;au;av];
c=[c2;c4;c6];

% [hmg,HMG_u,HMG_s] = invPinHoleHmg(U,s);
% [hmg,HMG_u,HMG_s,HMG_k] = invPinHoleHmg(U,s,k);
[hmg,HMG_u,HMG_s,HMG_k,HMG_c] = invPinHoleHmg(U,s,k,c);

simplify(HMG_u - jacobian(hmg,U))
simplify(HMG_s - jacobian(hmg,s))
simplify(HMG_k - jacobian(hmg,k))
% simplify(HMG_c - jacobian(hmg,c))



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

