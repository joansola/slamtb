function [qn,QNq] = normquat(q)

% NORMQUAT Normalize quaternion to unit length
%   NORMQUAT(Q) returns a unit length quaternion Q/norm(Q)
%
%   [qn,QNq] = NORMQUAT(Q) returns also the Jacobian wrt Q. Note that this
%   Jacobian is a symmetric 4x4 matrix.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


nq = sqrt(q(:)'*q(:));
qn = q/nq;


if nargout > 1
    
    a = q(1);
    b = q(2);
    c = q(3);
    d = q(4);

    nq3 = nq^3;
    
    QNq = [...
        [ (b^2+c^2+d^2)/nq3,          -a/nq3*b,          -a/nq3*c,          -a/nq3*d]
        [          -a/nq3*b, (a^2+c^2+d^2)/nq3,          -b/nq3*c,          -b/nq3*d]
        [          -a/nq3*c,          -b/nq3*c, (a^2+b^2+d^2)/nq3,          -c/nq3*d]
        [          -a/nq3*d,          -b/nq3*d,          -c/nq3*d, (a^2+b^2+c^2)/nq3]];
end
return

%%

syms a b c d real
q = [a;b;c;d];
[qn,QNq] = normquat(q);

QNq - simple(jacobian(qn,q))

QNq - QNq'








