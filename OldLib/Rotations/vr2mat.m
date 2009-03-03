% RV2MAT rotation vector to rotation matrix
%   Converts a rotation vector to a rotation matrix
%   Uses Rodrigues' formula
%   Vector norm is the amount of the rotation


function R = rv2mat(v);

th = sqrt(v(1)^2+v(2)^2+v(3)^2);	% angle of rotation

v = v/th;	% normalized vector

R = eye(3);
w = [[0 -v(3) v(2)];[v(3) 0 -v(1)];[-v(2) v(1) 0]];
R = R + sin(th).*w + (1-cos(th)).*w*w;

