% USERDATAGRAPH  User data for SLAMTB_GRAPH.
%   Edit this script to enter the information you need for SLAM. Variable
%   names and comments should make this file easy to understand. Follow
%   these guidelines:
%
%   * Specify site and estimation details for the current run in ExpOpt.
%   * Specify sampling time and start and end frames in Tim.
%   * Use as many robots and sensors as you wish with Robot{} and Sensor{}.
%   * Assign sensors to robots via Sensor{i}.robot.
%   * Use field Sensor{i}.distortion for radial distortion parameters if
%   desired.
%   * Use the field Opt.map.numLmk and .lmkSize to specify the maximum
%   number of landmarks that the SLAM map must support.
%   * Use Opt.init.initType to select the type of landmarks to use. Try
%   with one in this list:
%       'eucPnt'.
%   * Use World.points to create artificial worlds of points or segments.
%   Check function THICKCLOISTER.
%
%   See further comments within the file for more detailed information.
%
%   NOTE: You can have multiple copies of this file with different names to
%   store different simulation conditions. Just modify the call in SLAMTB
%   to point to the particular 'USERDATA' file you want.
%
%   See also SLAMTB, EULERANGLES, THICKCLOISTER, USERDATA, USERDATAPNT,
%   USERDATALIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2015-     Joan Sola @ IRI-CSIC-UPC.

% Time variables 
%   - sampling time, first and last frames
Time = struct(...
  'dt',                   .1,...          % sampling time, seconds
  'firstFrame',           1,...           % first frame #
  'lastFrame',            1200);          % last frame #

% Simulated world
%   - Simulation landmark sets, playground dimensions

% Cage + Floor
World = struct(...
  'points',           [ YZWall(-30,30,0,20,-30,15,6) YZWall(-30,30,0,20,30,15,6) XZWall(-26,26,0,20,-30,13,6) XZWall(-26,26,0,20,30,13,6) XYWall(-26,26,-26,26,0,13,13)], ... % 3d point landmarks - see YZHALLWAY and YZWALL
  'segments',         []);  % 3D segments - see HOUSE. 

% % Long hallway with far wide wall
% World = struct(...
%   'points',           [ YZHallway(-2,2,-1,3,0,90,20) YZWall(-60,60,0,10,95,15,6) ], ... % 3d point landmarks - see YZHALLWAY and YZWALL
%   'segments',         []);  % 3D segments - see HOUSE. 

% % Thick Cloister
% World = struct(...
%   'points',           thickCloister(-6,6,-6,6,1,7),... % 3d point landmarks - see THICKCLOISTER. 
%   'segments',         []);  % 3D segments - see HOUSE. 

% % Several Thick Cloisters with different sizes
% World = struct(...
%   'points',           [thickCloister(-6,6,-6,6,1,7) thickCloister(-12,12,-12,12,1,13) thickCloister(-18,18,-18,18,1,19)],... % 3d point landmarks - see THICKCLOISTER. 
%   'segments',         []);  % 3D segments - see HOUSE. 

% Robot things with their controls
%   - each robot's type and initial configuration, and controls.
%   - motion models (add new model strings if you need more):
%       'constVel'    6D Constant velocity model
%       'odometry'    6D Odometry model
%       'inertial'    6D IMU-based model
%   - See EULERANGLES for orientations specifications.

