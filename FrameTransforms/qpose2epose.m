function [ep,EPq] = qpose2epose(qp)

% QPOSE2EPOSE  Quaternion-specified to Euler-specified pose conversion.
%
%   EP = QPOSE2EPOSE(QP) returns a full pose EP=[X;E] from a full pose QP=[X;Q]
%   where X is 3D opsition and Q and E are 3D orientations
%
%   [EP,Jqp] = QPOSE2EPOSE(...) returns also the Jacobian matrix.
%
%   See also EPOSE2QPOSE, EULERANGLES, QUATERNION.

if any(size(qp) ~= [7,1])
    warning('Input pose should be a column 7-vector')
end

ep = zeros(6,1);
ep(1:3) = qp(1:3);
P = eye(3);
[ep(4:6),Eq] = q2e(qp(4:7));
EPq = [P zeros(3,4);zeros(3) Eq];
