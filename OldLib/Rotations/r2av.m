function [a,v] = r2av(r)

% R2AV  Rotation vector to rotation axis and angle conversion 
%   [ALPHA,V] = R2AV(RV) converts the rotation vector R into tis
%   equivalent axis unity vector V and the rotated angle ALPHA
% 
% WARNING: This function has changed name. Use V2AU instead

warning('This function has changed name. Use v2au instead')

[a,v] = v2au(r);
