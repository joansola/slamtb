function [qc,QCq] = q2qc(q)

% Q2QC  Conjugate quaternion.
%   Q2QC(Q) for Q = [a  b  c  d] is the conjugate quaternion
%              QC = [a -b -c -d] corresponding to the inverse
%   rotation of that represented by Q.
%
%   [qc,QCq] = Q2QC(...) gives the Jacobian wrt Q.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   (c) 2009 Joan Sola @ LAAS-CNRS.



qc        = q;
qc(2:end) = -qc(2:end);

if nargout == 2
    QCq = diag([1 -1 -1 -1]);
end
