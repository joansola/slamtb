function [qp,QP_ep] = epose2qpose(ep)

% EPOSE2QPOSE  Euler-specified to quaternion-specified pose conversion.
%
%   QP = EPOSE2QPOSE(EP) returns a full 7-pose QP=[X;Q] from a full 6-pose
%   QE=[X;E], where X is 3D opsition and Q and E are 3D orientations.
%
%   [QP,Jep] = EPOSE2QPOSE(...) returns also the Jacobian matrix
%
%   See also QPOSE2EPOSE, EULERANGLES, QUATERNION, FRAME.

if any(size(ep) ~= [6,1])
    warning('Input Euler-pose should be a column 6-vector')
end

qp            = zeros(7,1);  % empty quaternion pose
qp(1:3)       = ep(1:3);     % position copy
P             = eye(3);      % Jacobian of copy function
[qp(4:7),Q_e] = e2q(ep(4:6));% orientation and Jacobian

QP_ep         = [P zeros(3);zeros(4,3) Q_e]; % Full Jacobian
