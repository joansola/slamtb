function [P,X] = KalmanPredict(T,P,X,F,Q,G)

% KALMANPREDICT  time prediciton step for Kalman Filter
%
%   For a system model:
%
%   x+ = F*x + w
%
%   with X = E{x}
%        P = E{(x-X)(x-X)'}
%        Q = E{ww'}
%
%   [P,X] = KALMANPREDICT(T,P,X,F,Q) realizes a time
%   update of state vector statistics X and P from system
%   model matrix F, system noise Q and sample time T.
%
%   [P,X] = KALMANPREDICT(T,P,X,F,Q,G) accounts for models
%   where system noise matrix G is given as in x+ = F*x + G*w
%
%   Use P = KALMANPREDICT(...) to skip state vector update
%   and allow operation for non linear systems, where:
%
%   x+ = f(x) + w
% 
%   with F : the jacobian of f(x) at point X.
%
%
%   See also KALMANCORRECT

switch nargin
case 5
    P = F*P*F' + Q;
case 6
    P = F*P*F' + G*Q*G';
otherwise
    error('Not enough input arguments')
end

if nargout == 2
    X = F*X;
end
