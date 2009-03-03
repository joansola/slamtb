function [x,P] = eupdate(x,P,h,y,R,varargin)

% EUPDATE Update step of EKF
%   [X,P] = EUPDATE(X,P,@h,Y,R) performs the EKF update when the following
%   nonlinear measurement arrives:
%
%       Y = h(x) + v
%
%   where 
%       v is a white Gaussian noise with covariance R
%       {X,P} is the current Gaussian estimate of x
%       h is the measurement function. It must be defined so that 
%           [e,H] = h(x) gives the output e and the Jacobian H wrt x.
%
%   EUPDATE(...,R,VARARGIN) allows entering additional parameters for the
%   function h(), i.e., h(X,VARARGIN{:}).
%
%   See also KPREDICT, KUPDATE, DEUPDATE, EPREDICT, VO

[e,H] = h(x,varargin{:});

z = y-e;
Z = H*P*H' + R;
K = P*H'/Z;

x = x + K*z;
P = P - K*Z*K';
