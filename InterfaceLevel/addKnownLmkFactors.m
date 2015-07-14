function [Rob, Sen, Lmk, Obs, Frm, Fac] = addKnownLmkFactors(Rob, Sen, Raw, Lmk, Obs, Frm, Fac, Opt)

% CORRECTKNOWNLMKS  Correct known landmarks.
%   [Rob,Sen,Lmk,Obs] = correctKnownLmks(Rob, Sen, Raw, Lmk, Obs, Opt)
%   performs EKF corrections to a selection of observations, updating Map,
%   Rob, Sen, Lmk and Obs structures. 
%
%   Input/output structures:
%       Rob:  the robot
%       Sen:  the sensor
%       Raw:  the raw data issued from Sen
%       Lmk:  the set of landmarks
%       Obs:  the set of observations for the sensor Sen
%       Opt:  the algorithm options
%
%   The selection of the landmarks to observe is based on active-search
%   procedures and individual compatibility tests to reject outliers.
%
%   This function takes care of:
%       1. Selection of observations to correct
%       2. Feature matching
%       3. EKF correction
%       4. Correction of landmark parameters out of the EKF
%       5. Landmark re-parametrization
%       6. Landmark deletion in case of corruption
%
%   The algorithm is configurable through a number of options in structure
%   Opt.correct. Edit USERDATA to access and modify these options.
%
%   See also PROJECTLMK, PROJEUCPNTINTOPINHOLEONROB, SMARTDELETELMK.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% steps in this function
% 0- update Rob and Sen info from Map
% 1- project all landmarks
% 2- select landmarks to correct. For each one:
% 3- do feature matching. If feature found:
% 4- compute innovation.
% 5- perform consistency test. If it is OK:
% 6- do correction
% 7- eventually reparametrize landmark


% 0. UPDATE ROB INFO FROM GRAPH
Rob = frm2rob(Rob,Frm);

% 1. PROJECT ALL LMKS - get all expectations
lmksUsed = [Lmk.used];
for lmk = find(lmksUsed)

    Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk),Opt);
    
end  % --- all landmarks are now projected.

% Clear visibility of unused lmks
[Obs(~lmksUsed).vis] = deal(false);


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
            
            % 4. Make and add factors
            fac = find([Fac.used] == false, 1, 'first');
            
            if ~isempty(fac)
            
                [Lmk(lmk), Frm, Fac(fac)] = makeMeasFactor(...
                    Lmk(lmk),               ...
                    Obs(lmk),           ...
                    Frm, ...
                    Fac(fac));
                
                
                % Update Lmk inlier counter
                Lmk(lmk).nInlier = Lmk(lmk).nInlier + 1;
            
            end
            
        end % if matched

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

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

