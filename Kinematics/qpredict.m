function [q1,Q1_q,Q1_w] = qpredict(q,w,dt,met)

% QPREDICT Time update function for quaternions.
%   Qu = QPREDICT(Q,DV) is the updated quaternion Q after a rotation in body
%   frame expressed by the three angles in DV (roll, pitch, yaw).
%
%   Qu = QPREDICT(Q,W,DT) assumes a rotation speed W and a sampling time DT.
%   It is equivalent to the previous case with DV = W*DT.
%
%   [Qu,QU_q,QU_w] = QPREDICT(Q,W,DT) returns Jacobians wrt Q and W.
%
%   [...] = QPREDICT(...,MET) allows the specification of the method to
%   update the quaternion:
%       'euler' uses Qu = Q + .5*DT*W2OMEGA(W)*Q
%       'exact'  uses Qu = QPROD(Q,V2Q(W*DT))
%   The Jacobians are always computed according to the 'euler' method.
%   'exact' is the default method.
%
%   See also QPROD, W2OMEGA, Q2PI, V2Q, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch nargin
    case 2
        dt = 1;
        met = 'exact';
    case 3
        if isa(dt,'char')
            met = dt;
            dt = 1;
        else
            met = 'exact';
        end
end


switch lower(met)
    case 'euler'
        W  = w2omega(w);
        q1 = q + .5*dt*W*q; % euler integration - fits with Jacobians
    case 'exact'
        q1 = qProd(q,v2q(w*dt)); % True value - Jacobians based on euler form
    otherwise
        error('Unknown quaternion predict method. Use ''euler'' or ''exact''')
end

if nargout > 1  % Jacobians always use euler method
    W    = w2omega(w);
    Q1_q = eye(4) + 0.5*dt*W;
    Q1_w = 0.5*dt*q2Pi(q);
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

