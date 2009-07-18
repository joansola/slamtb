function world = initWorld(lim)

% INITWORLD  Initialize world structure and dimensions

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% World dimensions
world.xMin  = -4;
world.xMax  =  30;
world.yMin  = -20;
world.yMax  =  20;
world.zMin  = -10;
world.zMax  =  10;
world.l     = world.xMax - world.xMin;
world.w     = world.yMax - world.yMin;
world.h     = world.zMax - world.zMin;
world.xMean = (world.xMax + world.xMin)/2;
world.yMean = (world.yMax + world.yMin)/2;
world.zMean = (world.zMax + world.zMin)/2;


% World structure - for simulation purposes
world.points   = zeros(3,0);




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

