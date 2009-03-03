function [s,S1,S2] = planes2sin(n1,n2)

[u1,U1] = normvec(n1);
[u2,U2] = normvec(n2);
[n,Nu1,Nu2] = txp(u1,u2);

[s,Sn] = vecnorm(n);

S1 = Sn*Nu1*U1;
S2 = Sn*Nu2*U2;
