function a = pluckerAngle(L)

% PLUCKERANGLE  Angle between Plucker vectors.
%   PLUCKERANGLE(L) gives the angle between the two Plucker sub-vectors n
%   and v. The plucker line L is a 6-vector L = [n;v] with two 3-vectors n
%   and v. These vectors should be orthogonal in order for the vector L to
%   be a line.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

n = L(1:3);
v = L(4:6);

a = atan(norm(cross(v,n))/dot(v,n));
