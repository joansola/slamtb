% SLAMTBSLAVE  A slave version of SLAMTB.
%
%   SLAMTBSLAVE is intended to be invoked by other scripts initializing
%   some of the parameters. By now it is NEESANALYSIS the only one to do
%   so.
%
%   See also NEESANALYSIS, NEESPLOTS.

%   Created and maintained by
%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Programmers:
%   Copyright David Marquez and Jean-Marie Codol @ LAAS-CNRS

%% OK we start here

% clear workspace and declare globals
%clear
global Map          %#ok<NUSED>

%% I. Specify user-defined options - EDIT USER DATA FILE userData.m

userDataPnt;        % user-defined data. SCRIPT.
% userDataLin;        % user-defined data. SCRIPT.

% These inputs come from neesAnalysis and overwrite some userData values:
Time.lastFrame            = numFrames;
Opt.init.initType         = lmkType;
Opt.correct.reparametrize = reparametrize;
SimOpt.random.newSeed     = false;
SimOpt.random.fixedSeed   = randSeeds(nRun);
FigOpt.rendPeriod         = rendPeriod;
Sensor{1}.pixErrorStd     = pixelNoise;

%% II. Initialize all data structures from user-defined data in userData.m
% SLAM data
[Rob,Sen,Raw,Lmk,Obs,Tim]     = createSlamStructures(...
    Robot,...
    Sensor,...      % all user data
    Time,...
    Opt);

% Simulation data
[SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(...
    Robot,...
    Sensor,...      % all user data
    World,...
    SimOpt);

% Graphics handles
[MapFig,SenFig]               = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...      % SLAM data
    SimRob, SimSen, SimLmk,...  % Simulator data
    FigOpt);                    % User-defined graphic options


%% III. Init data logging
% TODO: Create source and/or destination files and paths for data input and
% logs.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

logFile = openLogFile(logFileName,'w');
writeLogHeader(logFile,logFileHeader);

% Clear user data - not needed anymore
clear Robot Sensor World Time   % clear all user data


%% IV. Main loop
for currentFrame = Tim.firstFrame : Tim.lastFrame
    
    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Simulate robots
    for rob = [SimRob.rob]

        % Robot motion
        SimRob(rob) = simMotion(SimRob(rob),Tim);
        
        % Simulate sensor observations
        for sen = SimRob(rob).sensors

            % Observe simulated landmarks
            Raw(sen) = simObservation(SimRob(rob), SimSen(sen), SimLmk, SimOpt) ;

        end % end process sensors

    end % end process robots

    

    % 2. ESTIMATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Process robots
    for rob = [Rob.rob]

        % Robot motion
        % FIXME: see how to include noise in a clever way.
        Rob(rob).con.u = SimRob(rob).con.u + Rob(rob).con.uStd.*randn(6,1)*noiseFactor;

        Rob(rob) = motion(Rob(rob),Tim);

        % Process sensor observations
        for sen = Rob(rob).sensors

            %TODO: see how to pass only used Lmks and Obs.
            % Observe knowm landmarks
            [Rob(rob),Sen(sen),Lmk,Obs(sen,:)] = correctKnownLmks( ...
                Rob(rob),   ...
                Sen(sen),   ...
                Raw(sen),   ...
                Lmk,        ...   
                Obs(sen,:), ...
                Opt) ;

            % Initialize new landmarks
            if currentFrame == Tim.firstFrame
                numInit = Opt.init.nbrInits(1);
            else
                numInit = Opt.init.nbrInits(2);
            end
            for ini = 1:numInit
                [Lmk,Obs(sen,:)] = initNewLmk(...
                    Rob(rob),   ...
                    Sen(sen),   ...
                    Raw(sen),   ...
                    Lmk,        ...
                    Obs(sen,:), ...
                    Opt) ;
            end

        end % end process sensors

    end % end process robots


    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if currentFrame == Tim.firstFrame ...
            || currentFrame == Tim.lastFrame ...
            || mod(currentFrame,FigOpt.rendPeriod) == 0
        
        % Figure of the Map:
        MapFig = drawMapFig(MapFig,  ...
            Rob, Sen, Lmk,  ...
            SimRob, SimSen, ...
            FigOpt);
        
        makeVideoFrame(MapFig, ...
            sprintf('map-%04d.png',currentFrame), ...
            FigOpt, ExpOpt);

        % Figures for all sensors
        for sen = [Sen.sen]
            SenFig(sen) = drawSenFig(SenFig(sen), ...
                Sen(sen), Raw(sen), Obs(sen,:), ...
                FigOpt);
            
            makeVideoFrame(SenFig(sen), ...
                sprintf('sen%02d-%04d.png', sen, currentFrame),...
                FigOpt, ExpOpt);

        end

        % Do draw all objects
        drawnow;
    end
    


    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO: do something here to collect data for post-processing or
    % plotting. Think about collecting data in files using fopen, fwrite,
    % etc., instead of creating large Matlab variables for data logging.
    
    % NEES for robot 1
    logData = errorAnalysis(Rob(1), SimRob(1), errorAnalysisFunction);
%     logData = robotNees(Rob(1),SimRob(1));
    writeLogData(logFile,[currentFrame,logData]);

end

%% V. Post-processing

closeLogFile(logFile); 



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

