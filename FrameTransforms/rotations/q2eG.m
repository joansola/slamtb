function [e,E] = q2eG(q,Q)

% Q2EG  Transform quaternion Gaussian to Euler Gaussian.

[e,Eq] = q2e(q);
E = Eq*Q*Eq';

