function [q,Qa,Qu] = au2q(a,u)
% AU2Q  Rotated angle and rotation axis vector to quaternion.
%   Q = AU2Q(A,U) gives the quaternion representing a rotation
%   of A rad around the axis defined by the unit vector U.
%
%   [Q,Qa,Qu] = AU2Q(...) returns the Jacobians wrt A and U.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

q = [  cos(a/2)
    u*sin(a/2)];

if nargout > 1

    Qa = [-sin(a/2)/2
        u*cos(a/2)/2];

    Qu = [0 0 0;eye(3)*sin(a/2)];

end