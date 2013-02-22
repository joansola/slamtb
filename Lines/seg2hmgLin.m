function [hm,HMs] = seg2hmgLin(s)

% SEG2HMGLIN  Segment to homogeneous line conversion.
%   SEG2HMGLIN(S) converts the segment S=[P;Q], with P and Q two Euclidean
%   points, into an homogeneous line in the plane.
%
%   [hm,HMs] = SEG2HMGLIN(S) returns the Jacobians wrt S.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


p = s(1:2);
q = s(3:4);
if nargout == 1
    hm = pp2hmgLin(p,q);
else 
    [hm,HMp,HMq] = pp2hmgLin(p,q);
    HMs = [HMp HMq];
end








