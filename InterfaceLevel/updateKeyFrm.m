function Frm = updateKeyFrm(Frm)

% UPDATEKEYFRM Update key-frame
%   Frm = UPDATEKEYFRM(Frm) updates the state of the key-frame Frm
%   according to the information in the global variable Map. For this, it
%   accesses the correction step through the range stored in Frm.state.r,
%
%       dpose = Map.x(Frm.state.r),
%
%   and uses frame composition to update the frame state, Frm.state.x,
%
%       Frm.state.x = Frm.state.x ++ dpose,
%
%   where ++ is a nonlinear frame composition, explained below.
%
%   The frame composition operator ++ partitions the frame state, 
%
%       Frm.state.x = [p;q], 
%
%   with position p and orientation quaternion q, and the correction
%   step, 
%
%       dpose = [dp;dphi], 
%
%   with position increment, dp, and orientation increment, dphi. The
%   operator ++ is then decomposed in two parts.
%
%   1) The position increment, dp, acts linearly in the update:
%
%       p = p + dp;
%
%   2) The orientation increment, dphi, is taken to be the imaginary vector
%   of the orientation quaternion, so that we can define a quaternion step,
%
%       dq =    [ sqrt( 1 - || dphi || ) ]
%               [          dphi          ]
%
%   from which we apply the update via quaternion product,
%
%       q = q ** dq
%
%   where ** is the quaternion product (using the Hamilton convention).
%
%   See also UPDATESTATES, SOLVEGRAPHQR, SOLVEGRAPHCHOLESKY,
%   SOLVEGRAPHSCHUR.

%   Copyright 2016 Joan Sola @ IRI-UPC-CSIC

global Map

% Get state error from Map
dp = Map.x(Frm.state.r);

% quaternion error - we use:
%   dq =    [ sqrt( 1 - || dphi || ) ]
%           [          dphi          ]
% with
%   dphi = dp(4:6)
dphi = dp(4:6);
dq = [sqrt(1 - dphi'*dphi) ; dphi]; 

% Update pose
Frm.state.x(1:3) = Frm.state.x(1:3) + dp(1:3);  % position in Euclidean
Frm.state.x(4:7) = qProd(Frm.state.x(4:7), dq); % Quaternion uses manifold

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

