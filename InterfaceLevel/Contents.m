% Interface lavel functions for the SLAM toolbox.
%
% Files
%   createControls     - Create controls structure Con.
%   createLandmarks    - Create Lmk() structure array.
%   createMap          - Create an empty Map structure.
%   createObservations - Create Obs structure array.
%   createRobots       - Create robots structure array.
%   createSensors      - Create sensors structure array.
%   createSimLmk       - Create a set of landmarks for simulation.
%   createTime         - Create Tim structure.
%   drawEucLmk         - Draw Euclidean point landmark in MapFig.
%   drawIdpLmk         - Draw inverse-depth point landmark in MapFig.
%   drawMapFig         - Redraw the 3D map figure.
%   drawObsPoint       - Redraw a landmark on the pinHole sensor figure.
%   drawSenFig         - Redraw the sensors figures.
%   initLmk            - Initialise some new landmarks from recent observations.
%   initRobots         - Initialize robots in Map.
%   initSensors        - Initialize sensors in Map.
%   installSensors     - Install sensors on robots.
%   map2rob            - Update Rob structure from the Map information.
%   map2sen            - Update Sen structure from the Map information.
%   motion             - Robt motion.
%   observeKnownLmks   - update what can be done with non-first observations.
%   simObservation     - Simulated observation.
%   testObs            - Update OBS information to simulate a SLAM observation.
