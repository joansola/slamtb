% SLAM wireframe - an EKF-SLAM algorithm with simulator and graphics.
%
%   See also USERDATA.

%   Created and maintained by
%   (c) 2009 Joan Sola @ LAAS-CNRS. jsola@laas.fr.
%   Programmers:
%   (c) David Marquez and Jean-Marie Codol @ LAAS-CNRS

% clear workspace and declare globals
clear
global Map

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m
userData;   % user-defined data. SCRIPT.

%% II. Initialize all data structures from user data
[Rob,Sen,Lmk,Obs,Tim] = createSLAMstructures(...
    Robot,...
    Sensor,...
    Landmark,...
    Time);     % SLAM data.
[SimRob,SimSen,SimLmk] = createSimStructures(...
    Robot,...
    Sensor,...
    World);      % Simulation data.
[MapFig,SenFig] = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...
    SimRob, SimSen, SimLmk,...
    MapFigure, SensorFigure); % Graphics handles.

%% III. Init data logging 
% TODO: Create source and/or destination files and paths.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

%% IV. Temporal loop
tic
for currentFrame = Tim.firstFrame : Tim.lastFrame
    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % FIXME: this is hard-coded. Should be done better as part of the simulator.
    Rob(1).con.u = [0;0;0;0;0;0];
    Rob(2).con.u = [.1;0;0;0;0;0.05];

    % Simulate robots
    for rob = 1:numel(SimRob)
        
        % Robot motion
        % FIXME: see how to include noise in a clever way.
        SimRob(rob).con.u = Rob(rob).con.u + Rob(rob).con.uStd.*randn(6,1);
        SimRob(rob) = motion(SimRob(rob),SimRob(rob).con,Tim.dt);

        % Simulate sensor observations
        for sen = SimRob(rob).sensors

            % Observe simulated landmarks
            SimObs(sen) = SimObservation(SimRob(rob), SimSen(sen), SimLmk) ;

        end % end process sensors

    end % end process robots


    % 2. ESTIMATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Sample period
    Tim.dt = samplePeriod;

    % Process robots
    for rob = 1:numel(Rob)

        % Process sensor observations
        for sen = Rob(rob).sensors

            % Observe knowm landmark
            % obsKnownLmks;

            % Initialize new landmarks
            % initNewLmks;
            Lmk = initNewLmks(Rob(rob), Sen(sen), SimObs(sen), Lmk) ;

        end % end process sensors

        % Robot motion
        Rob(rob) = motion(Rob(rob),Rob(rob).con,Tim.dt);

    end % end process robots

    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create test Obs
    % FIXME: these lines to be removed, they are here just to have
    % something to plot in the sensors figures.
    id         = 195;
    Lmk(23).id = id; % Simulate landmark exists in map in position index 23.
    lmk  = find([Lmk.id] == id);
    for sen = 1:numel(Sen)
        oidx = find(SimObs(sen).ids == id);
        if ~isempty(oidx)
            Obs(sen,lmk)  = testObs(Obs(sen,lmk), SimObs(sen).points(:,oidx), [5^2,0;0,5^2]);
            Obs(sen,lmk).lid = id;
        else
            Obs(sen,lmk).vis = false;
        end
    end

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
