function [t,p1,p2] = intersectSegments(l1,l2)

% INTERSECTSEGMENTS  Intersect two 3d segments.
%   [T,P1,P2] = INTERSECTSEGMENTS(L1,L2) intersects the two segments
%   L1=[E1,F1] and L2=[E2,F2], and returns a vector of abscissas T=[T1;T2],
%   and two intersection points P1 and P2, so that
%
%       P1 = E1 + T1*V1
%       P2 = E2 + T2*V2
%
%   where V1=F1-E1 and V2=F2-E2 are director vectors.
%
%   Note that what we really intersect is the infinite line supporting the
%   segments. Some examples (intersection is at the cross '+'):
%
%       ----+----         +         |
%                                   |
%           |           / |     ----+---
%           |          /  |         |
%
%   If the lines do intersect in the 3D space, we have the intersection
%   point P = P1 = P2. Otherwise, P1 and P2 are the points of the lines
%   that are closest to the other line, that is, the line passing over P1
%   and P2 is orthogonal to both L1 and L2.
%
%   See also INTERSECTPVLINES, SEG2PVLIN.

m1 = seg2pvLin(l1);
m2 = seg2pvLin(l2);

[t,p1,p2] = intersectPvLines(m1,m2);

