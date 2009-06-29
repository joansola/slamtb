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
%   See also GETNEWLMKCOVS

%   (c) 2009 Jean Marie Codol, David Marquez @ LAAS-CNRS

% 0. UPDATE ROB AND SEN INFO FROM MAP
Rob = map2rob(Rob);
Sen = map2sen(Sen);

% Type of the lmk to initialize - with error check.
switch Opt.init.initType
    case {'hmgPnt'}
        lmkSize = 4;
    case {'idpPnt','plkLin'}
        lmkSize = 6;
    case {'idlLin','ancPlkLin'}
        lmkSize = 9;
    case {'eucPnt'}
        error('??? Unable to initialize lmk type ''%s''. Try using ''idpPnt'' instead.',Opt.init.initType);
    otherwise
        error('??? Unknown lmk type ''%s''.', Opt.init.initType);
end

% get free space in the Map.
r = newRange(lmkSize);
if numel(r) < lmkSize
    return;
end

% index to first free Idp lmk
lmk = newLmk(Lmk);

% Feature detection
switch Raw.type
    case {'simu'}
        switch Opt.init.initType(4:end)
            case 'Pnt'
                [y, R, newId] = simDetectPnt(...
                    [Lmk([Lmk.used]).id],...
                    Raw.data,...
                    Sen.par.pixCov,...
                    Sen.par.imSize);
                app = newId;
                e   = y;
                E   = R;
                Z   = R;
        
            case 'Lin'
                [y, R, newId] = simDetectLin(...
                    [Lmk([Lmk.used]).id],...
                    Raw.data,...
                    Sen.par.pixCov);
                app = newId;
                [e,E] = propagateUncertainty(y,R,@seg2hmgLin);
                Z     = R(1:2,1:2);
        end
        
    case {'real'}
        % NYI : Not Yet Implemented
        %[y,R,newId] = detectFeature([Lmk(usedLmks).id],Raw.data,Sen.par);
        error('??? Unknown Raw type. ''real'': NYI.');
end

