function T = Rt2H(R,t)
% RT2H Rotation and translation to homogeneous matrix
%   H=RT2H(R,T) builds homogeneous matrix H from  
%   rotation matrix R and translation vector T.
%   H transforms an homogeneous  vector in world frame
%   to a vector in body frame. 
%   R is the rotation matrix body-to-world.
%   T is the position of the body frame in the world.

T = [R' -R'*t;0 0 0 1];
