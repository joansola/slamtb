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
    VP_qp(1:3,1:3) = eye(3);
    VP_qp(4:6,4:7) = V_q;
end
