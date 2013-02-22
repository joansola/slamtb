function r = XZRectangle(x1,x2,y,z1,z2)

% XZRECTANGLE  Rectangle in the XZ plane.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

s1 = xSegment(x1,x2,y,z1);
s2 = zSegment(x2,y,z1,z2);
s3 = xSegment(x2,x1,y,z2);
s4 = zSegment(x1,y,z2,z1);

r = [s1 s2 s3 s4];









