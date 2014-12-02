function [u,s,U_r,U_s,U_pk,U_pd,U_l]  = projAhmPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, l)

% PROJAHMPNTINTOPINHOLEONROB Project Ahm pnt into pinhole on robot.
%    [U,S] = PROJAHMPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    anchored homogeneous points into a pin-hole camera mounted on a robot,
%    providing also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D anchored homog. point [x y z vx vy vz rho]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts an ahm points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargout <= 2  % No Jacobians requested

    p     = ahm2euc(l);
    [u,s] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

else            % Jacobians requested

    if size(l,2) == 1
        
        % function calls
        [p,P_l]                     = ahm2euc(l);
        [u,s,U_r,U_s,U_pk,U_pd,U_p] = projEucPntIntoPinHoleOnRob(Rf, Sf, Spk, Spd, p);

        % chain rule
        U_l = U_p*P_l;

    else
        error('??? Jacobians not available for multiple AHM points.')

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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

