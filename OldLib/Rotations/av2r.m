function r = av2r(a,v)

% WARNING Deprecated. Use AU2V instead.
%
% AV2R  Rotation axis and angle to rotation vector conversion 
%   AV2R(ALPHA,V) converts the axis unity vector V and the 
%   rotated angle ALPHA into the rotation vector R

r = au2v(a,v);
