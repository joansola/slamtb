function [X,Y,Z] = cov3elli(x,P,ns,NP)

% COV3ELLI build 3D ellipsoid
%   [X,Y,Z] = COV3ELLI(x0,P,ns,NP) calculates the points corresponding to
%   the 2 biggest semi-diametres of the ellipsoid defined by the
%   covariances matrix P and centered at x0:
%
%        (x-x0)'*(P^-1)*(x-x0) = ns^2.

persistent cercle

if isempty(cercle)
    alpha = 2*pi/NP*(0:NP);
    cercle = [cos(alpha)    cos(alpha)
              sin(alpha)    zeros(1,NP+1)
              zeros(1,NP+1) sin(alpha)];
end


[U,D] = svd(P);
d     = sqrt(D);

ellip = ns*U*d*cercle;
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
Z = x(3)+ellip(3,:);

