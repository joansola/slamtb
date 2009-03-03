% ODO3JACTEST Test of jacobians of 3D odometry functions
%   This is an script: it takes no arguments.
%   Add or delete end-of-line semicolons to modify
%   display properties.
%
%   See also ODO3

format compact

syms a b c d real  % quaternion
syms x y z real    % position
syms u v w real    % euler
syms dx dy dz real % translation
syms du dv dw real % rotation

e = [u v w]';
q = [a b c d]';
t = [x y z]';

dt = [dx dy dz]';
de = [du dv dw]';

Rq = [t;q];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% increments; frames in euler angles
R  = ori2mat(e);
tp = t+R*dt;
ep = e+de; % this is not true

% true jacobians
TPt  = jacobian(tp,t);
TPe  = jacobian(tp,e);
TPdt = jacobian(tp,dt);
EPe  = jacobian(ep,e);
EPde = jacobian(ep,de);

% coded jacobians

% errors

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% increments; frames in quaternion 
R  = ori2mat(q);
Om = w2omega(de);
tp = t+R*dt;
qp = q+0.5*Om*q;

% true jacobians
TPt  = jacobian(tp,t);
TPq  = jacobian(tp,q);
TPdt = jacobian(tp,dt);
QPq  = jacobian(qp,q);
QPde = jacobian(qp,de);

% coded jacobians
[Tr,Tdt,Qq,Qde] = odo3Jac(Rq,dt,de);
Tt = Tr(:,1:3);
Tq = Tr(:,4:end);
% errors
ETt  = simple(TPt  - Tt )
ETq  = simple(TPq  - Tq )
ETdt = simple(TPdt - Tdt)
EQq  = simple(QPq  - Qq )
EQde = simple(QPde - Qde)

format loose