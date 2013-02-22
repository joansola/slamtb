function r = YZRectangle(x,y1,y2,z1,z2)

%YZRECTANGLE Rectangle in the YZ plane.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


s1 = ySegment(x,y1,y2,z1);
s2 = zSegment(x,y2,z1,z2);
s3 = ySegment(x,y2,y1,z2);
s4 = zSegment(x,y1,z2,z1);

r = [s1 s2 s3 s4];









