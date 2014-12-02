function [ahm, AHM_rf, AHM_sf, AHM_sk, AHM_sc, AHM_u, AHM_rho] = ...
    retroProjAhmPntFromOmniCamOnRob(Rf, Sf, Sk, Sc, u, n)

% RETROPROJAHMPNTFROMOMNICAMONROB Retro-project ahm from omnicam on robot.
%
%   AHM = RETROPROJAHMPNTINTOOMNICAMONROB(RF, SF, SK, SC, U, N) gives the
%   retroprojected AHM in World Frame from an observed pixel U. RF and SF
%   are Robot and Sensor Frames, Sk and Sc are camera calibration and
%   distortion correction parameters. U is the pixel coordinate and N is
%   the non-observable inverse depth. AHM is a 7-vector :
%     AHM = [X Y Z U V W IDepth]'
%
%   [AHM, AHM_rf, AHM_sf, AHM_k, AHM_c, AHM_u, AHM_n] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC, U and N.
%
%   See also FROMFRAMEAHM.
%

%   Copyright 2012 Grigory Abuladze @ ASL-vision
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

  % AHM in Sensor Frame
  [ahms, AHMS_u, AHMS_rho, AHMS_sk, AHMS_sc] = invOmniCamAhm(u, n, Sk, Sc) ;

  [ahmr, AHMR_sf, AHMR_ahms] = fromFrameAhm(Sf,ahms);
  [ahm , AHM_rf , AHM_ahmr]  = fromFrameAhm(Rf,ahmr);

  AHM_ahms = AHM_ahmr*AHMR_ahms;
  AHM_sk   = AHM_ahms*AHMS_sk ;
  AHM_sf   = AHM_ahmr*AHMR_sf;

  AHM_sc  = AHM_ahms*AHMS_sc ;

  AHM_u   = AHM_ahms*AHMS_u ;
  AHM_rho = AHM_ahms*AHMS_rho ;

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

