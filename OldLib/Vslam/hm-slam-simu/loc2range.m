function rng = loc2range(loc)

% LOC2RANGE  Get ranges from multiple locations
%   LOC2RANGE(L) takes the vector L of locations and returns
%   a row vector of all stacked corresponding ranges.
%
% See also LOC2RANGE

global HDIM VDIM

loc = loc*HDIM-(HDIM-1); % spaced vector
loc = loc(:)';  % row vector
for i = 1:HDIM
    rng(i,:) = loc + i - 1;
end
% rng = VDIM+[loc-2;loc-1;loc];
rng = rng + VDIM;
rng = rng(:)';  % row vector
