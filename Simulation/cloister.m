function f = cloister(xmin,xmax,ymin,ymax,n)

% CLOISTER  Generates features in a 2D cloister shape.
%   CLOISTER(XMIN,XMAX,YMIN,YMAX,N) generates a 2D cloister in the limits
%   indicated as parameters. 
%
%   N is the number of rows and columns; it defaults to N = 9.
%
%   See also THICKCLOISTER.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin < 5
    n = 9;
end

% Center of cloister
x0 = (xmin+xmax)/2;
y0 = (ymin+ymax)/2;

% Size of cloister
hsize = xmax-xmin;
vsize = ymax-ymin;
tsize = diag([hsize vsize]);

% Integer ordinates of points
outer = (-(n-3)/2 : (n-3)/2);
inner = (-(n-3)/2 : (n-5)/2);

% Outer north coordinates
No = [outer; (n-1)/2*ones(1,numel(outer))];
% Inner north
Ni = [inner ; (n-3)/2*ones(1,numel(inner))];
% East (rotate 90 degrees the North points)
E = [0 -1;1 0] * [No Ni];
% South and West are negatives of N and E respectively.
points = [No Ni E -No -Ni -E];

% Rescale
f = tsize*points/(n-1);

% Move
f(1,:) = f(1,:) + x0;
f(2,:) = f(2,:) + y0;

