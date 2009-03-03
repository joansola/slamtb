function blockPredict(r,Fr,Fu,U)

% BLOCKPREDICT Block prediction step for EKF
%   BLOCKPREDICT(r,Fr,Fu,U) performs a prediction step
%   on the global Map of a system where
%   the dynamic part is restricted to a range r of
%   the state vector and all other components are static.
%     Map is a global structure with
%       X: the state vector.
%       P: the covariances matrix
%     r is the range of the dynamic block
%     Fr and Fu are the jacobians of the evolution function:
%            X(r)+ = f(X(r),u)
%     with respect to X(r) and u respectively.
%     u is the perturbation (noisy controls).
%     U is the covariances matrix of the perturbation u.
%
%   See also BLOCKUPDATE, BLOCKUPDATEINN

global Map

m = [1:r(1)-1 r(end)+1:Map.m]; % off block range

Map.P(r,m) = Fr*Map.P(r,m); % cross variances
Map.P(m,r) = Map.P(r,m)';
Map.P(r,r) = Fr*Map.P(r,r)*Fr' + Fu*U*Fu'; % covariance

