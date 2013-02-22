function c = camSimpleGraphics(csize)

%CAMSIMPLEGRAPHICS Create a simple camera graphics 3D object.
%   CAMGRAPHICS creates a solid representing a camera. The objective is
%   heading towards the camera optical axis and is located at camera
%   position. Initial configuration is: position at origin and optical
%   axis aligned with world's Z axis.
%
%   This function creates an object much simpler (with much less vertices)
%   than CAMGRAPHICS, with the aim of accelerating rendering.
%
%   The result is a structure with fields:
%       .vert0  the vertices in camera frame.
%       .vert   the vertices in world frame.
%       .faces  the definition of faces.
%
%   Fields .vert and .faces are used to draw the object via the PATCH
%   command. Further object repositionning is accomplished with DRAWOBJECT.
%
%   CAMSIMPLEGRAPHICS(SIZE) allows for choosing the camera size. Default is 0.1.
%
%   See also CAMGRAPHICS, PATCH, SET, DRAWOBJECT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargin == 0
    csize = 0.1;
end


h = .8; % body height
w = 1;  % body width
t = .3; % body thickness

% body vertices
rect      = [1 1;-1 1;-1 -1;1 -1]*diag([w h])/2;
body      = [rect,zeros(4,1);rect,-t*ones(4,1)];

% vertices in camera frame
vert0     = body;

% graphics structure - vertices and faces
c.vert0   = csize*vert0;
c.vert    = c.vert0;
c.faces   = [ ...
    01 02 03 04
    05 06 07 08
    01 02 06 05
    02 03 07 06
    03 04 08 07
    04 01 05 08];









