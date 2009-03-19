% CREATESIMSTRUCTURES Create simulation data structures
%   This is a script.

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

