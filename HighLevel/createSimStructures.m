function [SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(Robot,Sensor,World,SimOpt)

% CREATESIMSTRUCTURES Create simulation data structures.


% Random generator
if SimOpt.random.trueRandom
    SimOpt.random.randSeed = sum(100*clock);
    randn('state',SimOpt.random.randSeed);
else
    SimOpt.random.randSeed = SimOpt.random.fixedRandomSeed;
    randn('state',SimOpt.random.randSeed);
end

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

