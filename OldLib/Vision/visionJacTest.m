% VISIONJACTEST Symbolic computation and test of jacobians.
%   It is a script - it takes no arguments. It performs the
%   following actions:
%     1. Computes all jacobians of PINHOLE and INVPINHOLE. 
%     2. Calls coded functions for the same jacobians.
%     3. Checks for equality.
%   Remove end-of-line semicolons in script to show the desired
%   results.
%
%   Use DISTJACTEST to include distortion features.
%
%   See also PINHOLE, INVPINHOLE, PINHOLEJAC, INVPINHOLEJAC.

format compact
home

syms x y z real
syms u v s real
syms u0 v0 au av real

p   = [x;y;z];       % 3D point
pix = [u;v];         % pixel
cal = [u0;v0;au;av]; % calibration parameters
s   = s;             % range or depth

% True jacobians from symbolic computation
px = pinHole(p,cal);

PPHp = jacobian(px,p);
PPHc = jacobian(px,cal);

pt = invPinHole(pix,s,cal);

GGw = jacobian(pt,pix);
GGs = jacobian(pt,s);
GGc = jacobian(pt,cal);

% Jacobians from coded functions
[PHp,PHc]  = pinHoleJac(p,cal);
[Gw,Gs,Gc] = invPinHoleJac(pix,s,cal);

% Equality test. Should result in null matrices.
EPHp = simplify(PPHp-PHp)
EPHc = simplify(PPHc-PHc)
EGw  = simplify(GGw-Gw)
EGs  = simplify(GGs-Gs)
EGc  = simplify(GGc-Gc)

