function [SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(Robot,Sensor,World,SimOpt)

% CREATESIMSTRUCTURES Create simulation data structures.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Random generator
if SimOpt.random.newSeed
    SimOpt.random.seed = sum(100*clock);
    randn('state',SimOpt.random.seed);
    fprintf('Random seed: %6.0f.\n',SimOpt.random.seed)
    disp('To repeat this run, edit userData.m,')
    disp('   add this seed to SimOpt.random.fixedSeed,')
    disp('   and set SimOpt.random.newSeed to false.')
else
    SimOpt.random.seed = SimOpt.random.fixedSeed;
    randn('state',SimOpt.random.seed);
    fprintf('Fixed random seed: %6.0f.\n',SimOpt.random.seed)
    disp('To make further runs truly random, edit userData.m,')
    disp('   and set SimOpt.random.newSeed to true.')
end

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);




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

