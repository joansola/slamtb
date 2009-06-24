function [Rob,Sen,Raw,Lmk,Obs,Tim] = createSlamStructures(Robot,Sensor,Time,Opt)

% CREATESLAMSTRUCTURES  Initialize SLAM data structures from user data.
global Map

% Create robots and controls
Rob = createRobots(Robot);

% Create sensors
[Sen,Raw] = createSensors(Sensor);

% Install sensors in robots
[Rob,Sen] = installSensors(Rob,Sen);

% Create Landmarks and non-observables
Lmk = createLandmarks(Opt);

% Create Map - empty
Map = createMap(Rob,Sen,Opt);

% Initialize robots and sensors in Map
Rob = initRobots(Rob);
Sen = initSensors(Sen);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Opt);

% Create time variables
Tim = createTime(Time);
