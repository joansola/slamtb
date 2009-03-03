function P=quat2pi(quat)

% PI = QUAT2PI(QUAT) Jacobian submatrix PI from quaternion
%
%   where:  QUAT = [a b c d]' represents the attitude quaternion QUAT
%           W = [p q r]' is the angular rates vector
%   and:    OMEGA = W2OMEGA(W) is a skew symetric matrix 
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

if (size(quat) == [4 1])
    if(abs(norm(quat)-1) < 1e-3)
    
        a=quat(1);
        b=quat(2);
        c=quat(3);
        d=quat(4);
        
        P = [-b -c -d
              a -d  c
              d  a -b
             -c  b  a];
    else
        error('Input quaternion is not a unity vector')
    end
else
    error('Input dimensions don''t agree. Enter 4x1 column vector')
end
