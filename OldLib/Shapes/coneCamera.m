function c = coneCamera(csize)

% CONECAMERA  creates a camera graphics 3D object
%
%   CONECAMERA creates a solid representing a camera
%   The objective is heading towards camera principal axis
%   and is located at camera position. Initial configuration
%   is: position at origin and principal axis aligned with
%   world x axis.
%
%   CAMGRAPHICS(SIZE) allows for choosing the camera size.
%   Default is 0.1

if nargin == 0
    csize = 0.1;
end


f = .5;
h = .8;
w = 1;

rect = [1 1;-1 1;-1 -1;1 -1]*diag([w h])/2;

oc = [0 0 0]; % optical center
pp = [0;0;f]; % principal point
im = [rect,f*ones(4,1)]; % image plane

v0 = [oc;im];

c.vert0 = csize*v0;
c.vert  = c.vert0;
c.faces = [...
    1 2 3 1
    1 3 4 1
    1 4 4 1
    1 5 2 1
    2 3 4 5];
    