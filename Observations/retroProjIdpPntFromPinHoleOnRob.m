function [idp, IDP_rf, IDP_sf, IDP_sk, IDP_sc, IDP_u, IDP_rho] = ...
    retroProjIdpPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, n)

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

%   Copyright 2008,2009,2010 Joan Sola @ LAAS-CNRS.


% Frame World -> Robot  :  Rf
% Frame Robot -> Sensor :  Sf

if nargout == 1
    
    idp = ahp2idp(retroProjAhmPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, n));
    
else
    
    [ahp, AHP_rf, AHP_sf, AHP_sk, AHP_sc, AHP_u, AHP_rho] = retroProjAhmPntFromPinHoleOnRob(Rf, Sf, Sk, Sc, u, n);
    [idp, IDP_ahp] = ahp2idp(ahp);
    
    IDP_rf  = IDP_ahp*AHP_rf;
    IDP_sf  = IDP_ahp*AHP_sf;
    IDP_sk  = IDP_ahp*AHP_sk;
    if ~isempty(Sc)
        IDP_sc  = IDP_ahp*AHP_sc;
    else
        IDP_sc = [];
    end
    IDP_u   = IDP_ahp*AHP_u;
    IDP_rho = IDP_ahp*AHP_rho;
    
end


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

