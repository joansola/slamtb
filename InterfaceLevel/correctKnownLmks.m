function [Rob,Sen,Lmk,Obs] = correctKnownLmks(Rob, Sen, Raw, Lmk, Obs, Opt)

%  CORRECTKNOWNLMKS  Correct known landmarks.
%    [Rob,Sen,Lmk,Obs] = correctKnownLmks(Rob, Sen, Raw, Lmk, Obs, Opt) returns the new
%    robot, and the modified observation after some updates with landmark
%    observations OBS.
%       Rob:  the robot
%       Sen:  the sensor
%       Raw:  the raw datas issues from SEN
%       Lmk:  the set of landmarks
%       Obs:  the observation structure for the sensor SEN
%       Opt:  the algorithm options
%
%    TODO: help.
%
%    See also PROJECTLMK, PROJEUCPNTINTOPINHOLEONROB, IDP2P.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% steps in this function
% 0- update Rob and Sen info from Map
% 1- project all landmarks
% 2- select landmarks to correct. For each one:
% 3- do feature matching. If feature found:
% 4- compute innovation.
% 5- perform consistency test. If it is OK:
% 6- do correction

% 0. UPDATE ROB AND SEN INFO FROM MAP
Rob = map2rob(Rob);
Sen = map2sen(Sen);

% 1. PROJECT ALL LMKS - get all expectations
Sen.imGrid.usedCell(:) = false;
for lmk = find([Lmk.used])

    Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk),Opt);
    
    % Prepare for active initialization - use tesselated image
%     Sen = prepareForActiveInit(Sen,Obs(lmk));

end ; % --- all landmarks are now projected.

vis = [Obs.vis];

if any(vis) % Consider only visible observations

    % 2. SELECT LMKS TO CORRECT
    [lmksToObs,lmksToSkip] = selectLmksToObserve(Obs(vis),Opt.correct.nUpdates);

    % lmks to skip, update Obs info
    [Obs(lmksToSkip).measured] = deal(false);
    [Obs(lmksToSkip).matched]  = deal(false);
    [Obs(lmksToSkip).updated]  = deal(false);

    for lmk = lmksToObs % for each landmark to correct

        % Update Lmk search counter
        Lmk(lmk).nSearch = Lmk(lmk).nSearch + 1;

        % 3. TRY TO MATCH FEATURE
        Obs(lmk) = matchFeature(Sen,Raw,Obs(lmk));

        if Obs(lmk).matched

            % Update Lmk matched counter
            Lmk(lmk).nMatch = Lmk(lmk).nMatch + 1;

            % 4. COMPUTE INNOVATIONS
            Rob = map2rob(Rob);
            Sen = map2sen(Sen);

            if Opt.correct.reprojectLmks
                % re-project landmark for improved Jacobians
                Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk),Opt);
            end

            Obs(lmk) = observationInnovation(Obs(lmk),Opt.correct.lines.innType);

            % 5. CHECK CONSISTENCE
            if Obs(lmk).inn.MD2 < Opt.correct.MD2th

                % Update Lmk inlier counter
                Lmk(lmk).nInlier = Lmk(lmk).nInlier + 1;

                % 6. LANDMARK CORRECTION
                % fully correct landmark - EKF, reparam. and off-filter
                [Rob,Sen,Lmk(lmk),Obs(lmk)] = correctLmk(...
                    Rob,      ...
                    Sen,      ...
                    Lmk(lmk), ...
                    Obs(lmk), ...
                    Opt          );
                
            else % obs is inconsistent - do not update

                Obs(lmk).updated = false;

            end % if consistent

        end % if matched

        % Conditional landmark deletion
        [Lmk(lmk),Obs(lmk)] = smartDeleteLmk(Lmk(lmk),Obs(lmk));

    end % for lmk = lmkList

end % if any(vis)

end % function




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

