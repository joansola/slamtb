
function [RobNew,Obs] = observeKnownLmks(Rob, Sen, Raw, Lmk, Obs)

%  OBSERVEKNOWNLMKS update what can be done with non-first observations.
%   ROB = observeKnownLmks(ROB, SEN, SIMOBS, LMK) returns the new robot
%   after some updates wrt some landmark observations.
%
%

global Map

switch Sen.type

    % camera pinHole
    case {'pinHole'}

        
        % get a known Idp lmk
        usedLmks = [Lmk.used];
        idps     = strcmp({Lmk.type},'idpPnt');
        usedIdps = idps & usedLmks;
        lmks     = find(usedIdps);

        % foreach known idp point :
        % 1- prediction step
        % 2- compare with existing observation (innovation exist?)
        % 3- choose one lmk to observe in ekf process
        % 4- do the ekf update step only for this one
        if any(usedIdps)
            for lmk = 1:numel(lmks)
                
                % IDP --> Point3D
                COV_idp = Map.P(Lmk(lmks(lmk)).state.r(1:6),Lmk(lmks(lmk)).state.r(1:6)) ;
                idp = Map.x(Lmk(lmks(lmk)).state.r(1:6)) ;
                [p,P_idp] = idp2p(idp) ;
                COV_P = P_idp*COV_idp*P_idp' ;
                
                % Point3D --> pixel
                [pix, depth, PIX_rf, PIX_sf, PIX_k, PIX_d, PIX_p] = ...
                    projEucPntIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    p) ;
                
                % VARIANCE-COVARIANCE in pixel view
                R        = Sen.par.pixCov;    % sensor instantaneous noise
                COV_rf   = Map.P(Rob.frame.r,Rob.frame.r) ; % robot frame cov
                % TODO : if the sensor frame is in the state
                %COV_sf   = Map.P(Sen.frame.r,Sen.frame.r) ;
                %COV_pix = R + ...
                %          PIX_rf*COV_rf*PIX_rf' + ...
                %          PIX_sf*COV_sf*PIX_sf' ;
                % else
                COV_pix = R + ...
                          PIX_rf*COV_rf*PIX_rf' + ...
                          PIX_p*COV_P*PIX_p' ;
                
                
                Obs(:,lmk).exp.e    = pix       ;
                Obs(:,lmk).exp.E    = COV_pix ;
                %Obs(:,lmk).app.curr = 0;

                
%                 
%                 [U,S,U_R,U_S,U_K,U_D,U_L] = 
%                 
%                  = Lmk(lmk).nom.n ;
%                 [pix_pred, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = ...
%                     retroProjectIdpPntFromPinHoleOnRob( ...
%                     Rob.frame, ...
%                     Sen.frame, ...
%                     Sen.par.k, ...
%                     Sen.par.d, ...
%                     y, ...
%                     inv_depth_nob) ;
%                 prediction = 
                
                % fill Obs struct
                %Obs(:,lmk).sen      = Sen.sen;
                %Obs(:,lmk).sid      = Sen.id;
                %Obs(:,lmk).lid      = newId;
                %Obs(:,lmk).meas.y   = y;
                %Obs(:,lmk).meas.R   = R;
                %Obs(:,lmk).exp.e    = y;
                %Obs(:,lmk).exp.E    = R;
                %Obs(:,lmk).app.curr = newId;
                %Obs(:,lmk).app.pred = newId;
                %Obs(:,lmk).vis      = true;
                %Obs(:,lmk).measured = true;
                %Obs(:,lmk).matched  = true;
                %Obs(:,lmk).updated  = true;
            end ;
            
            
            
            
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
        end ;

        %             [SimObs.points, s] = projectEuclPntIntoPinHoleOnRob(SimRob.frame, SimSen.frame, SimSen.par.k, SimSen.par.d, SimLmk.points);
        %             SimObs.ids=SimLmk.ids;
        %
        %             front=(s>0);
        %             intsquare=inSquare(SimObs.points,[0 SimSen.par.imSize(1) 0 SimSen.par.imSize(2)]);
        %             vis=(front&intsquare);
        %
        %             SimObs.points(:, ~vis)=[];
        %             SimObs.ids(~vis)=[];

        % unknown
        % -------
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);

end % end of the "switch" on sensor type

    RobNew = Rob ;

end
