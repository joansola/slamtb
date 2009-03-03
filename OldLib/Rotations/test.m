% TEST symbolic rotation conversions test. Includes jacobians. Not very
% useful.

syms r p y real
syms a b c d real
syms w x y z real

e = [r p y]';

% Matrius rotacio

Ry = [cos(y) -sin(y) 0 ; sin(y) cos(y) 0 ; 0 0 1];
Rp = [cos(p) 0 sin(p) ; 0 1 0 ; -sin(p) 0 cos(p)];
Rr = [1 0 0 ; 0 cos(r) -sin(r) ; 0 sin(r) cos(r)];

Re = Ry * Rp * Rr;

qy = [cos(y/2) 0 0 sin(y/2)]';
qp = [cos(p/2) 0 sin(p/2) 0]';
qr = [cos(r/2) sin(r/2) 0 0]';

Ryq = simple(q2R(qy));
Rpq = simple(q2R(qp));
Rrq = simple(q2R(qr));

Rq = Ryq * Rpq * Rrq;

q = qProd(qProd(qy,qp),qr);

Rqq = q2R(q);

ER = simple(Rqq-Re);
ER

% quaternion product
q1 = [a b c d]';
q2 = [w x y z]';

q3 = qProd(q1,q2);
q4 = q2Q(q1)*q2;

EQ = simple(q3-q4);
EQ

% rotacions

v = [x y z]';

vq = qRot(v,q);
vR = Re * v;

EV = simple(vq-vR);
EV

% composicions
e = [r p y]';
ee = simple(q2e(e2q(e)))