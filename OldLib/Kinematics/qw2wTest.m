% QW2QTEST Test of jacobians

syms a b c d real
syms u v w real
syms T real

q = [a b c d]';
z = [u v w]';

qp = qw2q(q,z,T);

% True jacobians
Qq = jacobian(qp,q);
Qw = jacobian(qp,z);
% Coded jacobians
[Fq,Fw] = qw2qJac(q,z,T);

% errors (should be zero matrices)
Eq = simple(Qq-Fq)
Ew = simple(Qw-Fw)