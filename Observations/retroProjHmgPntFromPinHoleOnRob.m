function [hmg, HMG_rf, HMG_sf, HMG_sk, HMG_sd, HMG_u, HMG_n] = ...
    retroProjHmgPntFromPinHoleOnRob(Rf, Sf, Sk, Sd, u, n)

% RETROPROJHMGPNTFROMPINHOLEONROB Retro-proj. Hmg pnt from pinhole on rob.
%
%   HMG = RETROPROJIDPPNTFROMPINHOLEONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected HMG in World Frame from an observed pixel U. RF and SF
%   are Robot and Sensor Frames, SK and SD are camera calibration and
%   distortion correction parameters. U is the pixel coordinate and N is
%   the non-observable inverse depth. HMG is a 4-vector :
%     HMG = [X Y Z IDepth]'
%
%   [HMG, HMG_RF, HMG_SF, HMG_SK, HMG_SD, HMG_U, HMG_N] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also INVPINHOLEHMG, FROMFRAMEHMG.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

% Pixel Hmg:
[hmpix,HMPIX_u] = euc2hmg(u);

if(isempty(Sd))
    % In Sensor Frame:
    [hmsen, HMSEN_sk, HMSEN_hmpix, HMSEN_n] = invPinHoleHmg(Sk,hmpix,n) ;
else
    error('??? NYI ''Sd'' for invPinHoleHmg')
end

% In rob Frame
[hmrob, HMROB_sf, HMROB_hmsen] = fromFrameHmg(Sf,hmsen) ;

% In World Frame
[hmg, HMG_rf, HMG_hmrob] = fromFrameHmg(Rf,hmrob) ;



% Jacobians

HMG_sf = HMG_hmrob*HMROB_sf ;
HMG_sk = HMG_hmrob*HMROB_hmsen*HMSEN_sk ;

if(isempty(Sd))
    HMG_sd = Sd ;
else
    error('??? NYI ''Sd'' for invPinHoleHmg')
end

HMG_u = HMG_hmrob*HMROB_hmsen*HMSEN_hmpix*HMPIX_u ;
HMG_n = HMG_hmrob*HMROB_hmsen*HMSEN_n ;

end


