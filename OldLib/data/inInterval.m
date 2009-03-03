function in = inInterval(a,interval)

% ININTERVAL  Check apartenance to interval.
%   ININTERVAL(A,I) is a boolean matrix of size size(A), true for
%   each entry of A that is within the interval defined by I = [min,max].

in = (a>=interval(1)) & (a<=interval(2));
