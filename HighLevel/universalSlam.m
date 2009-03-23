% SLAM wireframe - a universal SLAM algorithm.
%

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
createSLAMstructures;     % SLAM data. SCRIPT.
createSimStructures;      % Simulation data. SCRIPT.
createGraphicsStructures; % Graphics handles. SCRIPT.

%% III. Init data logging 
% TODO: Create source and/or destination files and paths.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

%% IV. Temporal loop
for currentFrame = Tim.firstFrame : Tim.lastFrame

    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % FIXME: this is hard-coded. Should be done better as part of the simulator.
    Con(1).u = [0;0;0;0;0;0];
    Con(2).u = [.1;0;0;0;0;0.05];

    % Simulate robots
    for rob = 1:numel(SimRob)
        
        % Robot motion
        % FIXME: see how to include noise in a clever way.
        SimCon(rob).u = Con(rob).u + Con(rob).uStd.*randn(6,1);
        SimRob(rob) = motion(SimRob(rob),SimCon(rob),Tim.dt);

        % Simulate sensor observations
        for sen = SimRob(rob).sensors

            % Observe simulated landmarks
            SimObs(sen) = SimObservation(SimRob(rob), SimSen(sen), SimLmk) ;

        end % end process sensors

 
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
            Lmk = initNewLmks(Rob(rob), Sen(sen), SimObs(sen), Lmk) ;

        end % end process sensors

        % Robot motion
        Rob(rob) = motion(Rob(rob),Con(rob),Tim.dt);

    end % end process robots

    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create test Obs
    % FIXME: these lines to be removed, they are here just to have
    % something to plot in the sensors figures.
    id   = 190;
    Lmk(23).id = id; % Simulate landmark exists in map in pisition index 3.
    oidx = find(SimObs(2).ids == id);
    lmk  = find([Lmk.id] == id);
    if ~isempty(oidx)
        Obs(2,lmk)  = testObs(Obs(2,lmk), SimObs(2).points(:,oidx), [5^2,0;0,5^2]);
        Obs(2,lmk).lid = id;
    else
        Obs(2,lmk).vis = false;
    end

    % Figure of the Map:
    MapFig = drawMapFig(MapFig, Rob, Sen, Lmk, SimRob, SimSen);

    % Figures for all sensors
    SenFig = drawSenFig(SenFig, Obs, Sen, Lmk, SimObs);

    % Do draw all objects
    drawnow;


    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO: do something here to collect data for post-processing or
    % plotting. Think about collecting data in files using fopen, fwrite,
    % etc., instead of creating large Matlab variables for data logging.

end

%% V. Post-processing
