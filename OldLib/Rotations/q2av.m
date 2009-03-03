function [a,v] = q2av(q)

% WARNING Deprecated. Use Q2AU instead.
%
% Q2AV quaternion to rotated angle and rotation axis vector
%   [A,V] = Q2AV(Q) gives the rotation of A rad around the axis
%   defined by the unity vector V, that is equivalent to that
%   defined by the quaternion Q

[a,v] = q2au(q);