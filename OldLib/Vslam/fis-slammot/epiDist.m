function [d,u1,u2] = epiDist(vRay,y)

% EPIDIST  Distance to epipolar of virtual ray
%   D = EPIDIST(VRAY,Y) computes the distance in pixels from the
%   pixel Y to the VRAY epipolar line, ie. the line joining both
%   VRAY centers.
%
%   [D,U1,U2] = EPIDIST(...) gives also the two ellipse centers
%   defining the epipolar line

u1      = vRay.Prj(2).u(:,1); % nearby member on cam 2
u2      = vRay.Prj(2).u(:,2); % vanishing point on cam 2
y2      = vRay.Prj(2).y;      % measured pix on cam 2
a       = y2 - u1;
b       = u2 - u1;
na      = norm(a);
cosa    = a'*b/na/norm(b);
sina    = sqrt(1-cosa^2);
d       = na*sina; % this is the distance
