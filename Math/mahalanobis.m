function MD = mahalanobis(x,m,P)

% MAHALANOBIS  Mahalanobis distance
%   MD = MAHALANOBIS(X,M,P) computes the Mahalanobis distance from a point
%   X to a Gaussian of mean M and covariance P:
%
%   MD = sqrt((X-M)'*inv(P)*(X-M));
%
%   See also NEES.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

MD = sqrt((x-m)'/P*(x-m));











