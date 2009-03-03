function loc = getLoc

% GETLOC  Get lowest free location
%   GETLOC returns the location of the first available
%   space for a landmark in the Map. If no available
%   space, GETLOC returns [].

global Map

loc = min(Map.free(Map.free~=0));

