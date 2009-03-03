% INVROBCAMTESTJAC Symbolic Test of ROBCAM jacobians of inverse functions

clear

syms x y z real % point
syms u v s real % pixel and depth
syms ru rv rw real % robot frame position
syms cu cv cw real % camera frame position
syms ra rb rc rd real % robot orientation
syms ca cb cc cd real % camera orientation
syms u0 v0 au av real % camera parameters

% Robot and camera
Rt  = [ru rv rw]';
Rq  = [ra rb rc rd]';
R   = [Rt;Rq];
rob.X = R;
rob   = updateFrame(rob);

Ct  = [cu cv cw]';
Cq  = [ca cb cc cd]';
C   = [Ct;Cq];
cal = [u0 v0 au av]';
cam.X = C;
cam.cal = cal;
cam = updateFrame(cam);

% Bearing or pixel
b = [u v]';

% Inverse functions
%------------------

% only camera. true jac 
pr  = invCamPhoto(cam,b,s);
GRc = jacobian(pr,C);
GRb = jacobian(pr,b);
GRs = jacobian(pr,s);
GRcal = jacobian(pr,cal);
% coded jac
[grc,grb,grs,grcal] = invCamPhotoJac(cam,b,s);
% errors
Egrc = simplify(GRc-grc)
Egrb = simplify(GRb-grb)
Egrs = simplify(GRs-grs)
Egrcal = simplify(GRcal-grcal)

% robot and camera. true jac
p = invRobCamPhoto(rob,cam,b,s);
Gr = jacobian(p,R);
Gc = jacobian(p,C);
Gb = jacobian(p,b);
Gs = jacobian(p,s);
Gcal = jacobian(p,cal);
% coded jac
[gr,gc,gb,gs,gcal] = invRobCamPhotoJac(rob,cam,b,s);
% errors
Egr = simplify(Gr-gr)
Egc = simplify(Gc-gc)
Egb = simplify(Gb-gb)
Egs = simplify(Gs-gs)
Egcal = simplify(Gcal-gcal)
