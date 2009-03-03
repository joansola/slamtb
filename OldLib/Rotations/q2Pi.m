function Pi = q2Pi(q)

% Q2PI  Pi matrix construction from quaternion
%   PI = Q2PI(Q) Jacobian submatrix PI from quaternion
%
%   where:  Q = [a b c d]' is the attitude quaternion QUAT
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
%   is the Jacobian of OMEGA*Q with respect to W
%
%   See also W2OMEGA, Q2R
    

Pi = [-q(2) -q(3) -q(4)
       q(1) -q(4)  q(3)
       q(4)  q(1) -q(2)
      -q(3)  q(2)  q(1)];
