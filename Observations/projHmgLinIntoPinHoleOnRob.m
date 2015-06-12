function [s, d, S_rf, S_sf, S_k, S_l] = projHmgLinIntoPinHoleOnRob(Rf, Sf, Sk, l)

% PROJHMGLININTOPINHOLEONROB Project Hmg line into pinhole on robot.
%   [s, d] = PROJHMGLININTOPINHOLEONROB(Rf, Sf, Sk, l) projects the
%   inverse-depth line l into a pin/hole camera with intrinsic parameters
%   Sk mounted on a robot. The robot frame is Rf and the sensor frame in
%   the robot is Sf.
%
%   The results are a 2D segment S and a depths vector D.
%
%   [s, d, S_rf, S_sf, S_k, S_l] = (...) returns the Jacobians wrt all
%   input parameters.

%   Copyright 2009 Teresa Vidal.


if nargout <= 2
    
    sw = hmgLin2seg(l);
    s   = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    d   = 1./l([6 9]);

else
    
    [sw, SW_l] = hmgLin2seg(l);
    [s, d, S_rf, S_sf, S_k, S_sw] = projSegLinIntoPinHoleOnRob(Rf, Sf, Sk, sw);
    S_l  = S_sw*SW_l;
    
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

