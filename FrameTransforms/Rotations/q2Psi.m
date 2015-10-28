function Psi = q2Psi(q)

% Q2PSI  Quaternion to Psi matrix transform
%   Q2PSI(Q) returns the matrix Psi associated to the quaternion Q. This
%   matrix is defined as
%
%       Psi = [     -v'           ]
%             [ w*eye(3) + hat(v) ]
%
%   where Q = [ w ; v ]
%
%   The matrix Psi is the right-hand partition of the matrix Q = q2Q(q),
%   that is,
%
%       Q = [q Psi].
%
%   Note: This function is absolutely equivalent to q2Pi.
%
%   See also quaternion, q2Xi, q2Q, qProd, q2Pi.

% Copyright 2015 Joan Sola @ IRI-UPC-CSIC

w = q(1);
v = q(2:4);

Psi = [-v' ; w*eye(3)+hat(v)];
