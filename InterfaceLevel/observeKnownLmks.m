
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

switch Sen.type

    % camera pinHole
    case {'pinHole'}

        
        % get a known Idp lmk
        usedLmks = [Lmk.used];
        idps     = strcmp({Lmk.type},'idpPnt');
        usedIdps = idps & usedLmks;


        % foreach known idp point :
        % 1- prediction step
        % 2- compare with existing observation (innovation exist?)
        % 3- choose one lmk to observe in ekf process
        % 4- do the ekf update step only for this one
        
        % PROJECT ALL LMKS
        if any(usedIdps)
            for lmk = find(usedIdps)
                
                % IDP --> Point3D
                %    -(value and variance-covariance)-
                lr        = Lmk(lmk).state.r(1:6) ;   % lmk range in Map
                idp       = Map.x(lr) ;               % lmk (idp)
                COV_idp   = Map.P(lr,lr) ;            % cov lmk (idp)
                [p,P_idp] = idp2p(idp) ;              % idp -> p
                COV_P     = P_idp*COV_idp*P_idp' ;    % cov lmk (p)
                
                % Point3D --> pixel
                %   -(value and Jacobians)-
                [pix, depth, PIX_rf, PIX_sf, PIX_k, PIX_d, PIX_p] = ...
                    projEucPntIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    p) ;
                
                vis = isVisible(pix,depth,Sen.par.imSize);
                
                % VARIANCE-COVARIANCE in pixel view
                rfr      = Rob.frame.r ;     % robot frame range
                R        = Sen.par.pixCov ;  % sensor cov
                COV_rf   = Map.P(rfr,rfr) ;  % robot frame cov
                
                % TODO : treat the case where sensor frame is in the state
                %
                COV_pix = R + ...                      % pixel cov obtained                  
                          PIX_rf*COV_rf*PIX_rf' + ...  % by incertaincies
                          PIX_p*COV_P*PIX_p' ;         % and jacobians.
                
                % modify the Obs object for view graphic
                Obs(:,lmk).exp.e  = pix ;
                Obs(:,lmk).exp.E  = COV_pix ;
                Obs(:,lmk).vis    = vis ;
%                 Obs(:,lmk).app.pred = Lmk(lmk).sig; %% TODO: app.curr in better way

            end ;
        end ;
        
        % MATCH FEATURES
        
        % COMPUTE INNOVATIONS
        
        % TEST CONSISTENCE
        
        % CORRECK EKF
        
    % unknown Sen.type
    % ----------------
    otherwise
        
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);

end % sensor type

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