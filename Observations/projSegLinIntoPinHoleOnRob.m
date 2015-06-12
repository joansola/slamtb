function [s, d, S_rf, S_sf, S_k, S_seg] = ...
    projSegLinIntoPinHoleOnRob(Rf, Sf, k, seg)

% PROJSEGLININTOPINHOLEONROB Project segment line into pinhole on robot.
%    [S,D] = PROJSEGLININTOPINHOLEONROB(RF, SF, SPK, SEG) projects 3D line
%    segments SEG into a pin-hole camera mounted on a robot, providing also
%    the non-measurable depth. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       SEG: 3D line segment, SEG = [E1;E2], with Ei a 3D point
%    The output parameters are:
%       S  : 2D segment [e1;e2]', with ei a 2D pixel
%       D  : non-measurable depths [d1;d2].
%
%    The function accepts a segments matrix SEG = [SEG1 ... SEGn] as input.
%    In this case, it returns a segments matrix S = [S1 ... Sn] and a
%    depths row-vector D = [D1 ... Dn].
%
%   [S, D, S_rf, S_sf, S_k, S_seg] = PROJSEGLININTOPINHOLEONROB(...)
%   returns the Jacobians wrt all input parameters.
%
%   See also TOFRAMESEGMENT, PINHOLESEGMENT, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



if nargout <= 2
    
    sr    = toFrameSegment(Rf,seg);
    ss    = toFrameSegment(Sf,sr);
    [s,d] = pinHoleSegment(k,ss);

else % we want Jacobians
    
    % partial values and Jacobians
    [sr, SR_rf, SR_seg] = toFrameSegment(Rf,seg);
    [ss, SS_sf, SS_sr]  = toFrameSegment(Sf,sr);
    [s, d, S_k, S_ss]   = pinHoleSegment(k,ss);
    
    % chain rule
    S_sr  = S_ss*SS_sr;
    S_sf  = S_ss*SS_sf;
    S_rf  = S_sr*SR_rf;
    S_seg = S_sr*SR_seg;

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

