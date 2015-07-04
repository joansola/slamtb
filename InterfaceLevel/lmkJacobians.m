function Lmk = lmkJacobians(Lmk)

% LMKJACOBIANS Compute Jacobians for projection onto the manifold.
%   LMKJACOBIANS computes all the Jacobians of the landmarks in structure
%   array Lmk for the projection of the landmark errors into the landmark
%   manifolds. The computed Jacobians are stored in Lmk.state.M. Its
%   expression depends on the landmark type.
%
%   Landmark types are specifyed by Lmk.type. In the case of Euclidean
%   points 'eucPnt', details follow.
%
%   The landmark's position manifold is defined trivially, so that
%       dp = [dpx dpy dpz]'
%   and the composition is just a sum,
%       p+ = p + dp.
%   In such case, the Jacobian 
%       M = d p+ / d dp 
%   is the identity matrix. To save some computations, this function
%   returns just M = 1 (scalar 'one').
%
%   For details on the Jacobians of other landmark parametrizations, please
%   refer to the code by editing the file lmkJacobians.m.
%
%   See also FRMJACOBIANS.

% Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.

for lmk = [Lmk([Lmk.used]).lmk]
    switch Lmk(lmk).type
        case 'eucPnt'
            Lmk(lmk).state.M = 1; % trivial Jac
        case 'hmgPnt'
            [~,~,H_dh] = composeHmgPnt(Lmk(lmk).state.x, zeros(3,1));
            Lmk(lmk).state.M = H_dh;
        otherwise
            error('??? Unknown landmark type ''%s'' or Jacobian not implemented.',Lmk.type)
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

