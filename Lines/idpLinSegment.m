function [seg, SEG_l] = idpLinSegment(l,t)

% abscissas
t1 = t(1);
t2 = t(2);

% support 3d segment
[s, S_l] = idpLin2seg(l);

% support points
p1 = s(1:3);
p2 = s(4:6);

P1_l = S_l(1:3,:);
P2_l = S_l(4:6,:);

% 3d endpoints
e1 = (1-t1)*p1 + t1*p2;
e2 = (1-t2)*p1 + t2*p2;

E1_p1 = 1-t1;
E1_p2 = t1;
E2_p1 = 1-t2;
E2_p2 = t2;

E1_l = E1_p1*P1_l + E1_p2*P2_l;
E2_l = E2_p1*P1_l + E2_p2*P2_l;

% 3d segment
seg   = [e1;e2];
SEG_l = [E1_l;E2_l];

