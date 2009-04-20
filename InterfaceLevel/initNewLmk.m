function [Lmk,Obs] = initNewLmk(Rob, Sen, Raw, Lmk, Obs, Opt)

%INITNEWLMK  Initialise one landmark.
%   [LMK, OBS] = INITNEWLMK(ROB, SEN, RAW, LMK, OBS) returns the new
%   set of landmarks.
%
%   This "new set" contains the "old set" plus new elements. These new
%   elements are extracted from the recent observations (RAW), from the
%   current state estimated (ROB for robot and SEN for the sensor).
%
%   Finally, we can have a mean and a variance-covariance estimation for
%   the new landmark state.
%



% test if there is space in Lmk for a new lmk
usedLmks = [Lmk.used];
idps     = strcmp({Lmk.type},'idpPnt'); % We consider only new IdpPnt for
frees    = idps & ~usedLmks;            %    initialization here

if any(frees)
    
    % index to first free Idp lmk
    lmk = find(frees,1);
    
    switch Raw.type
        case {'simu'}
            [y, R, newId] = simDetectFeature([Lmk(usedLmks).id],Raw.data,Sen.par.pixCov);
            
        case {'real'}
            % NYI : Not Yet Implemented
            %[y,R,newId] = detectFeature([Lmk(usedLmks).id],Raw.data,Sen.par);
            error('??? Unknown Raw type. ''real'': NYI.');
    end
    
    if ~isempty(y)  % a feature was detected
        
        % fill Obs struct before continuing
        Obs(lmk).sen      = Sen.sen;
        Obs(lmk).lmk      = lmk;
        Obs(lmk).sid      = Sen.id;
        Obs(lmk).lid      = newId;
        Obs(lmk).stype    = Sen.type;
        Obs(lmk).ltype    = Lmk.type;
        Obs(lmk).meas.y   = y;
        Obs(lmk).meas.R   = R;
        Obs(lmk).exp.e    = y;
        Obs(lmk).exp.E    = R;
        Obs(lmk).exp.um   = det(R);  % uncertainty measure
        Obs(lmk).app.curr = newId;
        Obs(lmk).app.pred = newId;
        Obs(lmk).vis      = true;
        Obs(lmk).measured = true;
        Obs(lmk).matched  = true;
        Obs(lmk).updated  = true;
        
        switch Sen.type
            
            % camera pinHole
            case {'pinHole'}
                
                % INIT LMK OF TYPE: IDP
                [l, L_rf, L_sf, L_sk, L_sd, L_pix, L_n] = ...
                    retroProjIdpPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    y, ...
                    Lmk(lmk).nom.n) ;
                N = Lmk(lmk).nom.N ;
                L_obs = L_pix ; % here the observation is a pixel
                
            % case ...
                % non-measurable covariance template:
                % N = [] ;
                % L_n = zeros(0,length(find(Map.used))) ;
               
            otherwise % -- Sen.type
                
                % Print an error and exit
                error('??? Unknown sensor type. ''% s''.',Sen.type);
                
        end % -- Sen.type
        
        % get new Lmk, covariance and cross-variance.
        [P_LL,P_LX] = getNewLmkCovs( ...
            Sen.frameInMap, ...
            Rob.frame.r, ...
            Sen.frame.r, ...
            L_rf, ...
            L_sf, ...
            L_obs, ...
            L_n, ...
            R, ...
            N) ;
        
        % add to Map and get lmk range in Map
        Lmk(lmk).state.r = addToMap(l,P_LL,P_LX);
        
        % Fill Lmk structure before exit
        Lmk(lmk).lmk     = lmk;
        Lmk(lmk).id      = newId;
        Lmk(lmk).used    = true;
        Lmk(lmk).sig     = newId;
    end
end
end
