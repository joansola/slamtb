% DISTJACTEST Symbolic computation and test of jacobians in the
% presence of radial image distortion.
%   It is a script - it takes no arguments. 
%   It performs the following actions:
%     1. Computes all jacobians of PINHOLE and INVPINHOLE.
%     2. Calls coded functions for the same jacobians
%     3. Checks for equality.
%   Remove end-of-line semicolons in script to show 
%   the desired results.
%
%   See also PINHOLE, INVPINHOLE, PINHOLEJAC, INVPINHOLEJAC.

format compact
home
syms k1 k2 k3 k4 real
syms u0 v0 au av real
syms x y z real
syms ud1 ud2 up1 up2 real
syms u v s real

kd  = [k1 k2 k3 k4]';
p   = [x y z]';
cal = [u0 v0 au av]';

% PROJECTION - Construction and test for pinHole jacobians.

% Partial Jacobians
% Project
up   = project(p);
Up_p = simplify(jacobian(up,p));

% Distort
up    = [up1 up2]';
ud    = distort(up,kd);
Ud_up = subexpr((jacobian(ud,up)));
Ud_kd = simplify(jacobian(ud,kd));

% Pixellise
ud    = [ud1 ud2]';
uu    = pixellise(ud,cal);
U_ud  = simplify(jacobian(uu,ud));
U_cal = simplify(jacobian(uu,cal));

% Complete jacobians
% uu    = pixellise(distort(project(p),kd),cal);
uu    = pinHole(p,cal,kd);
Up    = jacobian(uu,p);
Ucal  = jacobian(uu,cal);
Udist = jacobian(uu,kd);

% Function coded jacobians
[PHp,PHcal,PHdist] = pinHoleJac(p,cal,kd);

%Errors
EPHp    = simplify(Up-PHp)
EPHcal  = simplify(Ucal-PHcal)
EPHdist = simplify(Udist-PHdist)


% RETRO-PROJECTION - Construction and test of invPinHole jacs.

% Partial Jacobians
% Depixellise
uu     = [u v]';
ud     = depixellise(uu,cal);
Ud_u   = simplify(jacobian(ud,uu));
Ud_cal = simplify(jacobian(ud,cal));

% Undistort
ud    = [ud1 ud2]';
up    = undistort(ud,kd);
Up_ud = (jacobian(up,ud));
Up_kd = simplify(jacobian(up,kd));

% Retro
up   = [up1 up2]';
p    = retro(up,s);
P_up = simplify(jacobian(p,up));
P_s  = simplify(jacobian(p,s));

% Complete jacobians
% p       = retro(undistort(depixellise(uu,cal),kd),s);
p       = invPinHole(uu,s,cal,kd);
Pu      = simplify(jacobian(p,uu));
Pcal    = simplify(jacobian(p,cal));
Pundist = simplify(jacobian(p,kd));
Ps      = simplify(jacobian(p,s));

% Function coded jacobians
[Gw,Gs,Gcal,Gundist] = invPinHoleJac(uu,s,cal,kd);

% Errors
EGw      = simplify(Pu-Gw)
EGcal    = simplify(Pcal-Gcal)
EGs      = simplify(Ps-Gs)
EGundist = simplify(Pundist-Gundist)
