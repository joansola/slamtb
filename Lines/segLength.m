function l = segLength(seg)

% SEGLENGTH  Segment length.
%   SEGLENGTH(S) computes the length of segment S = [E1;E2], where E1 and
%   E2 are the two endpoints defining the segment. It works for any
%   dimension.
%
%   SEGLENGTH admits segment matrices S=[S1 ... Sn], in which case it
%   returns a lengths vector L = [L1 ... Ln];

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

n = size(seg,1);

v = seg(1:n/2,:) - seg(n/2+1:n,:);

l = sqrt(sum(v.^2,1));









