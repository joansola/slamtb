function [s,S1,S2] = makeSegment(p1,p2)

% MAKESEGMENT  Make a segment out of two endpoints
%   MAKESEGMENT(E1,E2) makes a segment out of the two endpoints E1 and E2
%   by stacking both endpoints [E1;E2];
%
%   [s,S1,S2] = MAKESEGMENT(E1,E2) returns the Jacobians of the segments
%   wrt the endpoints.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

s = [p1(:);p2(:)];

if nargout>1
    
    n  = numel(p1);
    S1 = [eye(n);zeros(n)];
    S2 = [zeros(n);eye(n)];
    
end









