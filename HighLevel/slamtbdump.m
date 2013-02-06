% SLAMTB  An EKF-SLAM algorithm with real images and graphics.
%
%   This script performs multi-robot, multi-sensor, multi-landmark 6DOF
%   EKF-SLAM with simulation and graphics capabilities.
%
%   It is intended for demonstration of the SLAM toolbox with points on
%   real images, but skipping the image processing part of the algorithm. 
%   
%   Use this file together with userDataDump.m. In userDataDump, you have
%   at the end the data field ExpOpt.dump, with the following options:
%       > 'simu': dumps, for each frame, a file of the robot's control
%       signal and one file for each sensor containing identifiers and
%       extracted pixels from images.
%       > 'none': not dump. Use dumped files instead to simulate the case
%       of working with real images. See below for file naming and formats.
%
%   Please read slamToolbox.pdf in the root directory thoroughly before
%   using this toolbox.
%
%   DUMPED FILE FORMATS: 
%   For a robot R and sensor S at time T we have:
%       img-RR-SS-TTTTTT.txt with one observed landmark per line:
%           id1  U1  V1
%           id2  U2  V2
%           ...
%       control-RR-TTTTTT.txt with two lines: control vector and covariances matrix:
%           u1 u2 u3 ... un
%           U11 U12 ... U1n U21 U22 ... Unn
%
%   See also USERDATADUMP, SLAMTB, USERDATA.
%
%   Also consult slamToolbox.pdf in the root directory.

%   Created and maintained by
%   Copyright 2008, 2009, 2010, 2011, 2012 Joan Sola @ LAAS-CNRS.
%   Programmers (for the whole toolbox):
%   Copyright David Marquez and Jean-Marie Codol @ LAAS-CNRS
%   Copyright Teresa Vidal-Calleja @ ACFR.
%   See COPYING.TXT for wull copyright license.

%% OK we start here

% clear workspace and declare globals
clear
global Map          %#ok<NUSED>

%% I. Specify user-defined options - EDIT USER DATA FILE userDataImg.m

userDataDump;           % user-defined data. SCRIPT.


%% II. Initialize all data structures from user-defined data in userData.m
% SLAM data
[Rob,Sen,Raw,Lmk,Obs,Tim]     = createSlamStructures(...
    Robot,...
    Sensor,...      % all user data
    Time,...
    Opt);

if strcmp(ExpOpt.dump, 'simu') 
    % We will simulate and dump data into files
    
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
        FigOpt);                    % User-defined options
    
else
    % We will read data from previously dumped files, and fully skip
    % simulations, similar to the "real raw data" case but without raw data
    % preprocessing
    
    % Graphics handles
    [MapFig,SenFig]               = createGraphicsStructures(...
        Rob, Sen, Lmk, Obs,...      % SLAM data
        [], [], [],...              % Simulator data
        FigOpt);                    % User-defined options
end

%% III. Initialize data logging
% TODO: Create source and/or destination files and paths for data input and
% logs.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

% Clear user data - not needed anymore
clear Robot Sensor World Time   % clear all user data


%% IV. Main loop
for currentFrame = Tim.firstFrame : Tim.lastFrame
    

    % 1. SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp(ExpOpt.dump, 'simu') % only if dumping for simulated inputs
        
        % Simulate robots
        for rob = [SimRob.rob]
            
            % Robot motion
            SimRob(rob) = simMotion(SimRob(rob),Tim);
            
            writeControlSignal(SimRob(rob),currentFrame);
            
            % Simulate sensor observations
            for sen = SimRob(rob).sensors
                
                % Observe simulated landmarks
                Raw(sen) = simObservation(SimRob(rob), SimSen(sen), SimLmk, SimOpt) ;
                
                % write img data to file
                writeProcessedImg(rob,sen,currentFrame,Raw(sen));
                
            end % end process sensors
            
        end % end process robots
        
        
    else % we are not simulating, then we must be estimating
        
        % 2. ESTIMATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Process robots
        for rob = [Rob.rob]
            
            % Robot motion
            % NOTE: in a regular, non-simulated SLAM, this line is not here and
            % noise just comes from the real world. Here, the estimated robot
            % is noised so that the simulated trajectory can be made perfect
            % and act as a clear reference. The noise is additive to the
            % control input 'u'.
            Rob(rob) = readControlSignal(Rob(rob), currentFrame);
%             Rob(rob).con.u = SimRob(rob).con.u + Rob(rob).con.uStd.*randn(size(Rob(rob).con.uStd));
            
            Rob(rob) = motion(Rob(rob),Tim);
            
            
            % Process sensor observations
            for sen = Rob(rob).sensors
                
                % Obtain raw data
                Raw(sen) = readProcessedImg(rob,sen,currentFrame);
                
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
                    ninit = Opt.init.nbrInits(1);
                else
                    ninit = Opt.init.nbrInits(2);
                end
                for i = 1:ninit
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
        
    end
    
    
    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if currentFrame == Tim.firstFrame ...
            || currentFrame == Tim.lastFrame ...
            || mod(currentFrame,FigOpt.rendPeriod) == 0
        
        % Figure of the Map:
        if strcmp(ExpOpt.dump, 'simu') 

            MapFig = drawMapFig(MapFig,  ...
                Rob, Sen, Lmk,  ...
                SimRob, SimSen, ...
                FigOpt);
        else
            MapFig = drawMapFig(MapFig,  ...
                Rob, Sen, Lmk,  ...
                [], [], ...
                FigOpt);
            
        end
        
        if FigOpt.createVideo
            makeVideoFrame(MapFig, ...
                sprintf('map-%04d.png',currentFrame), ...
                FigOpt, ExpOpt);
        end
        
        % Figures for all sensors
        for sen = [Sen.sen]
            SenFig(sen) = drawSenFig(SenFig(sen), ...
                Sen(sen), Raw(sen), Obs(sen,:), ...
                FigOpt);
            
            if FigOpt.createVideo
                makeVideoFrame(SenFig(sen), ...
                    sprintf('sen%02d-%04d.png', sen, currentFrame),...
                    FigOpt, ExpOpt);
            end
            
        end
        
        % Do draw all objects
        drawnow;
    end
    
    
    
    % 4. DATA LOGGING
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % TODO: do something here to collect data for post-processing or
    % plotting. Think about collecting data in files using fopen, fwrite,
    % etc., instead of creating large Matlab variables for data logging.
    
    
end

%% V. Post-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enter post-processing code here



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

%   SLAMTB is Copyright 2007,2008,2009
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

