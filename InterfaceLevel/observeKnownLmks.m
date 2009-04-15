
function [RobNew,Obs] = observeKnownLmks(Rob, Sen, Raw, Lmk, Obs)

%  OBSERVEKNOWNLMKS update what can be done with non-first observations.
%    [ROBNEW,OBS] = observeKnownLmks(ROB, SEN, RAW, LMK, OBS) returns the
%    new robot, and the modified observation after some updates wrt
%    landmark observations OBS.
%       ROB:  the robot
%       Sen:  the sensor
%       Raw:  the raw datas issues from SEN
%       LMK:  the set of landmarks
%       OBS:  the observation structure for the sensor SEN
%
%    See also PROJEUCPNTINTOPINHOLEONROB, IDP2P.

global Map

% foreach known idp point :
% 1- prediction step
% 2- compare with existing observation (innovation exist?)
% 3- choose one lmk to observe in ekf process
% 4- do the ekf update step only for this one


% 1. PROJECT ALL LMKS - get all expectations
for lmk = find([Lmk.used])

    % get landmark range and mean
    lr = Lmk(lmk).state.r ;        % lmk range in Map
    l  = Map.x(lr) ;               % lmk mean

    % explore all sensor and landmark types
    switch Sen.type

        case {'pinHole'} % camera pinHole

            switch Lmk(lmk).type

                case {'idpPnt'} % inverse depth point

                    % IDP --> pixel
                    %   -(value and Jacobians)-
                    [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                        projIdpPntIntoPinHoleOnRob( ...
                        Rob.frame, ...
                        Sen.frame, ...
                        Sen.par.k, ...
                        Sen.par.d, ...
                        l) ;

                    vis = isVisible(e,depth,Sen.par.imSize);
                    R   = Sen.par.pixCov ;  % sensor cov


                case {'eucPnt'} % euclidean point

                    % Point3D --> pixel
                    %   -(value and Jacobians)-
                    [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                        projEucPntIntoPinHoleOnRob( ...
                        Rob.frame, ...
                        Sen.frame, ...
                        Sen.par.k, ...
                        Sen.par.d, ...
                        l) ;

                    vis = isVisible(e,depth,Sen.par.imSize);
                    R   = Sen.par.pixCov ;  % sensor cov


                otherwise % unknown landmark type for pin hole sensor
                    error('??? Landmark type ''%s'' non implemented for sensor ''%s''.',Lmk(lmk).type,Sen.type);

            end


        otherwise % unknown Sensor type
            error('??? Unknown sensor type ''%s''.',Sen.type);

    end % sensor type


    % Rob-Sen-Lmk range and Jacobian
    if Sen.frameInMap
        rslr  = [Rob.frame.r ; Sen.state.r ; lr]; % range of robot, sensor, and landmark
        E_rsl = [E_rf E_sf E_l];
    else
        rslr  = [Rob.frame.r ; lr];               % range of robot and landmark
        E_rsl = [E_rf E_l];
    end

    % Expectation covariances matrix
    E = E_rsl*Map.P(rslr,rslr)*E_rsl' + R ;

    % modify the Obs object for view graphic
    Obs(lmk).lid     = Lmk(lmk).id ;
    Obs(lmk).sid     = Sen.id ;
    Obs(lmk).exp.e   = e ;
    Obs(lmk).exp.E   = E ;
    Obs(lmk).vis     = vis ;
    Obs(lmk).Jac.E_r = E_rf;
    Obs(lmk).Jac.E_s = E_sf;
    Obs(lmk).Jac.E_l = E_l;
    %                 Obs(lmk).app.pred = Lmk(lmk).sig; %% TODO: app.curr in better way

end ;


% 2. SELECT LMKS TO OBSERVE

% 3. MATCH FEATURES

% 4. COMPUTE INNOVATIONS

% 5. TEST CONSISTENCE

% 6. CORRECK EKF


RobNew = Rob ;

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