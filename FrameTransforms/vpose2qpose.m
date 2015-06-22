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

