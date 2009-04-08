function [X,Y,Z] = cov3elli(x,P,ns,NP)

% COV3ELLI  3D ellipsoid from Gaussian mean and covariance.
%   [X,Y,Z] = COV3ELLI(x0,P,ns,NP) gives X, Y and Z coordinates of the
%   points corresponding to the 2 biggest semi-diametres of the ellipsoid
%   defined by the covariances matrix P and centered at x0:
%
%        (x-x0)'*(P^-1)*(x-x0) = ns^2.
%
%   The ellipsoid can be plotted in a 3D graphic by just creating a line
%   with line(X,Y,Z).
%
%   See also COV2ELLI, IDP3ELLI, LINE.

persistent circle

% Basic shape: 2 circles at 90 degrees, with the pole at the major axis X.
if isempty(circle)
    alpha = 2*pi/NP*(0:NP);
    circle = [...
        cos(alpha)    cos(alpha)
        sin(alpha)    zeros(1,NP+1)
        zeros(1,NP+1) sin(alpha)];
end

% Rotation R and semi-diameters d, obtained from P
[R,D] = svd(P);
d     = sqrt(D);

% circle -> aligned ellipse -> rotated ellipse -> ns-ellipse
ellip = ns*R*d*circle;

% output ready for plotting (X, Y and Z line vectors), offset by x
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
Z = x(3)+ellip(3,:);

