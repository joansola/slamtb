function [hmg, HMG_rf, HMG_sf, HMG_sk, HMG_sd, HMG_u, HMG_invdepth] = ...
    retroProjHmgPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, u, n)

% RETROPROJHMGPNTFROMPINHOLEONROB Retro-project Homogene point from pinhole on robot.
%
%   IDP = RETROPROJHMGPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives the
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
    % lmk position in Sensor Frame
    [p, P_u, P_d, P_sk] = invPinHole(u,1,Sk) ;
else
    % lmk position in Sensor Frame
    [p, P_u, P_rho, P_sk, P_sd] = invPinHole(u,1/n,Sk,Sd) ;
end

% lmk position in Robot Frame
[pr,PR_sf,PR_p] = fromFrame(Sf,p) ;

% lmk position in World Frame
[pw,PW_rf,PW_pr] = fromFrame(Rf,pr) ;

hmg = [pw ; n] ;
HMG_rf =    [PW_rf           ; 0,0,0, 0,0,0,0 ] ;
HMG_sf =    [PW_pr*PR_sf     ; 0,0,0, 0,0,0,0 ] ;
HMG_sk =    [PW_pr*PR_p*P_sk ; 0,0,0,0 ] ;

if(isempty(Sd))
    HMG_sd = [] ;
else
    HMG_sd =    [PW_pr*PR_p*P_sd ; 0,0 ] ;
end 


HMG_u        = [PW_pr*PR_p*P_u ; 0,0 ] ;
HMG_invdepth = [0;0;0;1] ;

end


