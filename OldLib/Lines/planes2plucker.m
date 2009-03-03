function [L,Lp,Lq] = planes2plucker(P,Q)

% PLANES2PLUCKER  Plucker line as the intersection of two planes
%   L = PLANES2PLUCKER(P,Q) is the Plucker line that results from
%   intersecting the two planes P and Q. The planes are specified by their
%   homogeneous coordinates [a;b;c;d] so that ax+by+cz+d=0. The result is a
%   Plucker line expressed as a 6-vector.
%
%   [L,Lp,Lq] = ... returns the Jacobians wrt P and Q.
%
%   See also POINTS2PLUCKER.


L = [P(4)*Q(1:3)-Q(4)*P(1:3);cross(P(1:3),Q(1:3))];

if nargout > 1 % jac
    
    [px,py,pz,pw] = split(P);
    [qx,qy,qz,qw] = split(Q);

    Lp = [...
        [ -qw,   0,   0,  qx]
        [   0, -qw,   0,  qy]
        [   0,   0, -qw,  qz]
        [   0,  qz, -qy,   0]
        [ -qz,   0,  qx,   0]
        [  qy, -qx,   0,   0]];
    
    Lq = [...
        [  pw,   0,   0, -px]
        [   0,  pw,   0, -py]
        [   0,   0,  pw, -pz]
        [   0, -pz,  py,   0]
        [  pz,   0, -px,   0]
        [ -py,  px,   0,   0]];

end

return

%% jacobians
syms px py pz pw qx qy qz qw real
P = [px;py;pz;pw];
Q = [qx;qy;qz;qw];

%%
L = planes2plucker(P,Q)

Lp = jacobian(L,P)
Lq = jacobian(L,Q)

%%
[L,Lp,Lq] = planes2plucker(P,Q);

Lp - jacobian(L,P)
Lq - jacobian(L,Q)

%% Test planes2plucker and points2plucker

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

