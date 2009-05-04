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

global Map

% steps in this function
% 0- update Rob and Sen info from Map
% 1- project all landmarks
% 2- select landmarks to correct. For each one:
% 3- do feature matching. If feature found:
% 4- compute innovation.
% 5- perform consistency test. If it is OK:
% 6- do EKF correction

% 0. UPDATE ROB AND SEN INFO FROM MAP
Rob = map2rob(Rob);
Sen = map2sen(Sen);

% 1. PROJECT ALL LMKS - get all expectations
for lmk = find([Lmk.used])

    Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk));

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
        
        % 3. MATCH FEATURE
        Obs(lmk) = matchFeature(Raw,Obs(lmk));

        if Obs(lmk).matched
        
            % 4. COMPUTE INNOVATIONS
            Rob = map2rob(Rob);
            Sen = map2sen(Sen);
            if Opt.correct.reprojectLmks

                % re-project landmark for improved Jacobians
                Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk));
            end
            Obs(lmk) = observationInnovation(Obs(lmk));

            % 5. TEST CONSISTENCE
            if Obs(lmk).inn.MD2 < Opt.correct.MD2th 

                % TODO: see where to put the if Obs.vis ... and the
                % projectLmk().
                % 6. CORRECT EKF
                
                % All EKF correct things
                [Rob,Sen,Lmk(lmk),Obs(lmk)] = correctLmk(Rob,Sen,Lmk(lmk),Obs(lmk));

                % Transform IDP to EUC if possible
                [Lmk(lmk),Obs(lmk)] = reparametrizeLmk(Rob,Sen,Lmk(lmk),Obs(lmk),Opt);

            else % obs is inconsistent - do not update
                
                Obs(lmk).updated = false;
                % TODO: add smarter code to delete bad landmarks
                fprintf('Deleted landmark ''%d''.\n',Lmk(lmk).id)
                [Lmk(lmk),Obs(lmk)] = deleteLmk(Lmk(lmk),Obs(lmk));
                
            end % if consistent
            
        end % if matched
        
    end % for lmk = lmkList
    
end % if any(vis)

end % function

