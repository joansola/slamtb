function p = points3plane(a,b,c)

% POINTS3PLANE  Plane from 3 Euclidean points

n = cross(b-a,c-a); % normal vector
d = -n'*a;          % homogeneous component
p = [n;d];

return


%%
A = randn(4,1);
B = randn(4,1);
C = randn(4,1);
D = randn(4,1);

a = hm2eu(A);
b = hm2eu(B);
c = hm2eu(C);
d = hm2eu(D);

P1 = points3plane(a,b,c);
P2 = points3plane(a,b,d);

L1 = points2plucker(A,B)

L2 = planes2plucker(P1,P2)

L2./L1
