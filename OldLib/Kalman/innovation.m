function [z,Z,iZ] = innovation(P,y,H,R,ye)

% INNOVATION  Innovation of an observation
%   [z,Z] = INNOVATION(P,Y,H,R,YE) computes innovation
%   and innovation's covariances matrix as
%
%     z = Y - YE
%     Z = H*P*H' + R
%
%   where
%     P is the covariances matrix of the random state X
%     Y is the current observation of X
%     H is the jacobian of the observation function Y=h(X)
%     R is the covariances matrix of the observation noise
%     YE is the expectation of Y: YE = h(XE) with XE=E(X)
%
%   [z,Z,iZ] = INNOVATION(...) returns also the
%   inverse of the innovation covariance

z    = y-ye;

HPHt = H*P*H';
Z    = HPHt + R;
if nargout == 3
    iZ = inv(Z);
end

