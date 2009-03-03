function [T,iT] = pose2transform(p,oriType)
% POSE2TRANSFORM Pose to homogeneous transformation
%   [T,iT] = POSE2TRANSFORM(P) transforms pose P to homogeneous T and its
%   inverse iT. Pose P is [x y z roll pitch yaw]' or [x y z a b c d]'.
%
%   [T,iT] = POSE2TRANSFORM(P,ORITYPE) allows the specification of the
%   orientation representation for the pose vector. Possible values of
%   ORITYPE are:
%     'e' for Euler angles, this is the default value;
%     'q' for quaternion; and
%     'v' for rotation vector.

p = p(:); % make column vector
t = p(1:3);

if nargin < 2, oriType = 'e'; end

switch oriType
    case 'e'
        R = e2R(p(4:6));
    case 'q'
        R = q2R(p(4:7));
    case 'v'
        R = v2R(p(4:6));
    otherwise
        error('Bad orientation specification')
end

T = [R t;0 0 0 1];

if nargout > 1
    iT = [R' -R'*t;0 0 0 1];
end
