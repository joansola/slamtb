function [pap, PAP_rf, PAP_sf, PAP_sk, PAP_sc, PAP_u] = ...
    retroProjPapPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u)

% RETROPROJPAPPNTFROMPINHOLEONROB Retro-project pap from pinhole on robot.
%
%   PAP = RETROPROJPAPPNTFROMPINHOLEONROB(RF, SF, SK, SC, U) gives the
%   retroprojected PAP in World Frame from an observed pixel U. RF and SF
%   are Robot and Sensor Frames, SK and SD are camera calibration and
%   distortion correction parameters. U is the pixel coordinate. PAP is a
%   5-vector (the reduced parametrization form):
%     PAP = [Xm Ym Zm Pitch Yaw]'
%
%   [PAP, PAP_rf, PAP_sf, PAP_k, PAP_c, PAP_u] = ... returns the
%   Jacobians wrt RF.x, SF.x, SK, SC and U.
%
%   See also INVPINHOLEIDP, FROMFRAMEIDP.

%   Copyright 2015 Ellon Paiva @ LAAS-CNRS.


% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if nargout == 1
    
    Cf = composeFrames(Rf,Sf);
    ahp = retroProjAhmPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, 1.0);
    py = vec2py(ahp(4:6));
    
else
    [Cf, CF_rf, CF_sf] = composeFrames(Rf,Sf);
    [ahp, AHP_rf, AHP_sf, AHP_sk, AHP_sc, AHP_u, ~] = retroProjAhmPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, 1.0);
    [py, PY_ahp4to6] = vec2py(ahp(4:6));
    
    
    PAP_rf  = [CF_rf(1:3,:); PY_ahp4to6*AHP_rf(4:6,:)];
    PAP_sf  = [CF_sf(1:3,:); PY_ahp4to6*AHP_sf(4:6,:)];
    PAP_sk  = [zeros(3,4);   PY_ahp4to6*AHP_sk(4:6,:)];
    if ~isempty(Sc)
        PAP_sc  = [zeros(3,numel(Sc)); PY_ahp4to6*AHP_sc(4:6,:)];
    else
        PAP_sc = [];
    end
    PAP_u   = [zeros(3,2); PY_ahp4to6*AHP_u(4:6,:)];

end

pap(1:3,1) = Cf.t;
pap(4:5,1) = py;
    
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