if ~isempty(y)  % a feature was detected --> initialize it in IDP

    % fill Obs struct before continuing
    Obs(lmk).sen      = Sen.sen;
    Obs(lmk).lmk      = lmk;
    Obs(lmk).sid      = Sen.id;
    Obs(lmk).lid      = newId;
    Obs(lmk).stype    = Sen.type;
    Obs(lmk).ltype    = Opt.init.initType;
    Obs(lmk).meas.y   = y;
    Obs(lmk).meas.R   = R;
    Obs(lmk).exp.e    = e;
    Obs(lmk).exp.E    = E;
    Obs(lmk).exp.Z    = Z;
    Obs(lmk).exp.um   = det(Z);  % uncertainty measure
    Obs(lmk).app.curr = app;
    Obs(lmk).app.pred = app;
    Obs(lmk).vis      = true;
    Obs(lmk).measured = true;
    Obs(lmk).matched  = true;
    Obs(lmk).updated  = true;

    % retro-project feature onto 3D space
    switch Sen.type

        % camera pinHole
        case {'pinHole'}
            % type of lmk to init
            switch Opt.init.initType
                case {'idpPnt'}
                    % INIT LMK OF TYPE: Inverse depth point
                    [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                        retroProjIdpPntFromPinHoleOnRob( ...
                        Rob.frame, ...
                        Sen.frame, ...
                        Sen.par.k, ...
                        Sen.par.d, ...
                        y, ...
                        Opt.init.idpPnt.nonObsMean) ;

                    N = Opt.init.idpPnt.nonObsStd^2 ;
        
                case {'hmgPnt'}
                    % INIT LMK OF TYPE: Homogeneous point
                    [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                        retroProjHmgPntFromPinHoleOnRob( ...
                        Rob.frame, ...
                        Sen.frame, ...
                        Sen.par.k, ...
                        Sen.par.d, ...
                        y, ...
                        Opt.init.hmgPnt.nonObsMean) ;

                    N = Opt.init.hmgPnt.nonObsStd^2 ;
                
                case {'plkLin'}
                    % INIT LMK OF TYPE: Plucker line
                    [l, L_rf, L_sf, L_sk, L_obs, L_n] = ...
                        retroProjPlkLinFromPinHoleOnRob( ...
                        Rob.frame, ...
                        Sen.frame, ...
                        Sen.par.k, ...
                        e, ...
                        Opt.init.plkLin.nonObsMean) ;

                    N = diag(Opt.init.plkLin.nonObsStd.^2) ;
                    
                otherwise
                    error('??? Unknown landmark type to initialize ''%s''.',Opt.init.initType)
            end

        otherwise % -- Sen.type
            % Print an error and exit
            error('??? Unknown sensor type. ''%s''.',Sen.type);
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
        E, ...
        N) ;

    % add to Map and get lmk range in Map
    Lmk(lmk).state.r = addToMap(l,P_LL,P_LX);

    % Fill Lmk structure before exit
    Lmk(lmk).lmk     = lmk;
    Lmk(lmk).id      = newId;
    Lmk(lmk).type    = Opt.init.initType ;
    Lmk(lmk).used    = true;
    Lmk(lmk).sig     = app;
    Lmk(lmk).nSearch = 1;
    Lmk(lmk).nMatch  = 1;
    Lmk(lmk).nInlier = 1;
    
    % Init internal state
    switch Lmk(lmk).type
        case {'eucPnt','idpPnt','hmgPnt'}
        case 'plkLin'
            Lmk(lmk).par.endp(1).t = 0;
            Lmk(lmk).par.endp(2).t = 1;
        otherwise
            error('??? Unknown landmark type ''%s''.',Lmk(lmk).type);
    end
    
end

end


function [P_LL,P_LX] = getNewLmkCovs(SenFrameInMap, RobFrameR, SenFrameR,...
    L_rf, L_sf, L_obs, L_n, R, N)

% GETNEWLMKCOVS return lmk co and cross-variance for initialization.
%   [P_LL,P_LX] = GETNEWLMKCOVS( ...
%       SENFRAMEINMAP, ...
%       ROBFRAMERANGE, ...
%       SENFRAMERANGE, ...
%       L_RF, ...
%       L_SF, ...
%       L_OBS, ...
%       L_N, ...
%       R, ...
%       N)
%
%   Return the covariance 'Lmk/Lmk' (P_LL) and cross-variance 'Lmk/Map.used'
%   (P_LX) given :
%     - if the sensor frame is in map   (SENFRAMEINMAP).
%     - the robot  frame range in map   (ROBFRAMERANGE).
%     - the sensor frame range in map   (SENFRAMERANGE).
%     - the jacobian 'Lmk/robot  frame' (L_RF).
%     - the jacobian 'Lmk/sensor frame' (L_SF).
%     - the jacobian 'Lmk/observation'  (L_OBS).
%     - the jacobian 'Lmk/non observable part' (L_N).
%     - the observation covariance (R).
%     - the observation non observable part covariance (N).
%
%     P_LL and P_LX can be placed for example in Map covariance like:
%
%     P = | P     P_LX' |
%         | P_LX  P_LL  |
%

%   (c) 2009 Jean Marie Codol, David Marquez @ LAAS-CNRS

global Map

% Group all map Jacobians and ranges
if SenFrameInMap % if the sensor frame is in the state
    mr  = [RobFrameR;SenFrameR];
    L_m = [L_rf L_sf] ;
else
    mr  = RobFrameR;
    L_m = L_rf ;
end

% co- and cross-variance of map variables (robot and eventually sensor)
P_MM = Map.P(mr,mr) ;
P_MX = Map.P(mr,(Map.used)) ;

% landmark co- and cross-variance
P_LL  = ...
    L_m   * P_MM * L_m'   + ...  % by map   cov
    L_obs * R    * L_obs' + ...  % by observation cov (for pinHole it is a pixel)
    L_n   * N    * L_n' ;        % by nom   cov

P_LX = L_m*P_MX ;

end
