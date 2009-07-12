function [s, S_l, S_t] = pluckerSegment(l,t)

% PLUCKERSEGMENT Segment from Plucker line and endpoint abscissas.
%   PLUCKERSEGMENT(L,T) returns a segment [p1;p2] of two endpoints given a
%   Plucker line L and its two endpoint abscissas in T.

[e1,e2,E1_l,E2_l,E1_t1,E2_t2] = pluckerEndpoints(l,t(1),t(2));

s = [e1;e2];

if nargout > 1
    S_l = [E1_l;E2_l];
    if nargout > 2
        S_t = [E1_t1 E1_t2
            E2_t1;E2_t2];
    end
end
