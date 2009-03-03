% Test file for a bunch of rotation conversions.
%
% This test starts with a given Euler angles vector e and performs all
% possible convertion combinations from and to R, q and v (rotation matrix,
% quaternion and rotation vector). these combinations are
%
% e -> R
% e -> q
% e -> v
% e -> R -> q
% e -> R -> v
% e -> q -> R
% e -> q -> v
% e -> v -> q
% e -> v -> R
% ...
% e -> R -> q -> v -> e
% ...
%
% All results are printed in groups. All R must be equal. All q, all v and
% all e as-well.
%
% Euler angles are [roll pitch yaw] in radians and must be like this:
%     -pi <= roll  <= pi
%   -pi/2 <= pitch <= pi/2
%       0 <= yaw   <= 2*pi   or   -pi <= yaw <= pi

% Please enter the initial Euler angles for test (radians)
e = [2 -.2 3]';

% first conversion e -> *
qe = e2q(e);
Re = e2R(e);
ve = e2v(e);

% second conversion e -> * -> *
eqe = q2e(qe);
eRe = R2e(Re);
eve = v2e(ve);

Rqe = q2R(qe);
vqe = q2v(qe);
qRe = R2q(Re);
vRe = R2v(Re);
qve = v2q(ve);
Rve = v2R(ve);

% third conversion e -> * -> * -> *
eRqe = R2e(Rqe);
evqe = v2e(vqe);
eqRe = q2e(qRe);
evRe = v2e(vRe);
eqve = q2e(qve);
eRve = R2e(Rve);

vRqe = R2v(Rqe);
Rvqe = v2R(vqe);
vqRe = q2v(qRe);
qvRe = v2q(vRe);
Rqve = q2R(qve);
qRve = R2q(Rve);

% last conversion -- e -> * -> * -> * -> e -- show all e


evRqe = v2e(vRqe);
eRvqe = R2e(Rvqe);
evqRe = v2e(vqRe);
eqvRe = q2e(qvRe);
eRqve = R2e(Rqve);
eqRve = q2e(qRve);

% show all e
e_eqe_eRe_eve_eRqe_evqe_eqRe_evRe_eqve_eRve = ...
    [e eqe eRe eve eRqe evqe eqRe evRe eqve eRve]

evRqe_eRvqe_evqRe_eqvRe_eRqve_eqRve = ...
[evRqe eRvqe evqRe eqvRe eRqve eqRve]

% % show all R
% Re
% Rqe
% Rve
% Rvqe
% Rqve
% 
% % show all q
% qe
% qve
% qRe
% qRve
% qvRe
% 
% % show all v
% ve
% vRe
% vqe
% vRqe
% vqRe