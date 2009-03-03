function i = bfloor(r,b)

% BFLOOR  Base-round towards minus infinity
%   BFLOOR(R,BASE) gives the closest integer to the real R that
%   is also multiple of BASE.
%
%   Algorithm: BFLOOR = BASE*floor(R/BASE)
%
%   See also ROUND, CEIL, FLOOR, FIX, BROUND, BCEIL

i = b*floor(r/b);