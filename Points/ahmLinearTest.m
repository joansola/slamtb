function Ld = ahmLinearTest(Rob,Sen,Lmk)

% AHMLINEARTEST  Linearity test of cartesian point given inverse depth point
%   LD = AHMLINEARTEST(ROB,SEN,LMK) return a value with the result of the
%   linearity test.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

r = Lmk.state.r;

% explode ahm:
ahm = Map.x(r);
m   = ahm(4:6);
rho = ahm(7);

% and ahm variance:
AHM = Map.P(r,r);
RHO = AHM(7,7);

xi  = ahm2euc(ahm);
rwc = fromFrame(Rob.frame,Sen.frame.t); % current camera center

hw        = xi-rwc;  % ahm point to camera center
sigma_rho = sqrt(RHO);
sigma_d   = sigma_rho/rho^2; % depth sigma
d1        = norm(hw);
d2        = norm(m);
cos_a     = m'*hw/d1/d2;

Ld = 4*sigma_d/d1*abs(cos_a);










