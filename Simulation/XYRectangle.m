function r = XYRectangle(x1,x2,y1,y2,z)

% XYRECTANGLE  Rectangle in the XY plane.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


s1 = xSegment(x1,x2,y1,z);
s2 = ySegment(x2,y1,y2,z);
s3 = xSegment(x2,x1,y2,z);
s4 = ySegment(x1,y2,y1,z);

r = [s1 s2 s3 s4];









