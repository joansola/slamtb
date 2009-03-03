%% SYM DEF
syms A1 A2 A3 A4 B1 B2 B3 B4 x y z rl pt yw u0 v0 au av real
syms a1 a2 a3 b1 b2 b3 real
t = [x;y;z];
e = [rl;pt;yw];
q = e2q(e);
R = e2R(e);
C = [t;q];
A = [A1;A2;A3;A4];
B = [B1;B2;B3;B4];

K = [au 0 u0;0 av v0;0 0 1];
aa = [a1;a2;a3];
bb = [b1;b2;b3];

%% NUM DEF
t = [1;2;3];
e = [1;2;3];
q = e2q(e);
R = e2R(e);
C = [t;q];
A = [5;4;3;1];
B = [3;5;2;1];
au=2; av=3; u0=1; v0=0;
K = [au 0 u0;0 av v0;0 0 1];
aa = [2;3;1];
bb = [1;2;1];


%% compare toFrame in 3d
L  = points2plucker(A,B)
Lc1 = toFramePlucker(C,L)
Ac2 = [toFrame(C,A(1:3)/A(4));1]
Bc2 = [toFrame(C,B(1:3)/B(4));1]
Lc2 = points2plucker(Ac2,Bc2)

%% compare fromFrame in 3d
L1 = fromFramePlucker(C,Lc1)
A3 = [fromFrame(C,Ac2(1:3)/Ac2(4));1]
B3 = [fromFrame(C,Bc2(1:3)/Bc2(4));1]
L2 = points2plucker(A3,B3)

