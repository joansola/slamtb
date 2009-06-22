function s = ySegment(x,y1,y2,z)

% XSEGMENT   Horizontal segment in the X direction
%   XSEGMENT(X,Y1,Y2,Z) makes an horizontal segment at the plane
%   location (X,Z) from widths Y1 to Y2.

s = [x;y1;z;x;y2;z];


