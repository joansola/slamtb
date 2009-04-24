function [SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(Robot,Sensor,World,SimOpt)

% CREATESIMSTRUCTURES Create simulation data structures.


% Random generator
if SimOpt.random.active
    SimOpt.random.seed = sum(100*clock);
    randn('state',SimOpt.random.seed);
    fprintf('Random seed: %6.0f.\n',SimOpt.random.seed)
    disp('To repeat this run, edit userData.m,')
    disp('   add this seed to SimOpt.random.fixedSeed,')
    disp('   and set SimOpt.random.active to ''true''.')
else
    SimOpt.random.seed = SimOpt.random.fixedSeed;
    randn('state',SimOpt.random.seed);
    fprintf('Fixed random seed: %6.0f.\n',SimOpt.random.seed)
    disp('To make further runs truly random, edit userData.m,')
    disp('   and set SimOpt.random.active to ''false''.')
end

% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

