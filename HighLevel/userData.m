
% USERDATA  User data for universal SLAM.
%   Edit this script to enter the information you need for SLAM. Variable
%   names and comments should make this file easy to understand. Follow
%   these guidelines:
%
%   * Specify site, run and estimation details
%   * Specify sampling time and start and end frames.
%   * Use as many robots and sensors as you wish.
%   * Assign sensors to robots via Sen{i}.robot.
%   * Use field Sens{i}.d for radial distortion parameters if desired.
%   * Define one instance of each landmark type you wish to use. Use the
%   field Lmk{i}.naxNbr to specify the maximum number of such landmarks
%   that the SLAM map must support.
%
%   See further comments within the file for more detailed information.
%
%   NOTE: You can have multiple copies of this file with different names to
%   store different simulation conditions. Just modify the call in
%   UNIVERSALSLAM to point to the 'USERDATA' file you want.
%
%   See also UNIVERSALSLAM.

%   (c) 2009 Joan Sola @ LAAS-CNRS

% Experiment names 
%   - site name, series gathered, estimation run number 
Experiment = struct(...
    'site',                 'sitename',...  % Name of the site
    'dataRun',              1,...           % Run # on this site
    'estimateRun',          1,...           % slam run for data and site
    'lmkTypes',             'idp',...       % types of landmarks used
    'sensingType',          'mono',...      % sensing mode
    'mappingType',          'single');      % mapping mode

% Time variables 
%   - sampling time, first and last frames
Time = struct(...
    'dt',                   .1,...          % sampling time
    'firstFrame',           1,...           % first frame #
    'lastFrame',            50);            % last frame #

% Simulated world
%   - Simulation landmark sets, playground dimensions
World = struct(...
    'xMin',                 -10,...         % playground limits
    'xMax',                 10,...
    'yMin',                 -10,...
    'yMax',                 10,...
    'zMin',                 -10,...
    'zMax',                 10,...
    'points',               thickCloister(-5,5,-5,5,1,9));  % point lmks

% Sensor things 
%   - each sensor's type and parameters, noise, non-measurable prior.
%   - Sensor types (add new type strings if you need more):
%       'pinHole'   Pin-hole camera
Sensor{1} = struct(...
    'id',                   1,...           % sensor identifier
    'name',                 'Micropix',...      % sensor name
    'type',                 'pinHole',...   % type of sensor
    'robot',                1,...           % robot where it is mounted
    'position',             [0;0;.6],...    % position in robot
    'orientationDegrees',   [-90;0;-90],...   % orientation in robot, roll pitch yaw
    'positionStd',          [0;0;0],...     % position error std
    'orientationStd',       [0;0;0],...     % orient. error std
    'imageSize',            [640;480],...   % image size
    'pixErrorStd',          1.0,...         % pixel error std
    'intrinsic',            [320;240;200;200],...   % intrinsic params
    'distortion',           [],...          % distortion params
    'frameInMap',           false);         % add sensor frame in slam map?
Sensor{2} = struct(...
    'id',                   2,...           % sensor identifier
    'name',                 'Micropix',...      % sensor name
    'type',                 'pinHole',...   % type of sensor
    'robot',                2,...           % robot where it is mounted
    'position',             [0;-0.15;.6],...     % position in robot
    'orientationDegrees',   [-90;0;-90],...     % orientation in robot, roll pitch yaw
    'positionStd',          [0;0;0],...     % position error std
    'orientationStd',       [0;0;0],...     % orient. error std
    'imageSize',            [640;480],...   % image size
    'pixErrorStd',          1.0,...         % pixel error std
    'intrinsic',            [320;240;200;200],...   % intrinsic params
    'distortion',           [],...          % distortion params
    'frameInMap',           true );         % add sensor frame in slam map?
% Sensor{3} = struct(...
%     'id',                   3,...           % sensor identifier
%     'name',                 'Micropix',...      % sensor name
%     'type',                 'pinHole',...   % type of sensor
%     'robot',                2,...           % robot where it is mounted
%     'position',             [0;0.15;.6],...     % position in robot
%     'orientationDegrees',   [-90;0;-90],...     % orientation in robot, roll pitch yaw
%     'positionStd',          [0;0;0],...     % position error std
%     'orientationStd',       [0;0;0],...     % orient. error std
%     'imageSize',            [640;480],...   % image size
%     'pixErrorStd',          1.0,...         % pixel error std
%     'intrinsic',            [320;240;200;200],...   % intrinsic params
%     'distortion',           [],...          % distortion params
%     'frameInMap',           false );         % add sensor frame in slam map?

