function [Rob,Sen,Raw,Frm,Lmk,Fac,Obs,Tim] = createGraphStructures(Robot,Sensor,Time,Opt)

% CREATEGRAPHSTRUCTURES  Initialize graphSLAM data structures from user data.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

global Map

% Create robots and controls
Rob = createRobots(Robot);

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

% Create factors
Fac = createFactors(Opt);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Opt);

% Create time variables
Tim = createTime(Time);

