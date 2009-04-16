function [Rob,F_r,F_u] = odo3(Rob,u)

% ODO3 3D Odometry evolution.
%   R = ODO3(R,DX,DV) performs one step on the pose R of a vehicle, given
%   odometry increments U=[DX;DV] in robot frame.
%   - R is a frame structure (see FRAME) containing at least
%       .x = [t;q] : frame's state vector
%       .t : translation vector
%       .R : rotation matrix
%       .Pi: Pi matrix
%   - Position increment DX is given in body frame.
%   - Orientation increment DV is given as a Rotation Vector in body frame.
%
%   [R,F_r,F_u] = ODO3(R,U) gives the full Jacobians wrt state and odometry
%   inputs.
%
%   See also FRAME, V2Q, QPROD, QUATERNION.

%   (c) 2009 Joan Sola @ LAAS-CNRS.


dv = u(4:6);
dx = u(1:3);

if nargout == 1

    x = fromFrame(Rob,dx); % Position update

    q  = Rob.x(4:end);
    q2 = qProd(q,v2q(dv)); % quaternion update

    Rob.x = [x;q2]; % frame update


else  % Jacobians

    [x,X_r,X_dx] = fromFrame(Rob,dx); % Position update and jacobians

    q               = Rob.x(4:end);
    [dq,DQ_dv]      = v2q(dv);
    [q2,Q2_q,Q2_dq] = qProd(q,dq); % quaternion update
    Q2_dv           = Q2_dq*DQ_dv;

    Rob.x = [x;q2]; % frame update

    F_r  = [X_r;zeros(4,3) Q2_q];
    F_u  = [X_dx zeros(3,3);zeros(4,3) Q2_dv];
end

Rob = updateFrame(Rob);

return

%% Jac
syms x y z a b c d real
syms dx dy dz dp dq dr real
Rob.x=[x;y;z;a;b;c;d];
Dx = [dx;dy;dz];
Dv = [dp;dq;dr];
u  = [Dx;Dv];

Rob = updateFrame(Rob);

[R,R_r,R_u] = odo3(Rob,u);

R_rs = jacobian(R.x,Rob.x);
R_us = jacobian(R.x,[Dx;Dv]);

simplify(R_r-R_rs)
simplify(R_u-R_us)