% Robot things with their controls
%   - each robot's type and initial config, controls.
%   - motion models (add new model strings if you need more):
%       'constVel'    6D Constant velocity model
%       'odometry'    6D Odometry model
Robot{1} = struct(...
    'id',                   1,...           % robot identifier
    'name',                 'Dala',...      % robot name
    'type',                 'atrv',...      % type of robot
    'motion',               'constVel',...  % motion model
    'position',             [1;0;0],...     % robot position in map
    'orientationDegrees',   [0;0;45],...     % orientation, in degrees, roll pitch yaw.
    'positionStd',          [0;0;0],...     % position error, std
    'orientationStd',       [0;0;0],...     % orient. error, std
    'velocity',             [1;0;0],...     % lin. velocity
    'angularVelDegrees',    [0;0;10],...     % ang. velocity
    'velStd',               [0;0;0],...     % lin. vel. error, std
    'angVelStd',            [0;0;0],...     % ang. vel. srroe, std
    'dv',                   [1;0;0],...     % veolcity increment
    'dwDegrees',            [0;0;0],...     % ang. vel. increment, degrees
    'dvStd',                [0;0;0],...     % vel perturbation std
    'dwStd',                [0;0;1]);       % ang vel pert. std, degrees
Robot{2} = struct(...
    'id',                   2,...           % robot identifier
    'name',                 'Dala',...      % robot name
    'type',                 'atrv',...      % motion model, type of robot
    'motion',               'odometry',...  % motion model
    'position',             [0;0;0],...     % robot position in map
    'orientationDegrees',   [0;0;0],...     % orientation, in degrees, roll pitch yaw.
    'positionStd',          [0;0;0],...     % position error, std
    'orientationStd',       [0;0;0],...     % orient. error, std
    'velocity',             [0;0;0],...     % lin. velocity
    'angularVelDegrees',    [0;0;0],...     % ang. velocity
    'velStd',               [0;0;0],...     % lin. vel. error, std
    'angVelStd',            [0;0;0],...     % ang. vel. srroe, std
    'dx',                   [1;0;0],...     % position increment
    'daDegrees',            [0;0;5],...     % angle increment, degrees
    'dxStd',                [0;0;0],...     % vel perturbation std
    'daStd',                [0;0;1]);       % ang vel pert. std, degrees


% Landmark things 
%   - landmark types, max nbr of lmks, lmk management options
%   - types of lmks (add 6-letter string types if you need more):
%       'eucPnt'  Euclidean 3D point
%       'idpPnt'  Inverse-depth 3D point
%       'homPnt'  Homogeneous 3D point
%       'plkLin'  Plucker 3D line
Landmark{1} = struct(...
    'type',                 'idpPnt',...    % type of landmark
    'nonObsMean',           2,...           % mean of non obs. for initialization
    'nonObsStd',            0.5,...         % std of non obs for initialization
    'maxNbr',               15);            % max. nbr. of lmks of this type in map
Landmark{2} = struct(...
    'type',                 'eucPnt',...    % type of landmark
    'maxNbr',               80);            % max. nbr. of lmks of this type in map


% Visualization options 
%   - view, projection, video, ellipses.
%   - figure projections:
%       'persp'     Perspective
%       'ortho'     Orthographic
%   - Figure views
%       [a,e,f]     Custom azimuth/elevation/FOV vector. Distance automatic
%       [a,e,f,d]   custom az/el/fov/distance vector.
%   - Figure predefined views (edit mapObserver.m to create/edit views):
%       'top'       Top view
%       'side'      Side view
%       'view'      Generic view
%       'normal'    Normal view
MapFigure = struct(...
    'renderer',             'opengl',...    % renderer
    'projection',           'persp',...     % projection of the 3d figure
    'view',                 [30 30 40 15]); % viewpoint
SensorFigure{1} = struct(...
    'ellipses',             true);          % show 3d ellipsoids?
Video = struct(...
    'createVideo',          false);         % create video sequence?


% Estimation options 
%   - random, reprojection, active search, etc
Estimation = struct(...
    'random',               true,...        % use true random generator?
    'fixedRandomSeed',      1,...           % random seed for non-random runs
    'reprojectLmks',        true,...        % reproject lmks after active search?
    'warpMethod',           'jacobian');    % patch warping method

