% ROBCAMTESTJAC Symbolic Test of ROBCAM jacobians of forward functions

clear

syms x y z real % point
syms u v s real % pixel and depth
syms ru rv rw real % robot frame position
syms cu cv cw real % camera frame position
syms ra rb rc rd real % robot orientation
syms ca cb cc cd real % camera orientation
syms u0 v0 au av real % camera parameters

% Robot and camera
Rt = [ru rv rw]';
Rq = [ra rb rc rd]';
R.X  = [Rt;Rq];
R=updateFrame(R);

Ct = [cu cv cw]';
Cq = [ca cb cc cd]';
C = [Ct;Cq];
cal = [u0 v0 au av]';
cam.X = C;
cam.cal = cal;
cam = updateFrame(cam);

% 3D point
p = [x y z]'; 

% Forward functions
%------------------

% only camera. true jac 
b = camPhoto(cam,p);
HRc = jacobian(b,C);
HRp = jacobian(b,p);
HRcal = jacobian(b,cal);
% coded jac
[hrc,hrp,hrcal] = camPhotoJac(cam,p);
% errors
Ehrc = simplify(HRc-hrc)
Ehrp = simplify(HRp-hrp)
Ehrcal = simplify(HRcal-hrcal)

% robot and camera. true jac
b = robCamPhoto(R,cam,p);
Hr = jacobian(b,R.X);
Hc = jacobian(b,cam.X);
Hp = jacobian(b,p);
Hcal = jacobian(b,cam.cal);
% coded jac
[hr,hc,hp,hcal] = robCamPhotoJac(R,cam,p);
%errors
Ehr = simplify(Hr-hr)
Ehc = simplify(Hc-hc)
Ehp = simplify(Hp-hp)
Ehcal = simplify(Hcal-hcal)
