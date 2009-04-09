function r = newRange(vecSize)

% NEWRANGE  New map range.
%   NEWRANGE(SIZE) returns a range vector with the first SIZE non-used
%   positions in the global EKF-map Map.
%
%   For example, the code
%       global Map
%       Map.used = [0 0 0 1 1 0 1 1 0 0 0 1 0 0]';
%       r = newRange(6)
%
%   returns r = [1 2 3 6 9 10]'
%
%   See also ADDTOMAP.

global Map

if vecSize > 0
    r = find(~Map.used,vecSize,'first');
else
    r = [];
end

return

%% test
global Map

Map.used = [0 0 0 1 1 0 1 1 0 0 0 1 0 0]';

nr = newRange(6)
ur = usedRange()