function [idp, IDP_rf, IDP_sf, IDP_sk, IDP_sd, IDP_u, IDP_invdepth] = ...
    retroProjectIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, u, n)

% RETROPROJECTIDPPNTFROMPINHOLEONROB Retro-pr idp from pinhole on rob.
%
%   IDP = RETROPROJECTIDPPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives
%   the retroprojected IDP in World Frame from an observed pixel U. RF and
%   SF are Robot and Sensor Frames, SK and SD are camera calibration and
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


