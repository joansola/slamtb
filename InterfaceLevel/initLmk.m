function [Lmk,Obs] = initLmk(Rob, Sen, Raw, Lmk, Obs)

%INITLMK  Initialise some new landmarks from recent observations.
%   [LMK, OBS] = INITNLMK(ROB, SEN, RAW, LMK, OBS) returns the new set of
%   landmarks.
%
%   This "new set" contains the "old set" plus new elements. These new
%   elements are extracted from the recent observations (RAW), from the
%   current state estimated (ROB for robot and SEN for the sensor).
%
%   Finally, we can have a mean and a variance-covariance estimation for
%   the new landmark state.
%

global Map

switch Sen.type
    
    % camera pinHole
    case {'pinHole'}
        
        % get a free Idp lmk
        usedLmks = [Lmk.used];
        idps     = strcmp({Lmk.type},'idpPnt');
        freeIdps = idps & ~usedLmks;
        
        % test if there is space in Lmk for new lmk
        if any(freeIdps)
            
            % get a new point ID
            lmk      = find(freeIdps,1);
            
            switch Raw.type
                case {'simu'}
                    [y, R, newId] = SimDetectFeature([Lmk(usedLmks).id],Raw.data,Sen.par);
                    
                case {'real'}
                    %to do
                    %[y,R,newId] = detectFeature([Lmk(usedLmks).id],Raw.data,Sen.par);
            end
            
            if ~isempty(y)
                
                % fill Obs struct
                Obs(lmk).sen      = Sen.sen;
                Obs(lmk).lmk      = lmk;
                Obs(lmk).sid      = Sen.id;
                Obs(lmk).lid      = newId;
                Obs(lmk).meas.y   = y;
                Obs(lmk).meas.R   = R;
                Obs(lmk).exp.e    = y;
                Obs(lmk).exp.E    = R;
                Obs(lmk).app.curr = newId;
                Obs(lmk).app.pred = newId;
                Obs(lmk).vis      = true;
                Obs(lmk).measured = true;
                Obs(lmk).matched  = true;
                Obs(lmk).updated  = true;
                
                % INIT LMK
                inv_depth_nob = Lmk(lmk).nom.n ;
                [idp, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = ...
                    retroProjectIdpPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    y, ...
                    inv_depth_nob) ;
                
                Lmk(lmk).lmk     = lmk;
                Lmk(lmk).id      = newId;
                Lmk(lmk).used    = true;
                Lmk(lmk).state.x = idp ;
                Lmk(lmk).sig     = newId;
                
                
                % TODO put better variance-covariance matrix
                Rpix = Sen.par.pixCov ;
                Rnob = Lmk(lmk).nom.N ;
                % if the sensor frame is in the state
                % IDPmap = [IDPrf IDPsf] ;
                IDPmap = IDPrf ;
                % if the sensor frame is in the state
                % Rmap = Map.P([Rob.frame.r;Sen.frame.r],[Rob.frame.r;Sen.frame.r]) ;
                Rmap = Map.P(Rob.frame.r,Rob.frame.r) ;
                
                % var_covar LL
                Lmk(lmk).state.P  = ...
                    IDPpix*Rpix*IDPpix' + ...  % by pixel cov
                    IDPrho*Rnob*IDPrho' + ...  % by nob   cov
                    IDPmap*Rmap*IDPmap'     ;  % by map   cov
                
                % covar_LX
                P_RX = Map.P(Rob.frame.r,find(Map.used)) ;
                P_LX = IDPrf*P_RX ;
                
                % frame range in Map
                Lmk(lmk).state.r = addToMap(Lmk(lmk).state.x,Lmk(lmk).state.P,P_LX);
                %             end
            end
        else
            return
        end
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
end
