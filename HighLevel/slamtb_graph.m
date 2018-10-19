% SLAMTB_GRAPH  A graph-SLAM algorithm with simulator and graphics.
%
%   This script performs multi-robot, multi-sensor, multi-landmark 6DOF
%   graph-SLAM with simulation and graphics capabilities.
%
%   Please read slamToolbox.pdf and courseSLAM.pdf in the root directory
%   thoroughly before using this toolbox.
%
%   - Beginners should not modify this file, just edit USERDATA_GRAPH.M and
%   enter and/or modify the data you wish to simulate.
%
%   See also USERDATAGRAPH, SLAMTB.
%
%   Also consult slamToolbox.pdf and courseSLAM.pdf in the root directory.

%   Created and maintained by
%   Copyright 2008, 2009, 2010 Joan Sola @ LAAS-CNRS.
%   Copyright 2011, 2012, 2013 Joan Sola.
%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.
%   Programmers (for parts of the toolbox):
%   Copyright David Marquez and Jean-Marie Codol @ LAAS-CNRS
%   Copyright Teresa Vidal-Calleja @ ACFR.
%   See COPYING.TXT for full copyright license.

%% OK we start here

% clear workspace and declare globals
clear
global Map    

%% I. Specify user-defined options - EDIT USER DATA FILE userDataGraph.m

userDataGraph;           % user-defined data. SCRIPT.


%% II. Initialize all data structures from user-defined data
% SLAM data
[Rob,Sen,Raw,Lmk,Obs,Trj,Frm,Fac,Tim] = createGraphStructures(...
    Robot,...
    Sensor,...
    Time,...
    Opt);

% Pre-allocate all relative-motion robots:
factorRob = Rob;

% Simulation data
[SimRob,SimSen,SimLmk,SimOpt] = createSimStructures(...
    Robot,...
    Sensor,...      % all user data
    World,...
    SimOpt);

% Graphics handles
[MapFig,SenFig]               = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...      % SLAM data
    Trj, Frm, Fac, ...
    SimRob, SimSen, SimLmk,...  % Simulator data
    FigOpt);                    % User-defined graphic options

% Clear user data - not needed anymore
clear Robot Sensor World Time   % clear all user data

%% III. Initialize data logging
% TODO: Create source and/or destination files and paths for data input and
% logs.
% TODO: do something here to collect data for post-processing or
% plotting. Think about collecting data in files using fopen, fwrite,
% etc., instead of creating large Matlab variables for data logging.

%% IV. Startup 
% TODO: Possibly put in initRobots and createFrames, createFactors, createTrj...
for rob = [Rob.rob]
    
    % Reset relative motion robot
    factorRob(rob) = resetMotion(Rob(rob));
    
    % Add first keyframe with absolute factor
    Rob(rob).state.P = 1e-6 * eye(7); % Give 1cm error
    [Rob(rob),Lmk,Trj(rob),Frm(rob,:),Fac] = addKeyFrame(...
        Rob(rob),       ...
        Lmk,            ...
        Trj(rob),       ...
        Frm(rob,:),     ...
        Fac,            ...
        factorRob(rob), ...
        'absolute');
    
    for sen = Rob(rob).sensors
        
        % Initialize new landmarks
        ninits = Opt.init.nbrInits(1);
        for i = 1:ninits
            
            % Observe simulated landmarks
            Raw(sen) = simObservation(SimRob(rob), SimSen(sen), SimLmk, SimOpt) ;
            
            % Init new lmk
            fac = find([Fac.used] == false, 1, 'first');
            
            % Compute and allocate lmk
            [Lmk,Obs(sen,:),Frm(rob,Trj(rob).head),Fac(fac),lmk] = initNewLmk(...
                Rob(rob),   ...
                Sen(sen),   ...
                Raw(sen),   ...
                Lmk,        ...
                Obs(sen,:), ...
                Frm(rob,Trj(rob).head), ...
                Fac(fac),        ...
                Opt) ;
            
            if isempty(lmk)
                break
            end
            
        end
        
    end % end process sensors
    
    
end


%% V. Main loop
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
    
    % 2.a. Robot motion prediction

    % Process robots
    for rob = [Rob.rob]

        % Robot motion

        % NOTE: in a regular, non-simulated SLAM, this line is not here and
        % noise just comes from the real world. Here, the estimated robot
        % is noised so that the simulated trajectory can be made perfect
        % and act as a clear reference. The noise is additive to the
        % control input 'u'.
        Rob(rob).con.u = ...
            SimRob(rob).con.u + Rob(rob).con.uStd.*randn(size(Rob(rob).con.uStd));
        
        Rob(rob) = simMotion(Rob(rob),Tim);
        
        % Integrate odometry for relative motion factors
        factorRob(rob).con.u = Rob(rob).con.u;
        factorRob(rob) = integrateMotion(factorRob(rob),Tim);
        
    end
    
    % Advance time
    Map.t = Map.t + Tim.dt;
    
    
    % 2.b. Graph construction and solving
    
    if mod(currentFrame - Tim.firstFrame + 1, Opt.map.kfrmPeriod) == 0
            
        % Process robots
        for rob = [Rob.rob]
            
            % Add key frame
            [Rob(rob),Lmk,Trj(rob),Frm(rob,:),Fac] = addKeyFrame(...
                Rob(rob),       ...
                Lmk,            ...
                Trj(rob),       ...
                Frm(rob,:),     ...
                Fac,            ...
                factorRob(rob), ...
                'motion');
            
            % Process sensor observations
            for sen = Rob(rob).sensors
                
                % Observe knowm landmarks
                [Rob(rob),Sen(sen),Lmk,Obs(sen,:),Frm(rob,Trj(rob).head),Fac] ...
                    = addKnownLmkFactors( ...
                    Rob(rob),   ...
                    Sen(sen),   ...
                    Raw(sen),   ...
                    Lmk,        ...
                    Obs(sen,:), ...
                    Frm(rob,Trj(rob).head), ...
                    Fac,        ...
                    Opt) ;
                
                % Initialize new landmarks
                ninits = Opt.init.nbrInits(1 + (currentFrame ~= Tim.firstFrame));
                for i = 1:ninits

                    % Init new lmk
                    [Lmk,Obs(sen,:),Frm(rob,Trj(rob).head),Fac,lmk] = initNewLmk(...
                        Rob(rob),   ...
                        Sen(sen),   ...
                        Raw(sen),   ...
                        Lmk,        ...
                        Obs(sen,:), ...
                        Frm(rob,Trj(rob).head), ...
                        Fac,        ...
                        Opt) ;
                    
                    if isempty(lmk) % Did not find new lmks
                        break
                    end
                    
                end % for i = 1:ninits
                
            end % end process sensors
            
        end % end process robots
        
        % Solve graph
        [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraph(Rob,Sen,Lmk,Obs,Frm,Fac,Opt);
        
        % Reset odometer and sync robot with graph
        for rob = [Rob.rob]
            
            % Update robots with Frm info
            Rob(rob) = frm2rob(Rob(rob),Frm(rob,Trj(rob).head));
            
            % Reset motion robot
            factorRob(rob) = resetMotion(Rob(rob));
        end
        
    end


    % 3. VISUALIZATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if currentFrame == Tim.firstFrame ...
            || currentFrame == Tim.lastFrame ...
            || mod(currentFrame,FigOpt.rendPeriod) == 0
        
        % Figure of the Map:
        MapFig = drawMapFig(MapFig,  ...
            Rob, Sen, Lmk,  ...
            Trj, Frm, Fac, ...
            SimRob, SimSen, ...
            FigOpt);
        
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

%% VI. Post-processing
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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

