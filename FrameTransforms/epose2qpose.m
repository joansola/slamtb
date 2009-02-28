function [qp,QPe] = epose2qpose(ep)

% EPOSE2QPOSE  Euler-specified to quaternion-specified full pose conversion
%
%   QP = EPOSE2QPOSE(EP) returns a full pose QP=[X;Q] from a full pose QE=[X;E]
%   where X is 3D opsition and Q and E are 3D orientations
%
%   [QP,Jep] = EPOSE2QPOSE(...) returns also the Jacobian matrix

if any(size(ep) ~= [6,1])
    warning('Input pose should be a column 7-vector')
end

qp = zeros(7,1);
qp(1:3) = ep(1:3);
P = eye(3);
[qp(4:7),Qe] = e2q(ep(4:6));
QPe = [P zeros(3);zeros(4,3) Qe];
