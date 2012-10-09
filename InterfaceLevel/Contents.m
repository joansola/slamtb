% Interface lavel functions for the SLAM toolbox.
%
% Create structures
%   createControls        - Create controls structure Con.
%   createLandmarks       - Create Lmk structure array.
%   createMap             - Create an empty Map structure.
%   createObservations    - Create Obs structure array.
%   createRobots          - Create robots structure array.
%   createSensors         - Create sensors structure array.
%   createSimLmk          - Create a set of landmarks for simulation.
%   createTime            - Create Tim structure.
%   initRobots            - Initialize robots in Map.
%   initSensors           - Initialize sensors in Map.
%   installSensors        - Install sensors on robots.
%
% Draw graphics
%   drawMapFig            - Redraw the 3D map figure.
%   drawSenFig            - Redraw one sensor figure.
%
% Synchronization with Map
%   map2rob               - Update Rob structure from the Map information.
%   map2sen               - Update Sen structure from the Map information.
%
% Motion and prediction
%   simMotion             - Simulated robot motion.
%   motion                - Robot motion.
%
% Landmark initialization
%   initNewLmk            - Initialise one landmark.
%   initLmkParams         - Initialize off-filter landmark parameters.
%
% Landmark correction
%   correctKnownLmks      - Correct known landmarks.
%   simObservation        - Observe simulated landmarks.
%   projectLmk            - Project landmark estimate into sensor's measurement space.
%   selectLmksToObserve   - Select landmarks to observe.
%   matchFeature          - Match feature.
%   observationInnovation - Observation innovation.
%   correctLmk            - Correct landmark.
%   ekfCorrectLmk         - Correct landmarks.
%   reparametrizeLmk      - Reparametrize landmark.
%   updateLmkParams       - Update off-filter landmark parameters.
%
% Other
%   deleteLmk             - Delete landmark.
%   drawObsLin            - Draw an observed line on the pinHole sensor figure.
%   drawObsPnt            - Redraw a landmark on the pinHole sensor figure.
%   pluckerSegment        - Segment from Plucker line and endpoint abscissas.
%   createMapFig          - Create 3D map figure and handles.
%   createSenFig          - Create sensors figures and handles.
%   drawLmk               - Draw 3D landmark.
%   drawRawLines          - Draw raw lines.
%   drawRawPnts           - Draw raw points.
%   prepareForActiveInit  - 
