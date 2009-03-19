function MD = mahalanobis(x,m,P)

% MAHALANOBIS  Mahalanobis distance
%   MD = MAHALANOBIS(X,M,P) computes the Mahalanobis distance from a point
%   X to a Gaussian of mean M and covariance P:
%
%   MD = sqrt((X-M)'*inv(P)*(X-M));
%
%   (c) Joan Sola 2008

MD = sqrt((x-m)'*inv(P)*(x-m));


