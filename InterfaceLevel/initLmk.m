function [Lmk,Obs] = initLmk(Rob, Sen, Raw, Lmk, Obs)

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
            lmkIds   = [Lmk(usedLmks).id];
            rawIds   = Raw.data.ids;
            [newIds,newIdsIdx] = setdiff(rawIds,lmkIds);
            
            % test if we saw any new points in Raw
            if ~isempty(newIds)
                
                % DETECT FEATURE
                newId    = newIds(1);
                newIdx   = newIdsIdx(1);
                
                % bet new point coordinates and covariance
                y        = Raw.data.points(:,newIdx);
                R        = Sen.par.pixCov;
                
                % fill Obs struct
                Obs(:,lmk).sen      = Sen.sen;
                Obs(:,lmk).sid      = Sen.id;
                Obs(:,lmk).lid      = newId;
                Obs(:,lmk).meas.y   = y;
                Obs(:,lmk).meas.R   = R;
                Obs(:,lmk).exp.e    = y;
                Obs(:,lmk).exp.E    = R;
                Obs(:,lmk).app.curr = newId;
                Obs(:,lmk).app.pred = newId;
                Obs(:,lmk).vis      = true;
                Obs(:,lmk).measured = true;
                Obs(:,lmk).matched  = true;
                Obs(:,lmk).updated  = true;
                
                % INIT LMK
                inv_depth_nob = Lmk(lmk).nom.n ;
                [idp, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = retroProjectIdpPntFromPinHoleOnRob(Rob.frame, Sen.frame, Sen.par.k, Sen.par.d, y, inv_depth_nob) ;
                
                Lmk(lmk).id   = newId;
                Lmk(lmk).used = true;
                Lmk(lmk).state.x  = idp ;
                Lmk(lmk).sig  = newId;
                
                
                % TODO put better variance-covariance matrix
                Lmk(lmk).state.P  = IDPpix*Sen.par.pixCov*IDPpix' + IDPrho*Lmk(lmk).nom.N*IDPrho' ; % + ... ???
                
                % frame range in Map
                Lmk(lmk).state.r = addToMap(Lmk(lmk).state.x,Lmk(lmk).state.P);
                
            end
        end
        
    otherwise
        % Print an error and exit
        error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
end
