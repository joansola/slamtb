function p = lines2point(La,Lb)

% LINES2POINT Intersection point of 2 Plucker lines. Result in Homogeneous.

na = La(1:3);
nb = Lb(1:3);
vb = Lb(4:6);

p = [cross(na,nb);dot(na,vb)];
