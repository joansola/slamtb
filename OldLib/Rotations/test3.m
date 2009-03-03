% Test file for a bunch of rotation conversions. Problems in rotation
% vector when not in first or fourth quadrant.
%
% This test starts with a given Euler angles vector e and performs all
% possible convertion combinations from and to R, q and v (rotation matrix,
% quaternion and rotation vector). these combinations are
%
% e -> R ->e
% e -> q -> e
% e -> v -> e
%
% All results are printed in. All e must be equal.

% Please enter the initial Euler angles for test (radians)
e = [.1 2 .3]'

% first conversion e -> *
qe = e2q(e);
Re = e2R(e);
ve = e2v(e);

% second conversion e -> * -> e
eqe = q2e(qe)
eRe = R2e(Re)
eve = v2e(ve)

