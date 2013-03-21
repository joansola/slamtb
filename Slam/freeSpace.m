function s = freeSpace()

% FREESPACE Check for free space in Map.
%   FREESPACE() returns the number of free states in the map Map.

global Map

s = numel(find(~Map.used));
