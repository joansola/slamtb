function a = pluckerAngle(L)

n = L(1:3);
v = L(4:6);

a = atan(norm(cross(v,n))/dot(v,n));
