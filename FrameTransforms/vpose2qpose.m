function [qp, QP_vp] = vpose2qpose(vp)

% VPOSE2QPOSE  Vector-specified to quaternion-specified pose conversion.
%
%   QP = VPOSE2QPOSE(VP) returns a full 7-pose QP=[P;Q] from a full 6-pose
%   VP=[P;V], where P is 3D opsition and Q and V are 3D orientations.
%
%   [QP,QP_vp] = VPOSE2QPOSE(...) returns also the Jacobian matrix
%
%   See also QPOSE2EPOSE, EPOSE2QPOSE, EULERANGLES, QUATERNION, FRAME.

%   Copyright 2015 Joan Sola @ IRI-UPC_CSIC.


[q, Q_v] = v2q(vp(4:6));

qp(1:3,1) = vp(1:3);
qp(4:7,1) = q;

% Get Jacobians
if nargout > 1
    QP_vp(1:3,1:3) = eye(3);
    QP_vp(4:7,4:6) = Q_v;
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

