function mr = usedRange()

% USEDRANGE  Used map range.
%   USEDRANGE returns a range vector corresponding to all used positions in
%   the global EKF-map Map. It is equivalent to FIND(Map.used).
%
%   See also NEWRANGE, ADDTOMAP.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

mr = find(Map.used);

return

%% test
global Map

Map.used = [0 0 0 1 1 0 1 1 0 0 0 1 0 0]';

nr = newRange(6)
ur = usedRange()









