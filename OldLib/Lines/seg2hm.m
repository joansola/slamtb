function [hm,HMs] = seg2hm(s)

% SEG2HM  Segment to homogeneous line conversion.
%   SEG2HM(S) converts the segment S=[P;Q], with P and Q two Euclidean
%   points, into an homogeneous line in the plane.
%
%   [hm,HMs] = SEG2HM(S) returns the Jacobians wrt S.

p = s(1:2);
q = s(3:4);
if nargout == 1
    hm = pp2hm(p,q);
else 
    [hm,HMp,HMq] = pp2hm(p,q);
    HMs = [HMp HMq];
end