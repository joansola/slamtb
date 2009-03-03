function s = zSegment(x,y,z1,z2)

% ZSEGMENT   Vertical segment
%   ZSEGMENT(X,Y,Z1,Z2) makes a vertical segment at the plane
%   location (X,Y) from altitude Z1 to altitude Z2.

s = [x;y;z1;x;y;z2];


