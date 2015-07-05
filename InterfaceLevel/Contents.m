% Interface lavel functions for the SLAM toolbox.
%
% Create structures
%   createControls                - Create controls structure Con.
%   createLandmarks               - Create Lmk structure array.
%   createMap                     - Create an empty Map structure.
%   createObservations            - Create Obs structure array.
%   createRobots                  - Create robots structure array.
%   createSensors                 - Create sensors structure array.
%   createSimLmk                  - Create a set of landmarks for simulation.
%   createTime                    - Create Tim structure.
%   initRobots                    - Initialize robots in Map.
%   initSensors                   - Initialize sensors in Map.
%   installSensors                - Install sensors on robots.
%
% Draw graphics
%   drawMapFig                    - Redraw the 3D map figure.
%   drawSenFig                    - Redraw one sensor figure.
%
% Synchronization with Map
%   map2rob                       - Update Rob structure from the Map information.
%   map2sen                       - Update Sen structure from the Map information.
%
% Motion and prediction
%   simMotion                     - Simulated robot motion.
%   motion                        - Robot motion.
%
% Landmark initialization
%   initNewLmk                    - Initialise one landmark.
%   initLmkParams                 - Initialize off-filter landmark parameters.
%
% Landmark correction
%   correctKnownLmks              - Correct known landmarks.
%   simObservation                - Observe simulated landmarks.
%   projectLmk                    - Project landmark estimate into sensor's measurement space.
%   selectLmksToObserve           - Select landmarks to observe.
%   matchFeature                  - Match feature.
%   observationInnovation         - Observation innovation.
%   correctLmk                    - Correct landmark.
%   ekfCorrectLmk                 - Correct landmarks.
%   reparametrizeLmk              - Reparametrize landmark.
%   updateLmkParams               - Update off-filter landmark parameters.
%
% Other
%   deleteLmk                     - Delete landmark.
%   drawObsLin                    - Draw an observed line on the pinHole sensor figure.
%   drawObsPnt                    - Redraw a landmark on the pinHole sensor figure.
%   pluckerSegment                - Segment from Plucker line and endpoint abscissas.
%   createMapFig                  - Create 3D map figure and handles.
%   createSenFig                  - Create sensors figures and handles.
%   drawLmk                       - Draw 3D landmark.
%   drawRawLines                  - Draw raw lines.
%   drawRawPnts                   - Draw raw points.
%   prepareForActiveInit          - 
%
% Graph SLAM
%   addKeyFrame                   - Add key frame to trajectory.
%   addKnownLmkFactors            - CORRECTKNOWNLMKS  Correct known landmarks.
%   addNewLmkFactors              - INITNEWLMK  Initialise one landmark.
%   buildAdjacencyMatrix          - 
%   checkGraphIntegrity           - 
%   composeHmgPnt                 - 
%   computeResidual               - Compute the residual.
%   createFactors                 - Create Fac structure array.
%   createFrames                  - Create Frm structure array.
%   errorStateJacobians           - Compute Jacobians for projection onto the manifold.
%   frm2rob                       - Frame to Robot information transfer
%   frmJacobians                  - Compute Jacobians for projection onto the manifold.
%   integrateMotion               - Integrate Robot motion, with covariance.
%   lmkJacobians                  - Compute Jacobians for projection onto the manifold.
%   makeAbsFactor                 - Make absolute factor
%   makeAbsFactorFromMotionFactor - 
%   makeMeasFactor                - 
%   makeMotionFactor              - Make motion factor
%   resetMotion                   - Reset motion to origin of coordinates
%   retroProjLmk                  - Retro project landmark.
%   rob2frm                       - FRM2ROB Robot to Frame information transfer
%   solveGraph                    - Solve the SLAM problem posed as a graph of states and
%   solveGraphCholesky            - Solves the SLAM graph using Cholesky decomposition.
%   updateKeyFrm                  - 
%   updateLmk                     - 
%   updateStates                  - Update Frm and Lmk states based on computed error.