% Robot in a S trajectory
Robot{1} = struct(...                  % ODOMETRY EXAMPLE
  'id',                 1,...           % robot identifier
  'name',               'Dala',...      % robot name
  'type',               'atrv',...      % type of robot
  'motion',             'odometry',...  % motion model
  'position',           [0;-10;0.0],...     % robot position in map
  'orientationDegrees', [0;0;0],...     % orientation, in degrees, [roll; pitch; yaw].
  'positionStd',        [0;0;0],...     % position error, std
  'orientationStd',     [0;0;0],...     % orient. error, std, in degrees
  'dx',                 repmat([.08;0;0],1,1200),...     % position increment
  'daDegrees',          ...               % angle increment, degrees
    [repmat([0;0;0],1,200) repmat([0;0;.9],1,200) repmat([0;0;0],1,400) repmat([0;0;-.9],1,200) repmat([0;0;0],1,200) ], ...
  'dxStd',              0.005*[1;1;1],...  % odo linear error std
  'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees


% % Robot inside thick cloister
% Robot{1} = struct(...                  % ODOMETRY EXAMPLE
%   'id',                 1,...           % robot identifier
%   'name',               'Dala',...      % robot name
%   'type',               'atrv',...      % type of robot
%   'motion',             'odometry',...  % motion model
%   'position',           [0;-5;0.0],...     % robot position in map
%   'orientationDegrees', [0;0;0],...     % orientation, in degrees, [roll; pitch; yaw].
%   'positionStd',        [0;0;0],...     % position error, std
%   'orientationStd',     [0;0;0],...     % orient. error, std, in degrees
%   'dx',                 [.08;0;0],...     % position increment
%   'daDegrees',          [0;0;.9],...     % angle increment, degrees
%   'dxStd',              0.005*[1;1;1],...  % odo linear error std
%   'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees

% % Robot moving around thick cloister
% Robot{1} = struct(...                  % ODOMETRY EXAMPLE
%   'id',                 1,...           % robot identifier
%   'name',               'Dala',...      % robot name
%   'type',               'atrv',...      % type of robot
%   'motion',             'odometry',...  % motion model
%   'position',           [0;-11;0],...     % robot position in map
%   'orientationDegrees', [0;0;0],...     % orientation, in degrees, [roll; pitch; yaw].
%   'positionStd',        [0.1;0.1;0.1],...     % position error, std
%   'orientationStd',     [0.001;0.001;0.001],...     % orient. error, std, in degrees
%   'dx',                 [0.1728;0;0],...     % position increment
%   'daDegrees',          [0;0;.9],...     % angle increment, degrees
%   'dxStd',              0.005*[1;1;1],...  % odo linear error std
%   'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees

% % Tilted robot inside thick cloister
% Robot{1} = struct(...                  % ODOMETRY EXAMPLE
%   'id',                 1,...           % robot identifier
%   'name',               'Dala',...      % robot name
%   'type',               'atrv',...      % type of robot
%   'motion',             'odometry',...  % motion model
%   'position',           [0;-5;0.5],...     % robot position in map
%   'orientationDegrees', [-90;0;-90],...     % orientation, in degrees, [roll; pitch; yaw].
%   'positionStd',        [0;0;0],...     % position error, std
%   'orientationStd',     [0;0;0],...     % orient. error, std, in degrees
%   'dx',                 [0;0;.08;],...     % position increment
%   'daDegrees',          [0;-0.9;0;],...     % angle increment, degrees
%   'dxStd',              0.005*[1;1;1],...  % odo linear error std
%   'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees

% % Robot moving forward
% Robot{1} = struct(...                  % ODOMETRY EXAMPLE
%   'id',                 1,...           % robot identifier
%   'name',               'Dala',...      % robot name
%   'type',               'atrv',...      % type of robot
%   'motion',             'odometry',...  % motion model
%   'position',           [0;0;0],...     % robot position in map
%   'orientationDegrees', [0;0;0],...     % orientation, in degrees, [roll; pitch; yaw].
%   'positionStd',        [0;0;0],...     % position error, std
%   'orientationStd',     [0;0;0],...     % orient. error, std, in degrees
%   'dx',                 [.08;0;0],...     % position increment
%   'daDegrees',          [0;0;0],...     % angle increment, degrees
%   'dxStd',              0.005*[1;1;1],...  % odo linear error std
%   'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees

% Robot{2} = struct(...                  % ODOMETRY EXAMPLE
%   'id',                 2,...           % robot identifier
%   'name',               'Dala',...      % robot name
%   'type',               'atrv',...      % type of robot
%   'motion',             'odometry',...  % motion model
%   'position',           [0;5;0],...     % robot position in map
%   'orientationDegrees', [0;0;180],...     % orientation, in degrees, [roll; pitch; yaw].
%   'positionStd',        [0;0;0],...     % position error, std
%   'orientationStd',     [0;0;0],...     % orient. error, std, in degrees
%   'dx',                 [.08;0;0],...     % position increment
%   'daDegrees',          [0;0;.9],...     % angle increment, degrees
%   'dxStd',              0.005*[1;1;1],...  % odo linear error std
%   'daStd',              0.05*[1;1;1]);      % odo ang error std, degrees



% Sensor things 
%   - each sensor's type and parameters, noise, non-measurable prior.
%   - Sensor types (add new type strings if you need more):
%       'pinHole'       Pin-hole camera
%       'pinHoleDepth'  Pin-hole camera with depth measurement (RGBD)
%   - See EULERANGLES for orientations specifications.

% Camera on top, loking forward
Sensor{1} = struct(...
  'id',                 1,...           % sensor identifier
  'name',               'Micropix',...  % sensor name
  'type',               'pinHole',...   % type of sensor
  'robot',              1,...           % robot where it is mounted
  'position',           [0;0;1.4],...    % position in robot
  'orientationDegrees', [-90;0;-90],... % orientation in robot, [roll; pitch; yaw]
  'positionStd',        [0;0;0],...     % position error std
  'orientationStd',     [0;0;0],...     % orient. error std
  'imageSize',          [640;480],...   % image size
  'pixErrorStd',        1.0,...         % pixel error std
  'intrinsic',          [320;240;320;320],... % intrinsic params [u0 v0 au av]
  'distortion',         [],...          % distortion params
  'frameInMap',         false,...       % add sensor frame in slam map?
  'imGrid',               struct(...      % grid for Active Search
    'numCells',         [8;6],...         % number of H and V grid cells
    'skipOuter',        true));           % skip outer cells for initialization?

% % Camera on top, loking sideways
% Sensor{1} = struct(...
%   'id',                 1,...           % sensor identifier
%   'name',               'Micropix',...  % sensor name
%   'type',               'pinHole',...   % type of sensor
%   'robot',              1,...           % robot where it is mounted
%   'position',           [0;0;.6],...    % position in robot
%   'orientationDegrees', [-90;0;0],... % orientation in robot, [roll; pitch; yaw]
%   'positionStd',        [0;0;0],...     % position error std
%   'orientationStd',     [0;0;0],...     % orient. error std
%   'imageSize',          [640;480],...   % image size
%   'pixErrorStd',        1.0,...         % pixel error std
%   'intrinsic',          [320;240;320;320],... % intrinsic params [u0 v0 au av]
%   'distortion',         [],...          % distortion params
%   'frameInMap',         false,...       % add sensor frame in slam map?
%   'imGrid',               struct(...      % grid for Active Search
%     'numCells',         [8;6],...         % number of H and V grid cells
%     'skipOuter',        true));           % skip outer cells for initialization?

% % Camera on center, looking forward 
% Sensor{1} = struct(...
%   'id',                 1,...           % sensor identifier
%   'name',               'Micropix',...  % sensor name
%   'type',               'pinHole',...   % type of sensor
%   'robot',              1,...           % robot where it is mounted
%   'position',           [0;0;0],...    % position in robot
%   'orientationDegrees', [-90;0;-90],... % orientation in robot, [roll; pitch; yaw]
%   'positionStd',        [0;0;0],...     % position error std
%   'orientationStd',     [0;0;0],...     % orient. error std
%   'imageSize',          [640;480],...   % image size
%   'pixErrorStd',        1.0,...         % pixel error std [pixels]
%   'depthErrorStd',      0.5,...         % depth error std [m]
%   'intrinsic',          [320;240;320;320],... % intrinsic params [u0 v0 au av]
%   'distortion',         [],...          % distortion params, e.g. [-0.3;0.1]
%   'frameInMap',         false,...       % add sensor frame in slam map?
%   'imGrid',             struct(...      % grid for Active Search
%     'numCells',         [8;6],...         % number of H and V grid cells
%     'skipOuter',        true));           % skip outer cells for initialization?

% % Camera on center, no rotation
% Sensor{1} = struct(...
%   'id',                 1,...           % sensor identifier
%   'name',               'Micropix',...  % sensor name
%   'type',               'pinHole',...   % type of sensor
%   'robot',              1,...           % robot where it is mounted
%   'position',           [0;0;0],...    % position in robot
%   'orientationDegrees', [0;0;0],... % orientation in robot, [roll; pitch; yaw]
%   'positionStd',        [0;0;0],...     % position error std
%   'orientationStd',     [0;0;0],...     % orient. error std
%   'imageSize',          [640;480],...   % image size
%   'pixErrorStd',        1.0,...         % pixel error std [pixels]
%   'depthErrorStd',      0.5,...         % depth error std [m]
%   'intrinsic',          [320;240;320;320],... % intrinsic params [u0 v0 au av]
%   'distortion',         [],...          % distortion params, e.g. [-0.3;0.1]
%   'frameInMap',         false,...       % add sensor frame in slam map?
%   'imGrid',             struct(...      % grid for Active Search
%     'numCells',         [8;6],...         % number of H and V grid cells
%     'skipOuter',        true));           % skip outer cells for initialization?



% Estimation options 
Opt = struct(...
  'map',              struct(...    % options for the map
    'type',           'graph',...    % type of map {'ekf','graph'}
    'useGtsam',       true,...       % use GTSAM as optimization backend
    'gtsam',          struct(...      % options to gtsam (mostly related to ISAM2)
      'incremental',  true,...        % is gtsam in incremental mode (using ISAM2) or in batch mode?
      'verboseCheirality', true,...     % print messages when the point is projected behind the camera
      'throwCheirality',   false,...    % throw an error when the point is projected behind the camera
      'relinearizeSkip', 1,...          % relinearize every 'relinearizeSkip' ISAM2 updates ('default' selects GTSAM default value: 10)
      'relinearizeTh',   0.0,...        % threshold to decide to relinearize a variable ('default' selects GTSAM default value: 0.1)
      'factorization',   'CHOLESKY',... % factorization used to do matrix decomposition {'CHOLESKY', 'QR'}
      'nonlinearOptimizer', 'DOGLEG',...    % nonlinear optimizer used {'GAUSSNEWTON', 'DOGLEG'}
      'doglegAdaptationMode', 'SEARCH_EACH_ITERATION',...    % type of adaptation of the trust region used by dogleg {'ONE_STEP_PER_ITERATION', 'SEARCH_EACH_ITERATION'}
      'wildfireTh', 0.0),...            % Stop updating the linear delta if the changes are below this threshold ('default' selects GTSAM default value: 0.001 for GAUSSNEWTON, 1e-5 for DOGLEG)
    'numLmks',        size(World.points,2) + 1,...         % number of 3d landmarks
    'numFrames',      100,...         % number of frames in graph
    'kfrmPeriod',     20),...        % period between keyframes
  'solver',           struct(...    % graph solver
    'decomposition',  'Cholesky',...        % Matrix decomposition {'Cholesky', 'QR', 'Schur'}
    'niterations',    1,...           % number of iterations
    'target_dres',    1e-2,...        % exit criterion for residual variation
    'target_res',     1e-3),...       % exit criterion for current residual
  'correct',          struct(...    % options for lmk correction
    'reprojectLmks',  false,...       % reproject lmks after active search?
    'reparametrize',  true,...       % reparametrize lmk?
    'nUpdates',       20,...          % max simultaneus updates
    'MD2th',          9,...          % Threshold on Mahalanobis distance squared
    'linTestIdp',     0.1,...        % threshold on IDP linearity test
    'lines',          struct(...     % options for line corrections
      'innType',      'ortDst',...    % innovation type for lines
      'extPolicy',    false,...       % line extending policy ?
      'extSwitch',    10)),...        % extension policy switch point in pixels
  'init',             struct(...    % Options for initialization
    'nbrInits',       [20 5],...      % number of inits [firstFrame, otherFrames]
    'initType',       'papPnt',...   % Type of lmk to use for init
    'idpPnt',         struct(...     % options for lmk initialization
      'nonObsMean',   .1,...         % mean of non obs
      'nonObsStd',    .5),...         % std of non obs
    'papPnt',         struct(...     % options for pap lmks
      'allowDistAnc', false,...     % allow landmark with distant anchors?
      'maxAncDistKf', 10,...       % max distance in keyframes between anchors (only used if 'allowDistAnc' is not set)
      'minParTh',     .0333,...       % minimal parallax to add the point (using rule of thumb: b/h = 1/30)
      'noReanchorTh', .5),...         % minimal parallax to stop reanchoring a point
    'plkLin',         struct(...     % opt. for Plucker and anchored Plucker lines init
      'nonObsMean',   [.1;0],...      % mean of non obs
      'nonObsStd',    [.25;1])),...   % std of non obs
  'obs',              struct(...    % Observation options
    'lines',          struct(...     % lines options
      'minLength',    20)));          % minimum segment length
          

% Simulation options
%   - random
SimOpt = struct(...                    
  'random',           struct(...      % random generator options
    'newSeed',        true,...         % select new random seed?
    'fixedSeed',      209369,...       % random seed for non-random runs
    'seed',           []),...          % current seed
  'obs',              Opt.obs);       % Observation options



% Figure options  
%   - view, projection, video, ellipses.
%   - figure projections - mapProj:
%       'persp'     Perspective
%       'ortho'     Orthographic
%   - 3D figure views - mapView - see MAPOBSERVER.
%       [a,e,f]     Custom azimuth/elevation/FOV vector. Distance automatic
%       [a,e,f,d]   custom az/el/fov/distance vector.
%   - 3D figure predefined views (edit mapObserver.m to create/edit views):
%       'top'       Top view
%       'side'      Side view
%       'view'      Generic view
%       'normal'    Normal view
%   - objects colors - two options for color specification:
%       'rgbcmykw'  1-char predifined Matlab colors
%       [r g b]     RGB color vector. [0 0 0] is black, [1 1 1] is white.
FigOpt = struct(...
  'renderer',       'zbuffer',...    % renderer
  'rendPeriod',     20,...           % frames to skip for faster processing
  'createVideo',    false,...       % create video sequences?
  'map',            struct(...      % map figure options
    'size',         [320 240],...   % map figure size
    'lims',         struct(...      % playground limits
      'xMin',            -35,...
      'xMax',             35,...
      'yMin',            -35,...
      'yMax',             35,...
      'zMin',            -30,...
      'zMax',             30),...
    'proj',         'persp',...     % projection of the 3d figure {'persp', 'ortho'}
    'view',         'view',...      % viewpoint of the 3d figure [30 45 40 20]
    'orbit',        [0 0],...       % Azimuth and Elevation orbit angle increments - use to animate figure
    'showSimLmk',   true,...        % show simulated landmarks?
    'showLmkId',    true,...        % Show landmark id?
    'showEllip',    false,...        % show ellipsoids?
    'showMotFac',   true,...        % show motion factors?
    'showMotLabel', true,...        % show motion factor labels?
    'showMeaFac',   false,...       % show measurement factors?
    'showAncLink',  false,...       % show anchor links for pap lmks?
    'colors',       struct(...      % map figure colors
      'border',     [1 1 1],...      %   [r g b]      
      'axes',       [0 0 0],...      % with:
      'bckgnd',     [1 1 1],...      %   [0 0 0] black
      'simLmk',     .3*[1 1 1],...   %   [1 1 1] white
      'defPnt',     struct(...       % euclidean point colors
        'mean',     'b',...           % mean dot
        'ellip',    [.7 .7 1]),...    % ellipsoid
      'othPnt',     struct(...       % other point colors
        'mean',     'r',...           % mean dot
        'ellip',    [1 .7 .7]),...    % ellipsoid
      'defLin',     struct(...       % Plucker line colors
        'mean',     [0 .8 0],...      % mean line
        'ellip',    [.6 1 .6]),...    % ellipsoid
      'othLin',     struct(...       % Plucker line colors
        'mean',     [.8 0 0],...      % mean line
        'ellip',    [1 .6 .6]),...    % ellipsoid
      'graph',      struct(...       % graph
        'frame',    'b',...           % frame
        'motion',   'b',...           % motion factors
        'meas',     [1 .8 .6]),...          % measurement factors
      'mainLink',   [1 0 0],...      %   [r g b]
      'assoLink',   [0 1 1],...      %   [r g b]
      'simu',       'b',...          %   or 'r', 'b', etc.   
      'est',        'g',...          % estimated robots and sensors
      'ground',     [.8 .8 .8],...   % simulated robots and sensors
      'label',      [.0 .5 0])),...  % landmark ID labels
  'sensor',         struct(...      % sensor figures options
    'size',         [320 240],...    % sensor figure size
    'showEllip',    false,...        % show ellipses?
    'colors',       struct(...       % Sensor figure colors:
      'border',     .8*[1 1 1],...    %    
      'axes',       [0 0 0],...       % 
      'bckgnd',     [1 1 1],...       %
      'raw',        .3*[1 1 1],...    % 
      'defPnt',     struct(...       % Default point colors
        'updated',  'c',...           % updated
        'predicted','b'),...          % predicted
      'othPnt',     struct(...       % other point colors
        'updated',  'r',...           % updated
        'predicted','m'),...          % predicted
      'defLin',     struct(...       % Default line colors
        'meas',     'b',...           % measurement
        'mean',     'g',...           % mean line
        'ellip',    'y'),...          % ellipsoid
      'othLin',     struct(...       % other line colors
        'meas',     'b',...           % measurement
        'mean',     'm',...           % mean line
        'ellip',    'r'),...          % ellipsoid
      'label',      [.5 .5 .5])));    %


% Experiment options 
%   - site name, series gathered, estimation run number 
ExpOpt = struct(...
  'root',         '~/SLAM/',...         % root directory
  'site',         'simu',...            % Name of the site
  'dataRun',      1,...                 % Run # on this site
  'estimateRun',  1,...                 % slam run for data and site
  'lmkTypes',     Opt.init.initType,... % types of landmarks used
  'sensingType',  'mono',...            % sensing mode
  'mappingType',  'single');            % mapping mode



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

