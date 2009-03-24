

function [idp, IDP_rf, IDP_sf, IDP_sk, IDP_sd, IDP_pix, IDP_invdepth] = ...
    retroProjectIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, pix, inv_depth)


% RETROPROJECTIDPPNTFROMPINHOLEONROB De-Project idp point from Pin-hole
% camera mounted on robot.
%   IDP = RETROPROJECTIDPPNTFROMPINHOLEONROB(RF, SF, SK, SD, PIX,
%   INV_DEPTH) gives the retroprojected IDP in World Frame from an observed
%   pixel PIX. RF and SF are Robot and Sensor Frames, SK and SD are camera
%   calibration and distortion parameters. POINT is the pixel coordinate
%   and INV_DEPTH is the non-observable part of the measuerment.
%
%   IDP is a 6 variables vector :
%     IDP = [X Y Z Pitch Yaw IDepth]'
%
%   [IDP, IDP_rf, IDP_sf, IDP_k, IDP_d, IDP_pix, IDP_invdepth] = ...
%   return the idp retro-projected wrt parameters.
%
%   See also INVPINHOLEIDP, FROMFRAMEIDP, COMPOSEFRAMES.



% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if(isempty(Sd))
    % IDP in Sensor Frame
    [idp_S, IDPS_pix, IDPS_invdepth, IDPS_sk] = invPinHoleIdp(pix,inv_depth,Sk) ;
else
    % IDP in Sensor Frame
    [idp_S, IDPS_pix, IDPS_invdepth, IDPS_sk, IDPS_sd] = invPinHoleIdp(pix,inv_depth,Sk,Sd) ;
end 

[idp, IDP_idps, IDP_rf, IDP_sf] = idpS2idpW(idp_S, Rf, Sf) ;
IDP_sk = IDP_idps*IDPS_sk ;
IDP_sd = [] ;

if(~isempty(Sd))
    IDP_sd = IDP_idps*IDPS_sd ;
end 

IDP_pix = IDP_idps*IDPS_pix ;
IDP_invdepth = IDP_idps*IDPS_invdepth ;

end


