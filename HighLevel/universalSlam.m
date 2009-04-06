% UNIVERSALSLAM  An EKF-SLAM algorithm with simulator and graphics.
%
%   This script performs multi-robot, multi-sensor, multi-landmark 6DOF
%   EKF-SLAM with simulation and graphics capabilities.
%
%   Please read slamToolbox.pdf in the root directory thoroughly before
%   using this toolbox.
%
%   Beginners should not modify this file, just edit USERDATA.M and enter
%   the data you wish to simulate.
%
%   More advanced users should be able to create new landmark models, new
%   initialization methods, and possibly extensions to multi-map SLAM. Good
%   luck!
%
%   Expert users may want to add code for real-data experiments. Please try
%   active-search techniques for vision, they are amazingly faster and
%   robust.
%
%   See also USERDATA. 
%
%   Also consult slamToolbox.pdf in the root directory.

%   Created and maintained by
%   (c) 2009 Joan Sola @ LAAS-CNRS. jsola@laas.fr.
%   Programmers:
%   (c) David Marquez and Jean-Marie Codol @ LAAS-CNRS

% clear workspace and declare globals
clear
global Map          %#ok<NUSED>

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m
userData;   % user-defined data. SCRIPT.

%% II. Initialize all data structures from user-defined data in userData.m
% SLAM data
[Rob,Sen,Lmk,Obs,Tim]  = createSlamStructures(...
    Robot,...
    Sensor,...      % all user data
    Landmark,...
    Time);                    
% Simulation data
[SimRob,SimSen,SimLmk] = createSimStructures(...
    Robot,...
    Sensor,...      % all user data
    World);                   
% Graphics handles
[MapFig,SenFig]        = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...      % SLAM data
    SimRob, SimSen, SimLmk,...  % Simulator data
    FigureOptions);             % User-defined graphic options

%% III. Init data logging
% TODO: Create source and/or destination files and paths for data input and
% logs.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

% Clear user data - not needed anymore
% clear Robot Sensor Landmark FigureOptions World Time Experiment Video Estimation

% ----------------------------------------------------
% Create test Lmks       
% FIXME: these lines to be removed, they are here just to have
% something to plot in the map figure.
%
id          = 195;     % We'll simulate Lmk ID is in the map...
lmk         = 60;      % and in the Lmk array at this index.

Lmk(lmk).id = id; % Simulate landmark exists in map in position index lmk.

lidx  =  find([SimLmk.ids] == id); % get lmk index in simulated lmks array
xyz   =  SimLmk.points(:,lidx);    % get lmk 3D position
XYZ   =  diag([.03 .02 .01]);      % get covariances
r     =  addToMap(xyz,XYZ);        % put it in the map
 
Lmk(lmk).state.r = r;              % Lmk range in Map
Lmk(lmk).used    = true;           % Lmk is used
%
% FIXME: remove up to this line ----------------------



%% IV. Main loop
for currentFrame = Tim.firstFrame : Tim.lastFrame
    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % FIXME: this is hard-coded. Should be done better as part of the simulator.
    Rob(1).con.u = [.1;0;0;0;0;0.05];
%     Rob(2).con.u = [0;0;0;0;0;0];

    % Simulate robots
    for rob = 1:numel(SimRob)

        % Simulate sensor observations
        for sen = SimRob(rob).sensors

            % Observe simulated landmarks
            SimObs(sen) = SimObservation(SimRob(rob), SimSen(sen), SimLmk) ;

        end % end process sensors

        % Robot motion
        % FIXME: see how to include noise in a clever way.
        SimRob(rob).con.u = Rob(rob).con.u + Rob(rob).con.uStd.*randn(6,1);
        SimRob(rob) = motion(SimRob(rob),Tim);

    end % end process robots


    % 2. ESTIMATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Process robots
    for rob = 1:numel(Rob)

        % Process sensor observations
        for sen = Rob(rob).sensors

            % Observe knowm landmark
            % obsKnownLmks;

            % Initialize new landmarks
            % initNewLmks;
%             Rob(rob) = map2rob(Rob(rob));
            Lmk = initNewLmks(Rob(rob), Sen(sen), SimObs(sen), Lmk) ;

            % update Observation to update visually components
            Obs(sen) = updateObsInSlamProcess(Obs(sen), Lmk) ;

        end % end process sensors

        % Robot motion
        Rob(rob) = motion(Rob(rob),Tim);

    end % end process robots

    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % ---------------------------------------------------
    % Create test Obs 
    % FIXME: these lines to be removed, they are here just to have
    % something to plot in the sensors figures.
    %
    lmk  = find([Lmk.id] == id);
    for sen = 1:numel(Sen)
        oidx = find(SimObs(sen).ids == id);
        if ~isempty(oidx)
            Obs(sen,lmk)  = testObs(Obs(sen,lmk), SimObs(sen).points(:,oidx), 5^2*eye(2));
            Obs(sen,lmk).lid = id;
        else
            Obs(sen,lmk).vis = false;
        end
    end
    %
    % FIXME: remove up to this line ----------------------
    
    % Figure of the Map:
    drawMapFig(MapFig, Rob, Sen, Lmk, SimRob, SimSen);

    % Figures for all sensors
    drawSenFig(SenFig, Sen, Lmk, Obs, SimObs);

    % Do draw all objects
    drawnow;


    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO: do something here to collect data for post-processing or
    % plotting. Think about collecting data in files using fopen, fwrite,
    % etc., instead of creating large Matlab variables for data logging.

end

%% V. Post-processing
