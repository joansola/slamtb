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

