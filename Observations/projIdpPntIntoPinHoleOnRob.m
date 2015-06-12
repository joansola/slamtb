function [u,s,U_rf,U_sf,U_k,U_d,U_idp]  = projIdpPntIntoPinHoleOnRob(Rf, Sf, k, d, idp)

% PROJIDPPNTINTOPINHOLEONROB Project Idp pnt into pinhole on robot.
%    [U,S] = PROJIDPPNTINTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Inverse Depth points into a pin-hole camera mounted on a robot,
%    providing also the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SPD: radial distortion parameters [K2 K4 K6 ...]'
%       L  : 3D inverse depth point [x y z pitch yaw rho]'
%    The output parameters are:
%       U  : 2D pixel [u v]'
%       S  : non-measurable depth
%
%    The function accepts an idp points matrix L = [L1 ... Ln] as input.
%    In this case, it returns a pixels matrix U = [U1 ... Un] and a depths
%    row-vector S = [S1 ... Sn].
%
%    [U,S,U_R,U_S,U_K,U_D,U_L] = ... gives also the jacobians of the
%    observation U wrt all input parameters. Note that this only works for
%    single points.
%
%    See also PINHOLE, TOFRAME, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Rf = updateFrame(Rf);
% Sf = updateFrame(Sf);

if nargout <= 2  % No Jacobians requested

    idpr  = toFrameIdp(Rf,idp);
    [u,s] = projIdpPntIntoPinHole(Sf, k, d, idpr);

else            % Jacobians requested

    if size(idp,2) == 1
        
        % function calls
        [idpr, IDPR_r, IDPR_idp]      = toFrameIdp(Rf,idp);
        [u,s, U_sf, U_k, U_d, U_idpr] = projIdpPntIntoPinHole(Sf, k, d, idpr);

        % chain rule
        U_rf  = U_idpr*IDPR_r;
        U_idp = U_idpr*IDPR_idp;

    else
        error('??? Jacobians not available for multiple IDP points.')

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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

