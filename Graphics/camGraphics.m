function c = camGraphics(csize)

% CAMGRAPHICS  creates a camera graphics 3D object
%
%   CAMGRAPHICS creates a solid representing a camera
%   The objective is heading towards camera principal axis
%   and is located at camera position. Initial configuration
%   is: position at origin and principal axis aligned with
%   world's Z axis.
%
%   CAMGRAPHICS(SIZE) allows for choosing the camera size.
%   Default is 0.1

if nargin == 0
    csize = 0.1;
end


r = .3;
f = .5;
h = .8;
w = 1;
d = .3;

a = (0:pi/4:2*pi-pi/4)';
na = length(a);
circle = r*[cos(a),sin(a)];
rect = [1 1;-1 1;-1 -1;1 -1]*diag([w h])/2;

objective = [circle,zeros(na,1);circle,f*ones(na,1)];

body = [rect,zeros(4,1);rect,-d*ones(4,1)];

vert0 = [body;objective];

c.vert0 = csize*vert0;
c.vert  = c.vert0;
c.faces = [ ...
    01 02 03 04
    05 06 07 08
    01 02 06 05
    02 03 07 06
    03 04 08 07
    04 01 05 08
    09 10 18 17
    10 11 19 18
    11 12 20 19
    12 13 21 20
    13 14 22 21
    14 15 23 22
    15 16 24 23
    16 09 17 24];

% x = c.vert(:,1)';
% y = c.vert(:,2)';
% 
% c.X = x(c.faces);
% c.Y = y(c.faces);
