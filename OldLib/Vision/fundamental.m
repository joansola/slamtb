function F = fundamental(K1,K2,t,R)

% FUNDAMENTAL  Fundamental matrix.
%   FUNDAMENTAL(K1,K2,T,R) is the fundamental matrix:
%
%     F = inv(K2')*ESSENTIAL(t,R)*inv(K1)
%
%   where:
%     K1,K2 are the 3x3 projection matrices of cameras 1 and 2.
%     T,R   are the translation vector and rotation matrix defining the
%           pose of camera 1 with respect to camera 2.
%
%  See also ESSENTIAL, EPILINE.

F = inv(K2')*essential(t,R)*inv(K1);