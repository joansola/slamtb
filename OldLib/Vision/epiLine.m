function l2 = epiLine(x1,K1,K2,t,R)

% EPILINE  Epipolar line
%   Given two view uncalibrated geometry, where K1, K2 are the
%   calibration matrices of cameras 1 and 2, T,R are the translation
%   vector and rotation matrix of camera 1 wrt camera 2, and x1
%   is the projection of an unknown point in 3D space into the
%   camera 1, then the line L2 given by:
%
%   L2 = EPILINE(X1,K1,K2,T,R)
%
%   is the epipolar line of X1 in the image plane of camera 2.
%
%   See also FUNDAMENTAL, ESSENTIAL, HAT, TOFRAME, FROMFRAME.

l2 = fundamental(K1,K2,t,R)*x1;
