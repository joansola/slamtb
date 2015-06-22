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

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

if all(vecSize > 0)
    r = find(~Map.used,vecSize,'first');
else
    r = [];
end

return

%% test
global Map

Map.used.x = [0 0 0 1 1 0 1 1 0 0 0 1 0 0]';

[nr] = newRange(6)
ur = usedRange()



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

