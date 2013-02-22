function N = nees(x,m,P)

% NEES  Normalized Estimation Error Squared.
%   N = NEES(X,M,P) computes the Normalized Estimation Error Squared given
%   true state X and a Gaussian estimate of mean M and covariance P:
%
%       NEES = (X-M)'*inv(P)*(X-M);
%
%   See also MAHALANOBIS.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

N = (x-m)'/P*(x-m);











