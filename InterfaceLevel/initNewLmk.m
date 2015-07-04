function [Lmk,Obs,Frm,Fac,lmk] = initNewLmk(Rob, Sen, Raw, Lmk, Obs, Frm, Fac, Opt)

%INITNEWLMK  Initialise one landmark.
%   [LMK, OBS] = INITNEWLMK(ROB, SEN, RAW, LMK, OBS) initializes one new
%   landmark. The landmark is selected by an active-search analysis of the
%   Raw data belonging to the current sensor Sen in robot Rob. After
%   successful initialization, structures Map, Lmk and Obs are updated. 
%
%   Input/output structures:
%       Rob:  the robot
%       Sen:  the sensor
%       Raw:  the raw datas issues from Sen
%       Lmk:  the set of landmarks
%       Obs:  the observation structure for the sensor Sen
%       Frm:  The frame from where the Lmk was perceived
%       Fac:  the factor to be created.
%       Opt:  the algorithm options
%
%   The algorithm can be configured through numerous options stored in
%   structure Opt.init. Edit USERDATA_GRAPH to access and modify these
%   options.

%   Copyright 2015-   Joan Sola @ IRI-CSIC-UPC

global Map

% 1. Check that we have space...

% 1a. In Lmk array. Index to first free Idp lmk
lmk = newLmk(Lmk);
if isempty(lmk)
    % Lmk structure array full. Unable to initialize new landmark.
    return;
end

% 1b. In Fac array. Check for new factor
if (strcmp(Map.type, 'graph') == true)
    
    fac = find([Fac.used] == false, 1, 'first');
    
    if isempty(fac)
        % Fac structure array full. Unable to initialize new landmark.
        return;
    end
end

% 1c. In Map storage vector
% Update rob and sen info from Map or from graph
switch Map.type
    case 'ekf'
        Rob = map2rob(Rob);
        Sen = map2sen(Sen);
    case 'graph'
        Rob = frm2rob(Rob,Frm);
end

% Type of the lmk to initialize - with error check.
switch Opt.init.initType
    case {'hmgPnt'}
        lmkSize = 4;
    case {'ahmPnt'}
        lmkSize = 7;
    case {'idpPnt','plkLin'}
        lmkSize = 6;
    case {'idpLin','aplLin'}
        lmkSize = 9;
    case {'hmgLin'}
        lmkSize = 8;
    case {'ahmLin'}
        lmkSize = 11;
    case {'eucPnt'}
        switch Sen.type
            case 'pinHoleDepth'
                lmkSize = 3;
            otherwise
                error('??? Unable to initialize lmk type ''%s''. Try using ''idpPnt'' instead.',Opt.init.initType);
        end
    otherwise
        error('??? Unknown landmark type ''%s''.', Opt.init.initType);
end


% % check for free space in the Map.
if (freeSpace() < lmkSize) 
    % Map full. Unable to initialize landmark.
    return
end

% OK, we have space everywhere. Proceed with computations.

% 2. Feature detection
switch Raw.type
    case {'simu','dump'}
        [lid, app, meas, exp, inn] = simDetectFeat(...
            Opt.init.initType,    ...
            [Lmk([Lmk.used]).id], ...
            Raw.data,             ...
            Sen.par.cov,       ...
            Sen.par.imSize);

    case 'image'
        % NYI : Not Yet Implemented. Create detectFeat.m and call:
        % [newId, app, meas, exp, inn] = detectFeat(...);
        error('??? Raw type ''%s'' not yet implemented.', Raw.type);
        
    otherwise
        error('??? Unknown raw type %s.', Raw.type);
end

if ~isempty(meas.y)  % a feature was detected --> initialize it

    % fill Obs struct before continuing
    Obs(lmk).sen      = Sen.sen;
    Obs(lmk).lmk      = lmk;
    Obs(lmk).sid      = Sen.id;
    Obs(lmk).lid      = lid;
    Obs(lmk).stype    = Sen.type;
    Obs(lmk).ltype    = Opt.init.initType;
    Obs(lmk).meas     = meas;
    Obs(lmk).exp      = exp;
    Obs(lmk).exp.um   = det(inn.Z);  % uncertainty measure
    Obs(lmk).inn      = inn;
    Obs(lmk).app.curr = app;
    Obs(lmk).app.pred = app;
    Obs(lmk).vis      = true;
    Obs(lmk).measured = true;
    Obs(lmk).matched  = true;
    Obs(lmk).updated  = true;

    % 3. retro-project feature onto 3D space
    [l, L_rf, L_sf, L_obs, L_n, N] = retroProjLmk(Rob,Sen,Obs(lmk),Opt);

    % 4. Initialize Lmk
    if strcmp(Map.type, 'ekf')
    % get new Lmk, covariance and cross-variance.
        [P_LL,P_LX] = getNewLmkCovs( ...
            Sen.frameInMap, ...
            Rob.frame.r, ...
            Sen.frame.r, ...
            L_rf, ...
            L_sf, ...
            L_obs, ...
            L_n, ...
            meas.R, ...
            N) ;

        % add to Map and get lmk range in Map
        Lmk(lmk).state.r = addToMap(l,P_LL,P_LX);

    else
        % get lmk ranges in Map, and block
        r = newRange(Lmk(lmk).state.dsize);
        blockRange(r);
        
        % Update ranges and state
        Lmk(lmk).state.r = r;
        Lmk(lmk).state.x = l;
                
    end

    % Fill Lmk structure
    Lmk(lmk).lmk     = lmk;
    Lmk(lmk).id      = lid;
    Lmk(lmk).type    = Opt.init.initType ;
    Lmk(lmk).used    = true;
    Lmk(lmk).factors = [];
    Lmk(lmk).sig     = app;
    Lmk(lmk).nSearch = 1;
    Lmk(lmk).nMatch  = 1;
    Lmk(lmk).nInlier = 1;
    
    % Init off-filter landmark params
    [Lmk(lmk),Obs(lmk)] = initLmkParams(Rob,Sen,Lmk(lmk),Obs(lmk));
    
else
    % Detection failed
    lmk = [];
    
end

% 5. Create factor
if (~isempty(lmk) && strcmp(Map.type, 'graph') == true)
    
    [Lmk(lmk), Frm, Fac(fac)] = makeMeasFactor(...
        Lmk(lmk),  ...
        Obs(lmk),  ...
        Frm,       ...
        Fac(fac));
end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

