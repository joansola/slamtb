function [e,E] = q2eG(q,Q)

% Q2EG  Transform quaternion Gaussian to Euler Gaussian.
%   [e,E] = Q2EG(q,Q) thransforms the Gaussian quaternion N(q,Q) into a
%   Euler angles Gaussian N(e,E) representing the same rotation with the
%   same uncertainty.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[e,Eq] = q2e(q);
E = Eq*Q*Eq';




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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

