function [r, R_r, R_v, R_a] = rpredict(r, v, a, dt)

% RPREDICT Position prediction.
%   RPREDICT(R,V,DT) performs the time update R = R + V*DT.
%
%   RPREDICT(R,V,A,DT) considers R = R + V*DT + 1/2*A*DT instead.
%
%   [R,R_r,R_v,R_a] = ... returns Jacobian matrices wrt position R,
%   velocity V and acceleration A.
%
%   See also VPREDICT, QPREDICT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 3
    dt  = a;
    r   = r + v*dt;
    R_r = eye(length(r));
    R_v = dt*R_r;
    R_a = zeros(3);

elseif nargin == 4
    r   = r + v*dt + .5*a*dt^2;
    R_r = eye(length(r));
    R_v = R_r*dt;
    R_a = 0.5*R_r*dt^2;

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

