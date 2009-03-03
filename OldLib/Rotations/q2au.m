function [a,u] = q2au(q)

% Q2AU quaternion to rotated angle and rotation axis vector
%   [A,U] = Q2AU(Q) gives the rotation of A rad around the axis
%   defined by the unity vector U, that is equivalent to that
%   defined by the quaternion Q

u = q(2:4);
u = u/norm(u);

a = 2*acos(q(1));
