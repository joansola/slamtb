function [hm, v, HM_r, HM_s, HM_k, HM_l] = ...
    projAplLinIntoPinHoleOnRob(Rf, Sf, Spk, l)

% PROJAPLLININTOPINHOLEONROB Project anchored Plucker line into pinhole on robot.
%    [HML,S] = PROJAPLLININTOPINHOLEONROB(RF, SF, SPK, SPD, L) projects 3D
%    Plucker line L into a pin-hole camera mounted on a robot, providing
%    also the non-measurable vector. The input parameters are:
%       RF : robot frame
%       SF : pin-hole sensor frame in robot
%       SPK: pin-hole intrinsic parameters [u0 v0 au av]'
%       L  : 3D Plucker line [nx ny nz vz vy vz]'
%    The output parameters are:
%       HML : 2D homogeneous line [a b c]'
%       V   : non-measurable vector [vx vy vz]'
%
%    [HML,S,HM_R,HM_S,HM_K,HM_L] = ... gives also the jacobians of the
%    observation HML wrt all input parameters. 
%
%    See also PINHOLEPLUCKER, TOFRAMEPLUCKER, PROJEUCPNTINTOPINHOLEONROB.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout <= 2 % only pixel
    
    pl     = unanchorPlucker(l);
    [hm,v] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, pl);
    
else % Jacobians
    
    % Same functions with Jacobians
    [pl,PL_l]                   = unanchorPlucker(l);
    [hm,v,HM_r,HM_s,HM_k,HM_pl] = projPlkLinIntoPinHoleOnRob(Rf, Sf, Spk, pl);

    % The chain rule for Jacobians
    HM_l  = HM_pl*PL_l;

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

