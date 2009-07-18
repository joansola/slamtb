function [idp, IDP_rf, IDP_sf, IDP_sk, IDP_sd, IDP_u, IDP_invdepth] = ...
    retroProjIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, u, n)

% RETROPROJIDPPNTFROMPINHOLEONROB Retro-project idp from pinhole on robot.
%
%   IDP = RETROPROJIDPPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected IDP in World Frame from an observed pixel U. RF and SF
%   are Robot and Sensor Frames, SK and SD are camera calibration and
%   distortion correction parameters. U is the pixel coordinate and N is
%   the non-observable inverse depth. IDP is a 6-vector :
%     IDP = [X Y Z Pitch Yaw IDepth]'
%
%   [IDP, IDP_rf, IDP_sf, IDP_k, IDP_c, IDP_u, IDP_n] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also INVPINHOLEIDP, FROMFRAMEIDP.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if(isempty(Sd))
    % IDP in Sensor Frame
    [idps, IDPS_u, IDPS_invdepth, IDPS_sk] = invPinHoleIdp(u,n,Sk) ;
else
    % IDP in Sensor Frame
    [idps, IDPS_u, IDPS_invdepth, IDPS_sk, IDPS_sd] = invPinHoleIdp(u,n,Sk,Sd) ;
end

[idp, IDP_idps, IDP_rf, IDP_sf] = idpS2idpW(idps, Rf, Sf) ;

IDP_sk = IDP_idps*IDPS_sk ;

if(isempty(Sd))
    IDP_sd = [] ;
else
    IDP_sd = IDP_idps*IDPS_sd ;
end 

IDP_u = IDP_idps*IDPS_u ;
IDP_invdepth = IDP_idps*IDPS_invdepth ;

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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

