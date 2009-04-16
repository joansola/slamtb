function [Rob,Sen,Lmk,Obs] = observeKnownLmks(Rob, Sen, Raw, Lmk, Obs)

%  OBSERVEKNOWNLMKS update what can be done with non-first observations.
%    [ROB,OBS] = observeKnownLmks(ROB, SEN, RAW, LMK, OBS) returns the new
%    robot, and the modified observation after some updates wrt landmark
%    observations OBS.
%       ROB:  the robot
%       Sen:  the sensor
%       Raw:  the raw datas issues from SEN
%       LMK:  the set of landmarks
%       OBS:  the observation structure for the sensor SEN
%
%   TODO: help.
%
%    See also PROJECTLMK, PROJEUCPNTINTOPINHOLEONROB, IDP2P.

global Map

% steps in this function
% 1- project all landmarks
% 2- select landmarks to observe. For each one:
% 3- do feature matching. If feature found:
% 4- compute innovation.
% 5- perform consistency test. If it is OK:
% 6- do EKF correction


% 1. PROJECT ALL LMKS - get all expectations
for lmk = find([Lmk.used])

    Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk));

end ;
% --- all landmarks are now projected.

vis = [Obs.vis]; 

if any(vis) % Consider only visible observations

    % 2. SELECT LMKS TO OBSERVE
    lmksToObs = selectLmksToObserve(Obs(vis),10); % observe maximum 10 landmarks.

    for lmk = lmksToObs % for each landmark to observe
        
        % 3. MATCH FEATURE
        Obs(lmk) = matchFeature(Raw,Obs(lmk));

        if Obs(lmk).matched
        
            % 4. COMPUTE INNOVATIONS
            Obs(lmk) = observationInnovation(Obs(lmk));

            % 5. TEST CONSISTENCE
            if Obs(lmk).inn.MD2 < 3^2 % TODO: put a soft value here via e.g. Opt.inn.MD2th

                % 6. CORRECT EKF
                % re-project landmark for improved Jacobians
                Obs(lmk) = projectLmk(Rob,Sen,Lmk(lmk),Obs(lmk));
                
                % TODO: all EKF correct things (edit correctLmk.m)
                [Rob,Sen,Lmk(lmk),Obs(lmk)] = correctLmk(Rob,Sen,Lmk(lmk),Obs(lmk));
                
                % TODO: transfer IDP to EUC if possible
                [Lmk(lmk),Obs(lmk)] = reparametrizeLmk(Lmk(lmk),Obs(lmk));
                
            else
                
                Obs(lmk).updated = false;
                
            end % if consistent
            
        end % if matched
        
    end % for lmk = lmkList

end % if any(vis)

end % function









% TODO supress above:: here just for some programming helpers.
%
%
%             % get all known point ID
%             usedIdpsIndexesInLmk   = find(usedIdps);
%             usedIdpIds   = [Lmk(usedIdpsIndexesInLmk).id];
%             rawIds   = Raw.data.ids;
%             % TODO: replace intersect by a likehood on the signature.
%             [knowIds,knowIdsIdx] = intersect(rawIds,usedIdpIds);
%                                                          % setdiff(A, B)
%                                                          % returns the
%                                                          % values in A
%                                                          % that are not
%                                                          % in B.
%                                                          % intersect(A, B)
%                                                          % returns the
%                                                          % values common
%                                                          % to both A and B.
%
%              % test if we saw known points in Raw
%              if ~isempty(knowIds)
%
%
%
%                 % DETECT FEATURE
%                 newId    = newIds(1);
%                 newIdx   = newIdsIdx(1);
%
%                 % bet new point coordinates and covariance
%                 y        = Raw.data.points(:,newIdx);
%                 R        = Sen.par.pixCov;
%
%                 % fill Obs struct
%                 Obs(:,lmk).sen      = Sen.sen;
%                 Obs(:,lmk).sid      = Sen.id;
%                 Obs(:,lmk).lid      = newId;
%                 Obs(:,lmk).meas.y   = y;
%                 Obs(:,lmk).meas.R   = R;
%                 Obs(:,lmk).exp.e    = y;
%                 Obs(:,lmk).exp.E    = R;
%                 Obs(:,lmk).app.curr = newId;
%                 Obs(:,lmk).app.pred = newId;
%                 Obs(:,lmk).vis      = true;
%                 Obs(:,lmk).measured = true;
%                 Obs(:,lmk).matched  = true;
%                 Obs(:,lmk).updated  = true;
%
%                 % INIT LMK
%                 inv_depth_nob = Lmk(lmk).nom.n ;
%                 [idp, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = ...
%                     retroProjectIdpPntFromPinHoleOnRob( ...
%                     Rob.frame, ...
%                     Sen.frame, ...
%                     Sen.par.k, ...
%                     Sen.par.d, ...
%                     y, ...
%                     inv_depth_nob) ;
%
%
%
%                 Lmk(lmk).id      = newId;
%                 Lmk(lmk).used    = true;
%                 Lmk(lmk).state.x = idp ;
%                 Lmk(lmk).sig     = newId;
%
%
%                 % TODO put better variance-covariance matrix
%                 Rpix = Sen.par.pixCov ;
%                 Rnob = Lmk(lmk).nom.N ;
%                 % if the sensor frame is in the state
%                 % IDPmap = [IDPrf IDPsf] ;
%                 IDPmap = IDPrf ;
%                 % if the sensor frame is in the state
%                 % Rmap = Map.P([Rob.frame.r;Sen.frame.r],[Rob.frame.r;Sen.frame.r]) ;
%                 Rmap = Map.P(Rob.frame.r,Rob.frame.r) ;
%
%                 % var_covar LL
%                 Lmk(lmk).state.P  = ...
%                     IDPpix*Rpix*IDPpix' + ...  % by pixel cov
%                     IDPrho*Rnob*IDPrho' + ...  % by nob   cov
%                     IDPmap*Rmap*IDPmap'     ;  % by map   cov
%
%                 % covar_LX
%                 P_RX = Map.P(Rob.frame.r,find(Map.used)) ;
%                 P_LX = IDPrf*P_RX ;
%
%                 % frame range in Map
%                 Lmk(lmk).state.r = addToMap(Lmk(lmk).state.x,Lmk(lmk).state.P,P_LX);
%              end