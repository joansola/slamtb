function [X,Y,Z] = idp3elli(idp,IDP,ns,NP)

%IDP3ELLI 3D ellipsoid from Gaussian IDP.
%   [X,Y,Z] = IDP3ELLI(x0,P,ns,NP) gives X, Y and Z coordinates of the
%   points corresponding to the 2 biggest semi-diametres of the ellipsoid
%   defined by the covariances matrix P and centered at x0:
%
%        (x-x0)'*(P^-1)*(x-x0) = ns^2.
%
%   where P and x0 are obtained by transforming the input inverse-depth
%   point idp and covariance IDP to an euclidean point:
%
%       x0 = idp2p(idp)
%       P = J*IDP*J'
%
%   being J the Jacobian of the conversion function. This conversion is
%   performed internally by the function PROPAGATEUNCERTAINTY.
%
%   The ellipsoid can be plotted in a 3D graphic by just creating a line
%   with line(X,Y,Z).
%
%   See also COV3ELLI, LINE, IDP2P, PROPAGATEUNCERTAINTY.


[p,P] = propagateUncertainty(idp,IDP,@idp2p);

[X,Y,Z] = cov3elli(p,P,ns,NP);


