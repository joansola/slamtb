% Lines
syms e1x e1y e2x e2y b1 b2 real
e1    = [e1x;e1y;1];
e2    = [e2x;e2y;1];
beta  = [b1;b2];

% Camera
syms x y z a b c d real
t = [x;y;z];
q = [a;b;c;d];
t1 = [0;0;0];
q1 = [1;0;0;0];
C1 = [t1;q1];
t2 = [x;y;z];
q2 = [1;0;0;0];
C2 = [t2;q1];
k = [0;0;1;1]; % canonical camera

% [h,He1,He2]         = pp2hm(e1,e2);

h = [1;1;0];
[L,Lc1,Lk,Lh,Lbeta] = retroProjectPlucker(C1,k,h,beta);
[y,Yc2,Yk,Yl]       = projectPlucker(C2,k,L);

% Innovations
