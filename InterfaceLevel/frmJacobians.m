function Frm = frmJacobians(Frm)

% FRMJACOBIANS Compute Jacobians for projection onto the manifold.
%   FRMJACOBIANS computes all the Jacobians of the frames in structure
%   array Frm for the projection of the frame errors into the frame
%   manifolds. The computed Jacobians are stored in Frm.state.M. 
%
%   Frames are [p,q]'. Details follow.
%
%   The position manifold is defined trivially, so that
%       dp = [dpx dpy dpz]'
%   and the composition is just a sum,
%       p+ = p + dp,
%   so the Jacobian is the 3x3 identity matrix I.
%
%   The quaternion manifold is defined with a tangent space:
%       phi = [phix, phiy, phiz]'
%   so that the quaternion error is expressed
%       dq = [sqrt(1 - norm(phi)^2)]
%            [         phi         ]
%   and the composition is done locally
%       q+ = qProd( 1, dq)
%   In such case, the Jacobian is given by
%       dq+ / d dq = q2Pi(q)
%
%   The total Jacobian is thus
%
%       M = [  I     0    ]
%           [  0  q2Pi(q) ]
%
%   See also LMKJACOBIANS.

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC.


for rob = 1:size(Frm,1)
    for frm = [Frm(rob,[Frm(rob,:).used]).frm]
        q = Frm(rob,frm).state.x(4:7);
        Frm(rob,frm).state.M = [eye(3), zeros(3,3) ; zeros(4,3) q2Pi(q)];
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

