function i = bceil(r,b)

% BCEIL  Base-round towards infinity
%   BCEIL(R,BASE) gives the closest integer to the real R that
%   is also multiple of BASE.
%
%   Algorithm: BCEIL = BASE*ceil(R/BASE)
%
%   See also ROUND, CEIL, FLOOR, FIX, BFLOOR, REAL2INT

i = b*ceil(r/b);