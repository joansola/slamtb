% board


% corners in pix
% true corners
Cpx = [360 442 359 441];
Cpy = [57 57 118 119];

% estimated
cpx = [360 443 361.5 441.5];
cpy = [58 59 119.3 120.5];

% dimensions in cm
sx = 118;
sy = 88;

% estimated in cm
d1 = (cpx(2)-cpx(1))*sx/(Cpx(2)-Cpx(1))
d2 = (cpy(4)-cpy(2))*sy/(Cpy(4)-Cpy(2))
d3 = (cpx(4)-cpx(3))*sx/(Cpx(4)-Cpx(3))
d4 = (cpy(3)-cpy(1))*sy/(Cpy(3)-Cpy(1))


Re =  [119
    86
    114
    88
    134
    125 ];
Es = [
 119.6 
 84.3 
 114.8 
 89.0 
 132.5 
 124.5 ];

e_abs = Re-Es;
e_rel = Es./Re;

s_abs = std(e_abs)
s_rel = std(e_rel)
