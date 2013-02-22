function [q,Qq1,Qq2] = qProd(q1,q2)

% QPROD Quaternion product.
%   QPROD(Q1,Q2) is the quaternion product Q1 * Q2
%
%   [Q,Qq1,Qq2] = QPROD(...) gives the Jacobians wrt Q1 and Q2.
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


[a,b,c,d] = split(q1);
[w,x,y,z] = split(q2);

q = [...
    a*w - b*x - c*y - d*z
    a*x + b*w + c*z - d*y
    a*y - b*z + c*w + d*x
    a*z + b*y - c*x + d*w];

if nargout > 1
    Qq1 = [...
        [  w, -x, -y, -z]
        [  x,  w,  z, -y]
        [  y, -z,  w,  x]
        [  z,  y, -x,  w]];

    Qq2 = [...
        [  a, -b, -c, -d]
        [  b,  a, -d,  c]
        [  c,  d,  a, -b]
        [  d, -c,  b,  a]];
end

return

%%
syms a b c d w x y z real
q1=[a b c d]';
q2 = [w x y z]';

[q,Qq1,Qq2] = qProd(q1,q2);

simplify(Qq1 - jacobian(q,q1))
simplify(Qq2 - jacobian(q,q2))









