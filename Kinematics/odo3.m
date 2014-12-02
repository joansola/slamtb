function [F,F_r,F_u] = odo3(F,u)

% ODO3 3D Odometry evolution.
%   F = ODO3(F,U) performs one step on the pose F of a vehicle, given
%   odometry increments U=[DX;DV] in robot frame.
%   - F is a frame structure (see FRAME).
%   - Position increment DX is given in robot frame F.
%   - Orientation increment DV is given as a Rotation Vector in robot frame F.
%
%   [F,F_r,F_u] = ODO3(F,U) gives the full Jacobians wrt state and odometry
%   inputs.
%
%   See also FRAME, V2Q, QPROD, QUATERNION.

%   Copyright 2005-2009 Joan Sola @ LAAS-CNRS.

dv = u(4:6);
dx = u(1:3);

if nargout == 1

    x = fromFrame(F,dx); % Position update

    q  = F.x(4:end);
    q2 = qProd(q,v2q(dv)); % quaternion update

    F.x = [x;q2]; % frame update


else  % Jacobians

    [x,X_r,X_dx] = fromFrame(F,dx); % Position update and jacobians

    q               = F.x(4:end);
    [dq,DQ_dv]      = v2q(dv);
    [q2,Q2_q,Q2_dq] = qProd(q,dq); % quaternion update
    Q2_dv           = Q2_dq*DQ_dv;

    F.x = [x;q2]; % frame update

    F_r  = [X_r;zeros(4,3) Q2_q];
    F_u  = [X_dx zeros(3,3);zeros(4,3) Q2_dv];
end

F = updateFrame(F);

return

%% Jacobians

syms x y z a b c d real
syms dx dy dz dp dq dr real
Fi.x=[x;y;z;a;b;c;d];
Dx = [dx;dy;dz];
Dv = [dp;dq;dr];
u  = [Dx;Dv];

Fi = updateFrame(Fi);

[F,F_r,F_u] = odo3(Fi,u);

F_rs = jacobian(F.x,Fi.x);
F_us = jacobian(F.x,[Dx;Dv]);

simplify(F_r-F_rs)
simplify(F_u-F_us)



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

