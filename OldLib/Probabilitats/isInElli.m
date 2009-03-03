function ins = isInElli(x,xm,P,ns)

% ISINSIDE  Check if point is inside an ellipse
%   ISINSIDE(X,XM,P,NS) is true if X is inside the NS sigma
%   bound of the ellipse defined by mean XM and
%   covariances matrix P.
%
%   See also ISINRAY

ins = ((x-xm)'*P^-1*(x-xm) < ns^2);
