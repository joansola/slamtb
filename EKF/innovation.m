function [z,Z,iZ,MD2,Z_e,Z_y] = innovation(y,R,e,E,f)

% INNOVATION  Innovation of an observation.
%   [z,Z] = INNOVATION(y,R,e,E) computes innovation z and innovation's
%   covariances matrix Z from a measurement N{y,R} to the expectation N{e,E}
%   as
%
%     z = y - e
%     Z = R + E
%
%   [z,Z] = INNOVATION(y,R,e,E,@Finn) uses the innovation function Finn to
%   compute the innovation:
%
%       z = Finn(y,e)
%
%   and uses its Jacobians F_e and F_y to compute Z:
%
%       Z = F_e*E*F_e' + F_y*R*F_y'
%
%   [z,Z,iZ,MD2] = INNOVATION(...) returns also the inverse of the
%   innovation covariance iZ and the squared Mahalanobis distance MD2.
%
%   [z,Z,iZ,MD2,F_e,F_y] INNOVATION(...) returns the Jacobians wrt the
%   expectation e and the measurement y.
%
%   EXAMPLES:
%   innovation(seg,SEG,hmLin,HMLIN,@hms2hh) is the innovation of a segment
%   measurement seg = [x1;y1;x2;y2] with respect to a homogeneous line
%   hmLin = [a;b;c], defined as the two orthogonal distances from [xi;yi]
%   to hmLin.
%
%   See also HMS2HH, MAHALANOBIS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 4  % Use plain Euclidean innovation
    z   = y - e;
    Z   = R + E;
    Z_e = -1;
    Z_y = 1;
else            % Use given function
    [z,Z_e,Z_y] = f(e,y);
    Z = Z_e*E*Z_e' + Z_y*R*Z_y';
end

% compute extra outputs
if nargout >= 3
    iZ = eye(size(Z,1))/Z;  % better than inv(Z) -- ask Matlab!
    if nargout >= 4
        MD2 = z'*iZ*z;
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

