function mr = usedRange()

% USEDRANGE  Used map range.
%   USEDRANGE returns a range vector corresponding to all used positions in
%   the global EKF-map Map. It is equivalent to FIND(Map.used).
%
%   See also NEWRANGE, ADDTOMAP.

global Map

mr = find(Map.used);

