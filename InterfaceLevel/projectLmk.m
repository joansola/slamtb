function Obs = projectLmk(Rob,Sen,Lmk,Obs)

% PROJECTLMK  Project landmark estimate into sensor's measurement space.
%   Obs = PROJECTLMK(Rob,Sen,Lmk,Obs) projects the landmark Lmk into sensor
%   Sen mounted on robot Rob, and updates the information of the
%   observation structure Obs. The observation model is determined from
%   Sen.type and Lmk.type. It is an error if no model exists for the chosen
%   Sen-Lmk pair.
%
%   The updated fields in Obs are:
%       .sid        % sensor ID
%       .lid        % landmark ID
%       .ltype      % landmark type
%       .vis        % flag: true if landmark is visible
%       .meas.R     % measurement noise cov. matrix
%       .exp.e      % expectation's mean
%       .exp.E      % expectation's covariances matrix
%       .exp.um     % expectation's uncertainty measure
%       .Jac.E_r    % Jacobian wrt robot frame
%       .Jac.E_s    % Jacobian wrt sensor frame
%       .Jac.E_l    % Jacobian wrt landmark state
%
%   See also OBSERVEKNOWNLMKS.

global Map


% get landmark range and mean
lr = Lmk.state.r ;        % lmk range in Map
l  = Map.x(lr) ;               % lmk mean

% explore all sensor and landmark types
switch Sen.type

    case {'pinHole'} % camera pinHole

        switch Lmk.type

            case {'idpPnt'} % inverse depth point

                % IDP --> pixel -(value and Jacobians)-
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

                % Point3D --> pixel -(value and Jacobians)-
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
                error('??? Landmark type ''%s'' non implemented for sensor ''%s''.',Lmk.type,Sen.type);

        end

    otherwise % unknown Sensor type
        error('??? Unknown sensor type ''%s''.',Sen.type);

end % sensor type


% update the Obs structure
Obs.sid     = Sen.id ;
Obs.lid     = Lmk.id ;
Obs.ltype   = Lmk.type ;
Obs.vis     = vis ;

% Rob-Sen-Lmk range and Jacobian
if Sen.frameInMap
    rslr  = [Rob.frame.r ; Sen.frame.r ; lr]; % range of robot, sensor, and landmark
    E_rsl = [E_rf E_sf E_l];
else
    rslr  = [Rob.frame.r ; lr];               % range of robot and landmark
    E_rsl = [E_rf E_l];
end

% Expectation covariances matrix
E = E_rsl*Map.P(rslr,rslr)*E_rsl' ;

% update the Obs structure
Obs.meas.R  = R ;
Obs.exp.e   = e ;
Obs.exp.E   = E ;
Obs.exp.um  = det(E);  % uncertainty measure proportional to ellipsoid area
Obs.Jac.E_r = E_rf;
Obs.Jac.E_s = E_sf;
Obs.Jac.E_l = E_l;
%                 Obs.app.pred = Lmk.sig; %% TODO: app.curr in better way
