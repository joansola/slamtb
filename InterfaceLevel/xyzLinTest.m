function Ld = xyzLinTest(Rob,Sen,Lmk)

% XYZLINTEST  Linearity test of cartesian point given inverse depth point
%   XYZLINTEST(ROB,SEN,LMK)

global Map


ir = Lmk.state.r;

% explode idp:
idp = Map.x(ir);
py  = idp(4:5);
m   = py2vec(py);
rho = idp(6);

% and idp variance:
IDP = Map.P(ir,ir);
RHO = IDP(6,6);


xi  = idp2p(idp);
rwc = fromFrame(Rob.frame,Sen.frame.t); % current camera center

hw        = xi-rwc;  % idp point to camera center
sigma_rho = sqrt(RHO);
sigma_d   = sigma_rho/rho^2; % depth sigma
d1        = norm(hw);
cos_a     = m'*hw/d1;

Ld = 4*sigma_d/d1*abs(cos_a);

