function [ahm, AHM_u, AHM_s, AHM_k, AHM_c] = invOmniCamAhm(u,s,k,c)
%
%   INVOMNICAMAHM Retro-project anchored homogeneous point AHP.
%   AHM = INVOMNICAMAHM(U,S) gives the retroprojected anchored homogeneous
%   point (AHM) of a pixel U at depth S (S is actually the inverse
%   depth), from a omnidirectional camera, that is, with calibration
%   parameters
%   k   -> [xc yc c d e]    - "calibration" - affine transformation 
%   pol -> [a0 a1 a2 a3 a4] - "distortion" polynom
% 
%   If U is a pixels matrix, INVOMNICAMAHM(U,...) returns a AHMS matrix AHM,
%   with these matrices defined as
%     U = [U1 ... Un];   Ui = [ui;vi]
%     AHM = [AHM1 ... AHMn];   AHMi = [Xi;Yi;Zi,pi,yi,ri]
%   where pi, yi are pitch and yaw angles of the AHM ray, and ri is the
%   inverse of the distance (wrongly named "inverse depth")
%
%   [AHM,AHM_u,AHM_s,AHM_k,AHM_c] = INVOMNICAMAHM(...) returns the
%   Jacobians of AHM wrt U, S, K and C. It only works for single pixels
%   U=[u;v], and for distortion correction of "ocam 4th order polynom"
%
%   See also RETRO, UNDISTORT, DEPIXELLISE, PINHOLE.
%
%   Author: Grigory Abuladze - email: ryhor.a@google.com
%
% Note: in current form it won't work with multiple points due to normvec

%   Copyright 2012 Grigory Abuladze @ ASL-vision
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


  if nargout == 1 % only point
    v    = invOmniCam(u,k,c);
    n    = normvec(v);
    %n    = normc(v);   % in NN toolbox or in OmniCam calibration toolbox
    ahm  = [0;0;0;n;s]; %... it won't compose multiple ahm points

  else % Jacobians

    if size(u,2) > 1
        error('Jacobians not available for multiple pixels'); % will stop function
    end

    [v, V_u, V_k, V_c] = invOmniCam(u,k,c);
    [n,N_v]  = normvec(v,1);
    ahm      = [0;0;0;n;s];
    AHM_v    = [zeros(3,3);N_v;zeros(1,3)];
    AHM_s    = [0;0;0;0;0;0;1];
    AHM_u    = AHM_v*V_u;
    AHM_k    = AHM_v*V_k;
    AHM_c    = AHM_v*V_c;

  end

return

%% jacobians
syms a0 a1 a2 a3 a4 real
syms xc yc c d e real
syms u1 u2 s real

u  = [u1 u2]';
k  = [xc yc c d e];
c  = [a0 a1 a2 a3 a4]';

[ahm,AHM_u,AHM_s,AHM_k,AHM_c] = invOmniCamAhm(u,s,k,c);

simplify(AHM_u - jacobian(ahm,U))
simplify(AHM_s - jacobian(ahm,s))
simplify(AHM_k - jacobian(ahm,k))
simplify(AHM_c - jacobian(ahm,c))



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

