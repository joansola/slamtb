function r = addToMap(L, P_LL, P_LX, r)

% ADDTOMAP  Add Gaussian to Map.
%   ADDTOMAP(L,P_LL) adds the Gaussian N(L,P_LL) to the global EKF-map Map,
%   at positions that are empty, and returns the range of positions where
%   it has been added. ADDTOMAP adds mean L in Map.x and covariances P_LL
%   in the block-diagonal of Map.P. 
%
%   For example, in the case of a map which has all used states contiguous,
%   the new state and covariance are appended at the end of the existing
%   one:
%
%           | x |        | P     0   |
%       x = |   |    P = |           |
%           | L |        | 0    P_LL |
%
%
%   Map is a global structure, containing:
%       .used   a vector of logicals indicating used positions 
%       .x      the state vector 
%       .P      the covariances matrix 
%       .size   the Map's maximum size, numel(Map.x)
%
%   ADDTOMAP(L,P_LL,P_LX) accepts the cross variance matrix between L and the
%   currently used states in Map.x, so that the covariance is augmented
%   with
%
%           |   P     P_LX' |
%       P = |               |
%           | P_LX    P_LL  |
%   
%   ADDTOMAP(L,P_LL,P_LX,R) or ADDTOMAP(L,P_LL,[],R) permits forcing the
%   range R as input.
%
%   See also NEWRANGE, USEDRANGE.
%
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

% parse inputs
if nargin == 2
    P_LX = [] ;
end
if nargin <= 3
    r = newRange(numel(L));
end

% add to map
Map.x(r)    = L;
Map.P(r,r)  = P_LL;
if(size(P_LX)~=0)
    mr = usedRange();
    Map.P(r,mr) =  P_LX ;
    Map.P(mr,r) =  P_LX' ;
end ;

Map.used(r) = true;



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

