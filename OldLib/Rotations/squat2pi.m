function P=squat2pi(quat)

% SQUAT2PI  Pi matrix construction from quaternion
%   PI = SQUAT2PI(QUAT) Jacobian submatrix PI from quaternion
%
%   where:  QUAT = [a b c d]' is the attitude quaternion QUAT
%           W = [p q r]' is the angular rates vector
%           OMEGA = W2OMEGA(W) is a skew symetric matrix 
%
%   the the output matrix:
%
%                |-b -c -d |
%           PI = | a -d  c |  
%                | d  a -b |
%                |-c  b  a |  
% 
%   is the Jacobian of OMEGA*QUAT with respect to W
%
%   See also W2OMEGA, QUAT2COS
    

warning('This function is being deprecated. Use q2Pi instead.')

P = [-quat(2) -quat(3) -quat(4)
      quat(1) -quat(4)  quat(3)
      quat(4)  quat(1) -quat(2)
     -quat(3)  quat(2)  quat(1)];
