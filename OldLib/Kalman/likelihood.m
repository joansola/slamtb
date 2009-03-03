function [L,MD,Inn] = likelihood(P,y,H,R,ye)

% LIKELIHOOD Gets likelihood
%
% LIKELIHOOD(P,Y,H,R,YE) gets likelihood of hypothesis X
%   in YE = h(X) given measure Y = h(x)+v where x~(X,P)
%   and v~N(0,R)
%
% [L,MD] = LIKELIHOOD(...) gives also the Mahalanobis distance.
%
% [L,MD,INN] = LIKELIHOOD(...) gives also the innovation INN
%   INN is a structure:
%     z  = innovation
%     Z  = innovation's covariance
%     iZ = inverse of the covariance

[Inn.z,Inn.Z,Inn.iZ] = innovation(P,y,H,R,ye);

MD   = Inn.z'*Inn.iZ*Inn.z;

L    = exp(-MD/2)/sqrt(det(Inn.Z));
