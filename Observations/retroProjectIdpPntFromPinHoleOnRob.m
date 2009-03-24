

function [idp_W, IDPWrf, IDPWsf, IDPWsk, IDPWsd, IDPWpoint, IDPWinvdepth] = retroProjectIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, point, inv_depth)


% RETROPROJECTIDPPNTFROMPINHOLEONROB De-Project idp point into Pin-hole
% camera model on robot.
%   IDP_W = RETROPROJECTIDPPNTFROMPINHOLEONROB(RF, SF, SK, SD, POINT,
%   INV_DEPTH) gives the retroprojected IDP in World Frame from an
%   observation. RF and SF are Robot and Sensor Frames, SK and SD are
%   camera parameters. POINT is the pixel coordinate and INV_DEPTH is the
%   non-observable part of the measuerment.
%    
%   IDP_W is a 6 variables vector :
%     IDP_W = [X Y Z Pitch Yaw IDepth]'
%   
%   [IDP_W, IDPWRF, IDPWSF, IDPWSK, IDPWSD, IDPWPOINT, IDPWINVDEPTH] = ...
%   return the idp retro-projected wrt parameters.
%   
%   
%   See also INVPINHOLEIDP, FROMFRAMEIDP, COMPOSEFRAMES.



% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if(isempty(Sd))
    % IDP in Sensor Frame
    [idp_S, IDPSpoint, IDPSinvdepth, IDPSsk] = invPinHoleIdp(point,inv_depth,Sk) ;
else
    % IDP in Sensor Frame
    [idp_S, IDPSpoint, IDPSinvdepth, IDPSsk, IDPSsd] = invPinHoleIdp(point,inv_depth,Sk,Sd) ;
end ;



[idp_W, IDPWidps, IDPWrf, IDPWsf] = idpS2idpW(idp_S, Rf, Sf) ;
IDPWsk = IDPWidps*IDPSsk ;
IDPWsd = [] ;
if(~isempty(Sd))
    IDPWsd = IDPWidps*IDPSsd ;
end ;
IDPWpoint = IDPWidps*IDPSpoint ;
IDPWinvdepth = IDPWidps*IDPSinvdepth ;

end


