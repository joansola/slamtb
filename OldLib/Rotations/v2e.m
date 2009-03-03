function [e,Ev] = v2e(v)

% V2E rotation vector to Euler angles conversion

[q,Qv] = v2q(v);
[e,Eq] = q2e(q);

Ev = Eq*Qv;
