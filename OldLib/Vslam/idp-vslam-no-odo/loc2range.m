function rng = loc2range(loc)

% LOC2RANGE  Get ranges from multiple locations
%   LOC2RANGE(L) takes the vector L of locations and returns
%   a row vector of all stacked corresponding ranges.
%
% See also LOC2RANGE

global WDIM VDIM

loc = loc*WDIM; % spaced vector
loc = loc(:)';  % row vector
rng = VDIM+[loc-2;loc-1;loc];
rng = rng(:)';  % row vector
