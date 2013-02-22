function [e,E] = q2eG(q,Q)

% Q2EG  Transform quaternion Gaussian to Euler Gaussian.
%   [e,E] = Q2EG(q,Q) thransforms the Gaussian quaternion N(q,Q) into a
%   Euler angles Gaussian N(e,E) representing the same rotation with the
%   same uncertainty.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[e,Eq] = q2e(q);
E = Eq*Q*Eq';










