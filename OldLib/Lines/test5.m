clc


rs = deg2rad([5 0 90]);
sc = deg2rad([-90 0 -90]);
rc = R2e(e2R(rs)*e2R(sc))

ct  = [0;0;1.5];
ce  = rc;
k   = [240;240;300;300];
b   = [0.001;0.001];

Re  = diag([1 1 0]);
B   = eye(2)/4;

% INIT
% robot pose
rt  = [.100536;.000706;0];
re  = [0;0;0.0140492];
Pr  = [[1.00534e-05,7.00785e-08,0,-1.08146e-08,0,0];[7.00785e-08,7.78838e-08,0,1.5395e-06,0,0];[0,0,1.00539e-05,0,0,0];[-1.08146e-08,1.5395e-06,0,3.06258e-05,0,0];[0,0,0,0,3.06258e-07,0];[0,0,0,0,0,3.06258e-07]];

% segment
e1  = [480.825;250.56;1];
e2  = [444.402;273.768;1];
[h,He1,He2] = pp2hm(e1,e2);     % Homogeneous coordinates
Rh = He1*Re*He1' + He2*Re*He2';
[q,Qh] = hm2rt(h);               % Polar coordinates
q;
Rq = Qh*Rh*Qh'

[h,Hq] = rt2hm(q);
Rh = Hq*Rq*Hq';

% line in robot frame
[Lr,LRct,LRce,LRk,LRh,LRb] = retroProjectPluckerEuler(ct,ce,k,h,b);
Plr = LRh*Rh*LRh' + LRb*B*LRb';
Lr;

% in world frame
[L,Lrt,Lre,Llr] = fromFramePluckerEuler(rt,re,Lr);
L;
Pl = [Lrt Lre]*Pr*[Lrt Lre]' + Llr*Plr*Llr';
Cl = [Lrt Lre]*Pr;

% propagar jacobians



% OBS
% robot pose
rt  = [];
re  = [];
Pr  = []
Cr  = []

% measurement
e1 = [1];
e2 = [1];
[h,He1,He2]  = pp2hm(e1,e2);
Rh = He1*Re*He1' + He1*Re*He1';
[q,Qh]  = hm2rt(h)
Rq = Qh*Rh*Qh';

% line in robot frame
[Lr,LRrt,LRre,LRl] = toFramePluckerEuler(rt,re,L);
Plr = [LRrt LRre]*Pr*[LRrt LRre]' + LRl*Pl*LRl';

% line projection
[h,Hct,Hce,Hk,Hlr] = projectPluckerEuler(ct,ce,k,Lr);
Ph = Hlr*Plr*Hlr';

% precidtion in measurement space
[q,Qh]  = hm2rt(h)
Eq = Qh*Rh*Qh';

% innovation
Zq = Eq + Rq

