function [hm,HMp,HMq] = points2hm(p,q)

% POINTS2HM  Homogeneous line from two homogeneous points.
%
%   POINTS2HM: Deprecated function. Use PP2HM instead.
%
%   PP2HM(P,Q) is the homogeneous line in the projective plane joining the
%   two  points P and Q. P and Q can be either Euclidean 2-points or
%   homogeneous 3-points.
%
%   [L,Lp,Lq] = PP2HM(p,q) returns the Jacobians wrt P and Q.
%
%   See also PP2HM.

warning('Deprecated function POINTS2HM. Use PP2HM instead.')


if nargout == 1
    hm = pp2hm(p,q);
else
    [hm,HMp,HMq] = pp2hm(p,q);
end

