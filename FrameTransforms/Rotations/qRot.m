function vr = qRot(v,q)

% QROT Vector rotation via quaternion algebra.
%   PR = QROT(V,Q) performs to vector V the rotation specified by
%   quaternion Q.
%
%   See also QUATERNION, Q2Q, QPROD.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

v = [0;v];

vr = qProd(qProd(q,v),q2qc(q));

vr = vr(2:end);









