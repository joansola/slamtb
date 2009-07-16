function [e1, e2, E1_l, E2_l] = idpLinEndpoints(l,t1,t2)

[s, S_l] = idpLin2seg(l);

p1 = s(1:3);
p2 = s(4:6);

P1_l = S_l(1:3,:);
P2_l = S_l(4:6,:);

e1 = (1-t1)*p1 + t1*p2;
e2 = (1-t2)*p1 + t2*p2;

E1_p1 = 1-t1;
E1_p2 = t1;
E2_p1 = 1-t2;
E2_p2 = t2;

E1_l = E1_p1*P1_l + E1_p2*P2_l;
E2_l = E2_p1*P1_l + E2_p2*P2_l;
