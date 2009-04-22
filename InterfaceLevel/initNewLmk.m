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


r = newRange(6);

if numel(r) == 6   % there is space in Map
    
    % index to first free Idp lmk
    lmk = newLmk(Lmk);
    
    switch Raw.type
        case {'simu'}
            [y, R, newId] = simDetectFeature(...
                [Lmk([Lmk.used]).id],...
                Raw.data,Sen.par.pixCov);
            
            app           = newId;
            
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
        Obs(lmk).ltype    = 'idpPnt';
        Obs(lmk).meas.y   = y;
        Obs(lmk).meas.R   = R;
        Obs(lmk).exp.e    = y;
        Obs(lmk).exp.E    = R;
        Obs(lmk).exp.um   = det(R);  % uncertainty measure
        Obs(lmk).app.curr = app;
        Obs(lmk).app.pred = app;
        Obs(lmk).vis      = true;
        Obs(lmk).measured = true;
        Obs(lmk).matched  = true;
        Obs(lmk).updated  = true;
        
        switch Sen.type
            
            % camera pinHole
            case {'pinHole'}
                
                % INIT LMK OF TYPE: IDP
                [l, L_rf, L_sf, L_sk, L_sd, L_obs, L_n] = ...
                    retroProjIdpPntFromPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    y, ...
                    Opt.init.idpPnt.nonObsMean) ;
                
                N = Opt.init.idpPnt.nonObsStd^2 ;
                
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
        Lmk(lmk).type    = 'idpPnt';
        Lmk(lmk).used    = true;
        Lmk(lmk).sig     = app;
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
