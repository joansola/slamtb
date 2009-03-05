% USERDATA  User data for universal SLAM.
%   Edit this file to enter the information you need for SLAM. Variable
%   names and comments should make this file easy to understand. Follow
%   these guidelines:
%
%   * Specify site, run and estimation details
%   * Specify sampling time and start and end frames.
%   * Use as many robots and sensors as you wish.
%   * Assign sensors to robots via Rob{i}.sensorList.
%   * Use field Sens{i}.d for radial distortion parameters if desired.
%   * Define one instance of each landmark type you wish to use. Use the
%   field Lmk{i}.naxNbr to specify the maximum number of such landmarks
%   that the SLAM map must support.

%   (c) 2009 Joan Sola @ LAAS-CNRS

% Experiment names 
%   - site name, series gathered, estimation run number 
Experiment = struct(...
    'site',                 'expname',...   % Name of the site
    'dataRun',              1,...           % Run nbr on site
    'estimateRun',          1,...           % slam run for data and site
    'lmkTypes',             'idp',...       % types of landmarks used
    'sensingType',          'mono',...      % sensing mode
    'mappingType',          'single');      % mapping mode

% Time variables 
%   - sampling time, first and last frames
Time = struct(...
    'dt',                   1,...           % sampling time
    'firstFrame',           1,...           % first frame #
    'lastFrame',            100);           % last frame #

% Simulated world
%   - Simulation landmark sets, playground dimensions
World = struct(...
    'xMin',                 -20,...         % playground limits
    'xMax',                 20,...
    'yMin',                 -20,...
    'yMax',                 20,...
    'zMin',                 -10,...
    'zMax',                 20,...
    'points',               thickCloister(-5,5,-5,5,2,9),...    % point lmks
    'segments',             zeros(6,0));    % segment lmks

% Sensor things 
%   - each sensor's type and parameters, noise, non-measurable prior
Sensor{1} = struct(...
    'id',                   1,...           % sensor identifier
    'name',                 'Micropix',...      % sensor name
    'type',                 'pinHole',...   % type of sensor
    'position',             [0;0.15;1],...     % position in robot
    'orientationDegrees',   [-90;0;-90],...     % orientation in robot, roll pitch yaw
    'positionStd',          [0;0;0],...     % position error std
    'orientationStd',       [0;0;0],...     % orient. error std
    'imageSize',            [640;480],...   % image size
    'pixErrorStd',          1.0,...         % pixel error std
    'intrinsic',            [320;320;200;200],...   % intrinsic params
    'distortion',           [],...          % distortion params
    'frameInMap',           false);         % add sensor frame in slam map?
Sensor{2} = struct(...
    'id',                   2,...           % sensor identifier
    'name',                 'Micropix',...      % sensor name
    'type',                 'pinHole',...   % type of sensor
    'position',             [0;-0.15;1],...     % position in robot
    'orientationDegrees',   [-90;0;-90],...     % orientation in robot, roll pitch yaw
    'positionStd',          [0;0;0],...     % position error std
    'orientationStd',       [0;0;0],...     % orient. error std
    'imageSize',            [640;480],...   % image size
    'pixErrorStd',          1.0,...         % pixel error std
    'intrinsic',            [320;320;200;200],...   % intrinsic params
    'distortion',           [],...          % distortion params
    'frameInMap',           true );         % add sensor frame in slam map?

% Robot things 
%   - each robot's type and initial config, controls
Robot{1} = struct(...
    'id',                   1,...           % robot identifier
    'name',                 'Dala',...      % robot name
    'type',                 'atrv',...      % type of robot
    'motion',               'constVel',...  % motion model
    'position',             [1;0;0],...     % robot position in map
    'orientationDegrees',   [0;0;45],...     % orientation, in degrees, roll pitch yaw.
    'positionStd',          [0;0;0],...     % position error, std
    'orientationStd',       [0;0;0],...     % orient. error, std
    'velocity',             [0;0;0],...     % lin. velocity
    'angularVelDegrees',    [0;0;0],...     % ang. velocity
    'velStd',               [0;0;0],...     % lin. vel. error, std
    'angVelStd',            [0;0;0],...     % ang. vel. srroe, std
    'sensors',              [1]);             % list of sensors in robot
Robot{2} = struct(...
    'id',                   2,...           % robot identifier
    'name',                 'Dala',...      % robot name
    'type',                 'atrv',...      % motion model, type of robot
    'motion',               'constVel',...  % motion model
    'position',             [0;0;0],...     % robot position in map
    'orientationDegrees',   [0;0;0],...     % orientation, in degrees, roll pitch yaw.
    'positionStd',          [0;0;0],...     % position error, std
    'orientationStd',       [0;0;0],...     % orient. error, std
    'velocity',             [0;0;0],...     % lin. velocity
    'angularVelDegrees',    [0;0;0],...     % ang. velocity
    'velStd',               [0;0;0],...     % lin. vel. error, std
    'angVelStd',            [0;0;0],...     % ang. vel. srroe, std
    'sensors',              [2]);             % list of sensors in robot

% Control things
%   - each robot has a control structure
Control{1} = struct(...
    'robot',                [],...          % robot id to be applied
    'motion',               'constVel',...  % motion model
    'dv',                   [1;0;0],...     % veolcity increment
    'dwDegrees',            [0;0;0],...     % ang. vel. increment, degrees
    'dvStd',                [0;0;0],...     % vel perturbation std
    'dwStd',                [0;0;0]);       % ang vel pert. std, degrees

% Landmark things 
%   - landmark types, max nbr of lmks, lmk management options
Landmark{1} = struct(...
    'type',                 'idpPnt',...    % type of landmark
    'nonObsMean',           1e-5,...        % mean of non obs. for initialization
    'nonObsStd',            0.5,...         % std of non obs for initialization
    'maxNbr',               20);            % max. nbr. of lmks of this type in map
Landmark{2} = struct(...
    'type',                 'eucPnt',...    % type of landmark
    'maxNbr',               100);           % max. nbr. of lmks of this type in map
    
% Visualization options 
%   - view, projection, video, ellipses
MapFigure = struct(...
    'renderer',             'opengl',...    % renderer
    'projection',           'persp',...     % projection of the 3d figure
    'view',                 'norm');        % viewpoint
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

