function [SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(Robot,Sensor,World,SimOpt)

% CREATESIMSTRUCTURES Create simulation data structures.


% Random generator
if SimOpt.random.active
    SimOpt.random.seed = sum(100*clock);
    randn('state',SimOpt.random.seed);
else
    SimOpt.random.seed = SimOpt.random.fixedSeed;
    randn('state',SimOpt.random.seed);
end

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

