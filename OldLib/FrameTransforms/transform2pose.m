function p = transform2pose(T,oriType)

% TRANSFORM2POSE  Convert transformation matrix to pose vector
%   P = TRANSFORM2POSE(T) computes the pose vector P=[X;E], where X is a 3D
%   point and E is a vector of the three Euler angles [roll;pitch;yaw],
%   corresponding to the homogeneous transformation matrix T=[R t;0 1].
%
%   P = ...(T,ORITYPE) allows the specification of the orientation
%   representation for the pose vector. Possible values of ORITYPE are:
%     'e' for Euler angles, this is the default value;
%     'q' for quaternion; and 
%     'v' for rotation vector.

if nargin == 1, oriType = 'e'; end

switch oriType
    case {'e','E','euler','Euler'}
        p = [T(1:3,4);R2e(T(1:3,1:3))];
    case {'q','Q','quat','quaternion'}
        p = [T(1:3,4);R2q(T(1:3,1:3))];
    case {'v','V','rot','vec'}
        p = [T(1:3,4);R2v(T(1:3,1:3))];
    otherwise
        error('Bad orientation specifier.')
end
