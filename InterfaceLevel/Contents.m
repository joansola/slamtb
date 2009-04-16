% Interface lavel functions for the SLAM toolbox.
%
% Create structures
%   createControls     - Create controls structure Con.
%   createLandmarks    - Create Lmk structure array.
%   createMap          - Create an empty Map structure.
%   createObservations - Create Obs structure array.
%   createRobots       - Create robots structure array.
%   createSensors      - Create sensors structure array.
%   createSimLmk       - Create a set of landmarks for simulation.
%   createTime         - Create Tim structure.
%   initRobots         - Initialize robots in Map.
%   initSensors        - Initialize sensors in Map.
%   installSensors     - Install sensors on robots.
%
% Draw graphics
%   drawEucLmk         - Draw Euclidean point landmark in MapFig.
%   drawIdpLmk         - Draw inverse-depth point landmark in MapFig.
%   drawMapFig         - Redraw the 3D map figure.
%   drawObsPoint       - Redraw a landmark on the pinHole sensor figure.
%   drawSenFig         - Redraw one sensor figure.
%
% Synchronization with Map
%   map2rob            - Update Rob structure from the Map information.
%   map2sen            - Update Sen structure from the Map information.
%
% Motion and prediction
%   simMotion          - Simulated robot motion.
%   motion             - Robot motion.
%
% Landmark initialization
%   observeNewLmks     - Initialise one landmark.
%
% Landmark correction
%   simObservation     - Simulated observation.
%   observeKnownLmks   - Observe known landmarks.
%   projectLmk         - Project landmark estimate into sensor's measurement space.
%   selectLmksToObserve   - Select landmarks to observe.
%   matchFeature          - Match feature.
%   observationInnovation - Observation innovation.
%   correctLmk            - Correct landmark.
%   reparametrizeLmk      - Reparametrize landmark.
%
% Other
%   testObs            - Update OBS information to simulate a SLAM observation.
