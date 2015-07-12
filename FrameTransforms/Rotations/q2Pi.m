function Pi = q2Pi(q)

% Q2PI  Pi matrix construction from quaternion.
%   PI = Q2PI(Q) Jacobian submatrix PI from quaternion
%
%   Given:  Q     = [a b c d]'  the attitude quaternion
%           W     = [p q r]'    the angular rates vector
%           OMEGA = W2OMEGA(W)  a skew symetric matrix 
%
%   The output matrix:
%
%                |-b -c -d |
%           PI = | a -d  c |  
%                | d  a -b |
%                |-c  b  a |  
% 
%   is the Jacobian of OMEGA(W)*Q with respect to W
%
%   See also W2OMEGA, Q2R
    
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

Pi = [-q(2) -q(3) -q(4)
       q(1) -q(4)  q(3)
       q(4)  q(1) -q(2)
      -q(3)  q(2)  q(1)];



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

