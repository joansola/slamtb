function Q = q2Q(q)

% Q2Q  Quaternion to quaternion matrix conversion.
%   Q = Q2Q(q) gives the matrix Q so that the quaternion product
%   q1 x q2 is equivalent to the matrix product:
%
%       q1 x q2 == q2Q(q1) * q2
%
%   If q = [a b c d]' this matrix is
%
%       Q = [ a -b -c -d
%             b  a -d  c
%             c  d  a -b
%             d -c  b  a ];
%
%   See also QUATERNION, R2Q, Q2E, Q2V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


Q = [ q(1) -q(2) -q(3) -q(4)
      q(2)  q(1) -q(4)  q(3)
      q(3)  q(4)  q(1) -q(2)
      q(4) -q(3)  q(2)  q(1) ];
  








