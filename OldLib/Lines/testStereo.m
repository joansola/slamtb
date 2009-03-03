% stereo head
stHead.alpha = 118.78;
stHead.cal = [630.82;485.21;751.39;750.38]/2;

% stereo endpoints
uvds = [631.532,188.662,-20.4561,627.554,188.248,-20.312]';
R_uvds = diag([.25,.25,.25,.25,.25,.25]);
e1 = uvds(1:3);
e2 = uvds(4:6);

% left and right endpoints
e1L = e1(1:2);
e1R = e1(1:2) - [e1(3);0];
EL_e = [1 0 0;0 1 0];
ER_e = [1 0 -1;0 1 0];

e2L = e2(1:2);
e2R = e2(1:2) - [e2(3);0];

% left and right homogeneous
[hL,HL_e1,HL_e2] = pp2hm(e1L,e2L);
[hR,HR_e1,HR_e2] = pp2hm(e1R,e2R);
h  = [hL;hR];
H = [HL_e1 HL_e2;HR_e1 HR_e2];

% left and right rhotheta
[rtL,RTL_hl] = hm2rt(hL)
[rtR,RTR_hr] = hm2rt(hR)
RTRT_h = [RTL_hl zeros(2,3);zeros(2,3) RTR_hr];
RTRT_uvds = RTRT_h*H

[rtL,RTL_e1L,RTL_e2L] = points2rt(e1L,e2L);
[rtR,RTR_e1R,RTR_e2R] = points2rt(e1R,e2R);

RTL_e1 = RTL_e1L*EL_e;
RTL_e2 = RTL_e2L*EL_e;
RTR_e1 = RTR_e1R*ER_e;
RTR_e2 = RTR_e1R*ER_e;

RTRT_uvds = [RTL_e1 RTL_e2;RTR_e1 RTR_e2];


% rhotheta cov - matlab
R_mat = RTRT_uvds*R_uvds*RTRT_uvds'

% rhotheta covariance - Jafar
extsCov = 0.25*eye(6);

RR_uu = [16.6419,-160.052,0,-16.7454,161.046,0;
    -0.0258553,0.248659,0,0.0258553,-0.248659,0;
    15.9869,-159.319,-15.9869,-16.0867,160.314,16.0867;
    -0.0240975,0.240147,0.0240975,0.0240975,-0.240147,-0.0240975];

R_jaf = RR_uu*extsCov*RR_uu'

R_jaf = [13027.4,-20.1768,12963.2,-19.4788;
    -20.1768,0.03125,-20.0773,0.0301689;
    12963.2,-20.0773,13028,-19.5761;
    -19.4788,0.0301689,-19.5761,0.0294159]