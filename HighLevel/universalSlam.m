% SLAM wireframe - a universal SLAM algorithm.
%
%   


%   (c) 2009 Joan Sola @ LAAS-CNRS

% clear workspace and declare globals
clear
global Map

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m
userData;

%% II. Initialize data structures from user data
% Create robots and controls
Rob = createRobots(Robot);
Con = createControls(Robot);

% Create sensors
Sen = createSensors(Sensor);

% Install sensors in robots
[Rob,Sen] = installSensors(Rob,Sen);

% Create Landmarks and non-observables
Lmk = createLandmarks(Landmark);
% Nob = createNonObservables(Landmark);

% Create Map - empty
Map = createMap(Rob,Sen,Lmk);

% Initialize robots and sensors in Map
Rob = initRobots(Rob);
Sen = initSensors(Sen);

% Create Observations (matrix: [ line=sensor , colums=landmark ])
Obs = createObservations(Sen,Lmk);

% Create time variables
Tim = createTime(Time);


%% III. Initialize simulation structures
% Create robots and controls
SimRob = createRobots(Robot);

% Create sensors
SimSen = createSensors(Sensor);

% Install sensors in robots
[SimRob,SimSen] = installSensors(SimRob,SimSen);

% Create world
SimLmk = createSimLmk(World);

% Create source and/or destination files and paths

%% IV. Initialize graphics objects
% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,MapFigure);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SensorFigure);

% Init data logging plots

%% V. Temporal loop
for currentFrame = Tim.firstFrame : Tim.lastFrame
    
    % 1. SIMULATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % FIXME: this is hard/coded. Should be done better.
    Con(1).u = [0;0;0;0;0;0];
    Con(2).u = [.1;0;0;0;0;0.05];
    
    % Simulate robots
    for rob = 1:numel(SimRob)
        
        % Simulate sensor observations
        for sen = SimRob(rob).sensors
            
            % Observe simulated landmarks
            SimObs(sen) = SimObservation(SimRob(rob), SimSen(sen), SimLmk) ;
 
            % SimRobObserve(rob, sens, Obs(rob));
                
        end % end process sensors
        
        % Robot motion
        % FIXME: see how to include noise in a clever way.
        SimCon(rob).u = Con(rob).u + Con(rob).uStd.*randn(6,1);
        SimRob(rob) = motion(SimRob(rob),SimCon(rob),Tim.dt);
        
    end % end process robots
    
    
    % 2. ESTIMATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Process robots
    for rob = 1:numel(Rob)

        % Process sensor observations
        for sens = Rob(rob).sensors

            % Observe knowm landmark
            %obsKnownLmks;
                
            % Initialize new landmarks
            %initNewLmks;
            
        end % end process sensors
        
        % Robot motion
            Rob(rob) = motion(Rob(rob),Con(rob),Tim.dt);
        
    end % end process robots

    % 3. VISUALIZATION 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create test Obs
    % FIXME: these two lines to be removed, they are here just to have
    % something to plot in the sensors figures.
    Obs(1,1)  = testObs(Obs(1,1)); 
    Obs(1,25) = testObs(Obs(1,25), [350;50], [5^2,0;0,10^2]); 
    
    % Figure of the Map:
    MapFig = drawMapFig(MapFig, Rob, Sen, Lmk, SimRob, SimSen) ;
    
    % Figures for each sensors
    SenFig = drawSenFig(SenFig, Obs, Sen, Lmk, SimObs) ;
    
    drawnow;
    
    
    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%% VI. Post-processing
