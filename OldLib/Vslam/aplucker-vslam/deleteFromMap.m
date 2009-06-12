function deleteFromMap(range)

% DELETEFROMMAP  Delete from map.
%   DELETEFROMMAP(RANGE) marks all positions of the global map Map
%   specified by RANGE as free positions.

global Map

Map.used(range) = false;
Map.free(range) = range;
