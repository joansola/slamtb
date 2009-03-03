function [z,Z,iZ] = blockInnovation(r1,r2,H1,H2,Obs,ye)

% BLOCKINNOVATION Innovation for a block system
%   [z,Z] = BLOCKINNOVATION(r1,r2,H1,H2,OBS,YE) returns
%   innovation statistics for a block defined system, where:
%
%   r1 and r2 are the block ranges of the state vector
%   included in the global Map.
%   Map is a global structure containing
%     X: mean
%     P: covariances matrix
%   OBS is the observation containing
%     y: measurement
%     R: noise covariances matrix
%   H1 and H2 are the Jacobians of the observation function
%          OBS.y = h(x1,x2) + v
%     with respect to x1 and x2, evaluated at the means 
%     X(r1) and X(r2) respectively, where v~N(0,OBS.R).
%   YE is the expectation given by:  YE = h(X(R1),X(R2))
%
%   [z,Z,iZ] = BLOCKINNOVATION(...) returns also the inverse
%   of the innovation's covariance.
%
%   See also INNOVATION, LIKELIHOOD, BLOCKLIKELIHOOD

global Map

H = [H1 H2];
P = Map.P([r1 r2],[r1 r2]);

[z,Z,iZ] = innovation(P,Obs.y,H,Obs.R,ye);

