function [x,P] = kupdate(x,P,H,y,R)

% KUPDATE Update step of KF
%   [X,P] = KUPDATE(X,P,H,Y,R) performs the KF update when the following
%   nonlinear measurement arrives:
%
%       Y = H.x + v
%
%   where 
%       v is a white Gaussian noise with covariance R
%       {X,P} is the current Gaussian estimate of x
%       H is the measurement matrix.
%
%   See also EUPDATE, DEUPDATE, EPREDICT

z = y - H*x;
Z = H*P*H' + R;
K = P*H'/Z;

x = x + K*z;
P = P - K*Z*K';
