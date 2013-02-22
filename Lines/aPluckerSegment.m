function [s, S_l] = aPluckerSegment(l,t)

% APLUCKERSEGMENT  Anchored Plucker line's segment from abscissas.
%   APLUCKERSEGMENT(L,T) returns a 3d segment corresponding to the anchored
%   Plucker line L with endpoints defined by the abscissas T=[t1;t2].
%
%   [s, S_l] = ... returns the Jacobian wrt the line L.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

[pl,PL_l] = unanchorPlucker(l);
[s,S_pl]  = pluckerSegment(pl,t);
S_l       = S_pl*PL_l;









