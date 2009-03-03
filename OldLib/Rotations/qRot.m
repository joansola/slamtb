function pr = qRot(p,q)

% QROT Rotation from quaternion
%   PR = QROT(P,Q) performs to point P the rotation
%   specified by quaternion Q

p = [0;p];

pr = qProd(qProd(q,p),q2qc(q));

pr = pr(2:end);
