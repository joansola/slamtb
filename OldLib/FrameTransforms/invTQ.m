function [it,iq] = invTQ(t,q)

% INVTQ  Inverse transformation pair
%   [IT,IQ] = INVTQ(T,Q) computes the transformation pair (IT,IQ)
%   corresponding to the inverse transformation of (T,Q).

it = t2it(t,q);
iq = q2qc(q);
