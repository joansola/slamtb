function Xi = q2Xi(q)

% Q2XI  Quaternion to Xi matrix transform
%   Q2XI(Q) returns the matrix Xi associated to the quaternion Q. This
%   matrix is defined as
%
%       Xi = [     -v'           ]
%            [ w*eye(3) - hat(v) ]
%
%   where Q = [ w ; v ]
%
%   The matrix Xi is the right-hand partition of the matrix Qn = q2Qn(q),
%   that is,
%
%       Qn = [q Xi].
%
%   See also quaternion, q2Psi, q2Qn, qProd.

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC

w = q(1);
v = q(2:4);

Xi = [-v' ; w*eye(3)-hat(v)];
