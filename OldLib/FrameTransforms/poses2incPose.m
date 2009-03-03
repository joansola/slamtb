function p12 = poses2incPose(p1,p2,oriType)

% POSES2INCPOSE  Computes the incremental pose from two poses
%   P12 = POSES2INCPOSE(P1,P2) returns the pose chenge P12 to go from pose
%   P1 to pose P2, al expressed as Pi = [X;E] where X is a 3D point and
%   E=[roll,pitch,yaw] is the orientation in Euler angles.
%
%   P12 = POSES2INCPOSE(P1,P2,ORITYPE) allows the specification of the
%   orientation representation. Possible values are:
%     'e' for Euler angles, this is the default value;
%     'q' for quaternion; and 
%     'v' for rotation vector.

if nargin < 3
    oriType = 'e'; 
end

[TW1,iTW1] = pose2transform(p1,oriType);
TW2 = pose2transform(p2,oriType);
p12 = transform2pose(iTW1*TW2,oriType);
