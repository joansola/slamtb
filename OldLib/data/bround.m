function i = bround(r,b)

% BROUND  Base-round towards closed integer
%   BROUND(R,BASE) gives the closest integer to the real R that
%   is also multiple of BASE.
%
%   Algorithm: BROUND = BASE*round(R/BASE)
%
%   See also ROUND, CEIL, FLOOR, FIX, BFLOOR, BCEIL

i = b*round(r/b);