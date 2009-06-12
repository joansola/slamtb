function r = getFreeRange(size)

% GETFREERANGE  Get free range.
%   GETFREERANGE(SIZE) returns a range of size SIZE of the lowest free
%   positions in the global map Map. If no sufficient space is available in
%   Map, the return is the empty range.

global Map

f = Map.free(logical(Map.free));
if numel(f) >= size
    r = f(1:size);
else
    r = [];
end
