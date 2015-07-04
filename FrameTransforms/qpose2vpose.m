function [vp, VP_qp] = qpose2vpose(qp)

% QPOSE2VPOSE  Vector-specified to quaternion-specified pose conversion.
%
%   VP = QPOSE2VPOSE(QP) returns a full 6-pose VP=[P;V] from a full 7-pose
%   QP=[P;Q], where P is 3D opsition and Q and V are 3D orientations.
%
%   [VP,VP_qp] = VPOSE2QPOSE(...) returns also the Jacobian matrix
%
%   See also QPOSE2EPOSE, EPOSE2QPOSE, EULERANGLES, QUATERNION, FRAME.

%   Copyright 2015 Joan Sola @ IRI-UPC_CSIC.

[v, V_q] = q2v(qp(4:7));

vp(1:3,1) = qp(1:3);
vp(4:6,1) = v;

% Get Jacobians
if nargout > 1
    VP_qp(4:6,4:7) = V_q;  % this one first so that it works in symbolic
    VP_qp(1:3,1:3) = eye(3);
end

return

%%
syms x y z q0 q1 q2 q3 real
qp = [x;y;z;q0;q1;q2;q3];
[vp, VP_qp] = qpose2vpose(qp);

simplify(VP_qp - jacobian(vp,qp))





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

