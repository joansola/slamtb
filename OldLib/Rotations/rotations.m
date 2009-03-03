% ROTATIONS  Library for 3D rotation conversions
%
% Euler angles, quaternions, rotation matrices and rotation vectors
% are supported, but not fully supported.
%
% Conversions between Euler <-> Rotation matrix <-> quaternion
% are fully supported, but :
%
% ===   WARNING !!!   ===
%
% IF INPUT EULER ANGLES ARE NOT RESTRICTED TO
%
%     -PI < ROLL  < PI
%   -PI/2 < PITCH < PI/2
%     -PI < YAW   < PI
%
% RESULTS MAY BE ABSOLUTELY USELESS !!!
%
% =======================