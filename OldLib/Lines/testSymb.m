%%

syms a1 a2 a3 a4 b1 b2 b3 b4 p1 p2 p3 p4 q1 q2 q3 q4 real
A=[a1;a2;a3;a4];
B=[b1;b2;b3;b4];
P=[p1;p2;p3;p4];
Q=[q1;q2;q3;q4];

L1 = points2plucker(A,B)
L2 = planes2plucker(P,Q)

L1a = jacobian(L1,A)
L1b = jacobian(L1,B)
L2p = jacobian(L2,P)
L2q = jacobian(L2,Q)
