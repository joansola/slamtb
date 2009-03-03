function v = au2v(a,u)

% AU2V  Rotation axis and angle to rotation vector conversion 
%   AU2V(ALPHA,U) converts the axis unity vector U and the 
%   rotated angle ALPHA into the rotation vector V

v = a*u/norm(u);
