function Rob = initRobots(Rob)

% INITROBOTS Initialize robots in Map.
%   Rob = INITROBOTS(Rob) initializes all robots in Rob() in the global map
%   Map. It does so by:
%       getting a range of free states for the robot
%       assigning it to the appropriate fields of Rob
%       setting Rob's mean and cov. matrices in Map
%       setting all Map.used positions in the range to true

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


for rob = 1:numel(Rob)

    fr = addToMap(Rob(rob).frame.x,Rob(rob).frame.P); % frame range in Map
    Rob(rob).frame.r = fr;
    
    vr = addToMap(Rob(rob).vel.x,Rob(rob).vel.P);     % velocity range
    Rob(rob).vel.r   = vr;
    
    Rob(rob).state.r = [fr;vr];   % robot's state range

end



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

