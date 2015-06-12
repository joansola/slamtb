function [Rob,Sen,Raw,Trj,Frm,Lmk,Fac,Obs,Tim] = createGraphStructures(Robot,Sensor,Time,Opt)

% CREATEGRAPHSTRUCTURES  Initialize graphSLAM data structures from user data.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

global Map

% Clear ID factory
clear newId; 

% Create robots and controls
Rob = createRobots(Robot);

% Create robot trajectories
Trj = createTrajectory(Rob, Opt);

% Create frames
Frm = createFrames(Rob,Opt);

% Create sensors
[Sen,Raw] = createSensors(Sensor);

% Install sensors in robots
[Rob,Sen] = installSensors(Rob,Sen);

% Create Landmarks and non-observables
Lmk = createLandmarks(Opt);

% Create Map - empty
Map = createMap(Rob,Sen,Opt);

% Initialize robots in Map
Rob = initRobots(Rob);

% Create factors
Fac = createFactors(Opt);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Opt);

% Create time variables
Tim = createTime(Time);

