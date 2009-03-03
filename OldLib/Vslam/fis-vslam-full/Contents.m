% VSLAM
%
% Files
%   FISUpdate           - Ray update using FIS
%   balWeight           - Balance ray weights
%   classify            - Landmark classification
%   classifyObs         - CLASSIFY  Landmark classification
%   countLmks           - Count landmarks (points and rays) in each region
%   countPnts           - Count points in each region
%   countRays           - Count rays in each region
%   dispLmks            - display projected landmark means
%   dispMapPnts         - display map points
%   dispMapRays         - display map rays
%   dispObsPnts         - observations
%   dispObsRays         - observations
%   dispProjLmks        - display projected landmark means
%   dispProjPnts        - display projected points
%   dispProjRays        - display projected rays
%   displayCamera       - 
%   displayEllipses     - 
%   displayMap          - 
%   displayMaxUsed      - function  [maxLm,maxMapSize] = displayMaxUsed(maxLm,maxMapSize);
%   displayRobot        - 
%   displayUsed         - 
%   emptyPnt            - Create empty landmark structure.
%   emptyRay            - Create empty ray structure.
%   evalLmk             - 
%   fillPnts            - Fill points structure
%   fillRays            - Fill rays structure
%   getFree             - Get free position
%   getLoc              - Get lowest free location
%   getMaxInit          - Compute maximum allowable initializations
%   getVisPnts          - Get visible points
%   inRectangle         - Select points inside a rectangle
%   initCamera          - Initialize a camera
%   initDrawLmks        - 
%   initDrawMapLmks     - Initialize graphics for map landmarks
%   initDrawProjLmks    - Initialize graphics for projected landmarks
%   initLmks            - Initialize landmark structure
%   initMap             - Initialize map
%   initMapFig          - Initialize visualization
%   initObs             - Initialize observations
%   initObserver        - Initialize observer camera for plots
%   initOdo             - Init odometry data
%   initPatchesFig      - 
%   initRay             - Initialize ray parameters
%   initRobot           - Initialize robot
%   initWorld           - Initialize world
%   landmarkInit        - EKF-SLAM landmark initialization.
%   landmarkInnovation  - Innovation of a landmark observation
%   landmarkObservation - EKF update after lm observation
%   liberateMap         - Liberate landmarks in the map
%   lmkCorrection       - Landmark correction
%   loc2range           - Get ranges from multiple locations
%   loc2state           - Map location to map state conversion
%   moveLandmark        - Move landmark in the map
%   newRay              - Create new ray
%   normWeight          - Normalize ray weights
%   numInit             - Number of landmarks to init per region
%   occupateMap         - Occupate one map location
%   oneShot             - Take one gray level picture from general picture file.
%   projectPnt          - Project Point into image plane
%   projectRay          - Project Ray into image plane
%   pruneRay            - Prune low weighted ray points
%   pruneTwinPoints     - Prune coincident ray points
%   range2loc           - Get location from range
%   ray2pnt             - Ray to point transition
%   ray2point           - Ray to point transition
%   rayInit             - Ray initialization
%   robotMotion         - Robot motion from odometry data
%   state2loc           - Map state to map location conversion
%   uPntInnovation      - Pnt innovation statistics
%   uRayInnovation      - Ray innovation statistics
%   uniformRegions      - Define image regions uniformly
%   updateWeight        - Update ray weights
%   visibleSet          - Set of visible landmarks
