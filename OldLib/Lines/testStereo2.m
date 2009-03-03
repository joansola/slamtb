% stereo head
stHead.alpha = 100;
stHead.cal = [240 240 300 300]';

% frames
Rj = [0;0;0;0;0;0]; % robot pose
Cj = [0;0;1.5;-pi/2;0;-pi/2]; % cam pose
P_rj = zeros(6,6);

% frames, quaternion
[Re,Re_rj] = eposeJafar2epose(Rj);
[R,R_re] = epose2qpose(Re);
R_rj = R_re*Re_rj;

[Ce,Ce_cj] = eposeJafar2epose(Cj);
[C,C_ce] = epose2qpose(Ce);
C_cj = C_ce*Ce_cj;

% stereo endpoints
uvds = [240.427,202.563,25.1067,2.10144,262.519,20.5696]';
R_uvds = diag([.25,.25,.25,.25,.25,.25].^2);

% plucker line - cam frame
[Lc,Lc_uvds] = uvdseg2plucker(stHead,uvds);

% plucker, world frame
[Lr,Lr_c,Lr_lc] = fromFramePlucker(C,Lc);
[L,L_r,L_lr]    = fromFramePlucker(R,Lr);

[Lre,Lre_t,Lre_e,Lre_lc] = fromFramePluckerEuler(Ce(1:3),Ce(4:6),Lc);

L_rj = L_r*R_rj;
L_lc = L_lr*Lr_lc;

L_uvds = L_lc*Lc_uvds;

P_ll = L_rj*P_rj'*L_rj' + L_uvds*R_uvds*L_uvds';

% origin
[p0,P0_l] = lineOrigin(L);
P0 = P0_l*P_ll*P0_l';

% test against jafar
Lcj = [-1998.55,-7944.18,-988.521,-1993.87,445.15,453.713]';
Lrj = [-3963.18,2642.12,7926.36,440.354,1981.59,-440.354]';
Lj  = [-3979.33,2679.12,7944.18,453.713,1993.87,-445.15]';
[p0j,P0j_l] = lineOrigin(Lj);

% abscissas
t1 = 0.433336;
t2 = 4.48562;
t = [t1;t2];
[s,S_l,S_s] = ls2seg(L,t);
S = S_l*P_ll*S_l';
s1 = s(1:3);
s2 = s(4:6);
S1 = S(1:3,1:3);
S2 = S(4:6,4:6);

[s1,S1_l] = ls2e(L,t1);
[s2,S2_l] = ls2e(L,t2);

Pj_ll = [949.224,-1168.12,-51.0327,-742.099,-601.618,67.2737;
    -1168.12,2951.39,-6.4906e-15,1875,742.099,14.9003;
    -51.0327,-6.4906e-15,138.889,-1.9422e-15,31.7196,6.92066e-16;
    -742.099,1875,-1.9422e-15,1250,494.733,31.0799;
    -601.618,742.099,31.7196,494.733,400.343,-37.314;
    67.2737,14.9003,6.92066e-16,31.0799,-37.314,20.5703];


Sj_l = [0,445.15,1993.87,0.433336,7944.18,-2679.12;
    -445.15,0,-453.713,-7944.18,0.433336,-3979.33;
    -1993.87,453.713,0,2679.12,3979.33,0.433336];


