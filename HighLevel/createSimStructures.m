function [SimRob,SimSen,SimLmk] = createSimStructures(Robot,Sensor,World)

% CREATESIMSTRUCTURES Create simulation data structures

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

