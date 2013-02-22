function [hmg, HMG_rf, HMG_sf, HMG_sk, HMG_sc, HMG_u, HMG_n] = ...
    retroProjHmgPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, n)

% RETROPROJHMGPNTFROMPINHOLEONROB Retro-proj. Hmg pnt from pinhole on rob.
%
%   HMG = RETROPROJIDPPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected HMG point in World Frame from an observed pixel U. RF
%   and SF are Robot and Sensor Frames, SK and SD are camera calibration
%   and distortion correction parameters. U is the pixel coordinate and N
%   is the non-observable inverse depth. HMG is a 4-vector :
%     HMG = [X Y Z IDepth]'
%
%   [HMG, HMG_RF, HMG_SF, HMG_SK, HMG_SD, HMG_U, HMG_N] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also INVPINHOLEHMG, FROMFRAMEHMG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

% if(isempty(Sd))
%     % In Sensor Frame:
[hmsen, HMSEN_u, HMSEN_n, HMSEN_sk, HMSEN_sc] = invPinHoleHmg(u,n,Sk,Sc) ;
% else
%     error('??? NYI ''Sd'' for invPinHoleHmg')
% end

% In rob Frame
[hmrob, HMROB_sf, HMROB_hmsen] = fromFrameHmg(Sf,hmsen) ;

% In World Frame
[hmg, HMG_rf, HMG_hmrob] = fromFrameHmg(Rf,hmrob) ;



% Jacobians

HMG_hmsen = HMG_hmrob*HMROB_hmsen;

HMG_sf = HMG_hmrob*HMROB_sf ;
HMG_sk = HMG_hmsen*HMSEN_sk ;
% if(isempty(Sd))
HMG_sc = HMG_hmsen*HMSEN_sc ;
% else
%     error('??? NYI ''Sd'' for invPinHoleHmg')
% end
HMG_u  = HMG_hmsen*HMSEN_u ;
HMG_n  = HMG_hmsen*HMSEN_n ;

end











