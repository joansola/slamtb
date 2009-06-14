function a = apluckerAngle(L)

n = L(4:6);
v = L(7:9);

a = atan(norm(cross(v,n))/dot(v,n));
