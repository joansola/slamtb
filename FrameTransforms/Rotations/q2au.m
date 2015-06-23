function [a,u,A_q,U_q] = q2au(q)

%Q2AU quaternion to rotated angle and rotation axis vector.
%   [A,U] = Q2AU(Q) gives the rotation of A rad around the axis
%   defined by the unity vector U, that is equivalent to that
%   defined by the quaternion Q

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout <= 2
    
    a = 2*acos(q(1));
    
    u = q(2:4);
    u = normvec(u);
    
else
    
    a = 2*acos(q(1));
    u = q(2:4);

    if a > 1e-7
        A_q1 = -2/sqrt(1-q(1)^2); % d arccos(x) / dx = -1/sqrt(1-x^2)
        [u, U_u] = normvec(u);
        A_q = [A_q1 0 0 0];
        U_q = [zeros(3,1) U_u];
    else
        u  = [1;0;0]; % Fake, any vector
        A_q = zeros(1,4);
        U_q = [zeros(3,1) 2*eye(3)];
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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

