function i = real2int(r,b)

% REAL2INT  real to integer
%   REAL2INT(R,BASE) gives the closest integer to the real R that
%   is also multiple of BASE.
%
%   Algorithm: BASE*round(R/BASE)
%
%   See also ROUND, CEIL, FLOOR, FIX, BFLOOR, BCEIL

warning('REAL2INT is a deprecated function. Use BROUND() instead')

i = b*round(r/b);
