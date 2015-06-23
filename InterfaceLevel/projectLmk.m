function Obs = projectLmk(Rob,Sen,Lmk,Obs,Opt)

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

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

% PREVIOUS TASKS
% get landmark range and mean
lr = Lmk.state.r ;        % lmk range in Map
switch Map.type
    case 'ekf'
        l  = Map.x(lr);   % lmk mean
    case 'graph'
        l = Lmk.state.x;  % lmk mean
    otherwise
        error('??? Unknown Map type ''%s''.',Map.type)
end

% PROJECTION FUNCTION
% explore all sensor and landmark types
switch Sen.type

    case {'pinHole'} % camera pinHole

        switch Lmk.type

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

            case {'hmgPnt'} % euclidean point

                % Point3D --> pixel -(value and Jacobians)-
                [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projHmgPntIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l) ;

                vis = isVisible(e,depth,Sen.par.imSize);
                
            case {'ahmPnt'}

                % Point3D --> pixel -(value and Jacobians)-
                [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projAhmPntIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l);

                vis = isVisible(e,depth,Sen.par.imSize);

            case {'fhmPnt'}

                % Point3D --> pixel -(value and Jacobians)-
                [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projFhmPntIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l);

                vis = isVisible(e,depth,Sen.par.imSize);

            case {'plkLin'}

                % Plucker line --> homogeneous line (value and Jacs)
                [e, v, E_rf, E_sf, E_k, E_l] = ...
                    projPlkLinIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    l); % expectation e is a homogeneous line
                
                % normalize wrt director vector e(1:2):
                ine12 = 1/norm(e(1:2));
                e     = e    * ine12;
                E_rf  = E_rf * ine12;
                E_sf  = E_sf * ine12;
                % E_k   = E_k  * ine12;
                E_l   = E_l  * ine12;

                % 3d Segment from Plucker line and abscissas
                [si,SI_l] = pluckerSegment(l,[Lmk.par.endp.t]);

                % projected segment
                [s, d, S_rf, S_sf, S_k, S_si] = projSegLinIntoPinHoleOnRob(...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    si); 
                
                % segment visibility
                [s,vis] = visibleSegment(s,d,Sen.par.imSize);
                
            case 'aplLin'
                
                % Anchored Plucker line --> homogeneous line (value and Jacs)
                [e, v, E_rf, E_sf, E_k, E_l] = ...
                    projAplLinIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    l); % expectation e is a homogeneous line

                % normalize wrt director vector e(1:2):
                ine12 = 1/norm(e(1:2));
                e     = e    * ine12;
                E_rf  = E_rf * ine12;
                E_sf  = E_sf * ine12;
                % E_k   = E_k  * ine12;
                E_l   = E_l  * ine12;

                % 3d Segment from Plucker line and abscissas
                [si,SI_l] = aPluckerSegment(l,[Lmk.par.endp.t]);

                % projected segment
                [s, d, S_rf, S_sf, S_k, S_si] = projSegLinIntoPinHoleOnRob(...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    si); 
                
                % segment visibility
                [s,vis] = visibleSegment(s,d,Sen.par.imSize);
                
                
            case 'idpLin'
                
                % IDP line --> homogeneous line (value and Jacs)
                [s, v, S_rf, S_sf, S_k, S_l] = ...
                    projIdpLinIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    l); % expectation s is a 2d segment
                [e, E_s] = seg2hmgLin(s); % expectation e is a homogeneous line
                E_rf = E_s*S_rf;
                E_sf = E_s*S_sf;
                E_l  = E_s*S_l;

                % normalize wrt director vector e(1:2):
                ine12 = 1/norm(e(1:2));
                e     = e    * ine12;
                E_rf  = E_rf * ine12;
                E_sf  = E_sf * ine12;
                % E_k   = E_k  * ine12;
                E_l   = E_l  * ine12;

                % 3d Segment from Plucker line and abscissas
                [si,SI_l] = idpLinSegment(l,[Lmk.par.endp.t]);

                % projected segment
                [s, d, S_rf, S_sf, S_k, S_si] = projSegLinIntoPinHoleOnRob(...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    si); 
                
                % segment visibility
                [s,vis] = visibleSegment(s,d,Sen.par.imSize,0,Opt.obs.lines.minLength);

            case 'hmgLin'
                
                % HMG line --> homogeneous line (value and Jacs)
                [s, v, S_rf, S_sf, S_k, S_l] = ...
                    projHmgLinIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    l); % expectation s is a 2d segment
                [e, E_s] = seg2hmgLin(s); % expectation e is a homogeneous line
                E_rf = E_s*S_rf;
                E_sf = E_s*S_sf;
                E_l  = E_s*S_l;

                % normalize wrt director vector e(1:2):
                ine12 = 1/norm(e(1:2));
                e     = e    * ine12;
                E_rf  = E_rf * ine12;
                E_sf  = E_sf * ine12;
                % E_k   = E_k  * ine12;
                E_l   = E_l  * ine12;

                % 3d Segment from Plucker line and abscissas
                [si,SI_l] = hmgLinSegment(l,[Lmk.par.endp.t]);

                % projected segment
                [s, d, S_rf, S_sf, S_k, S_si] = projSegLinIntoPinHoleOnRob(...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    si); 
                
                % segment visibility
                [s,vis] = visibleSegment(s,d,Sen.par.imSize,0,Opt.obs.lines.minLength);

            case 'ahmLin'
                
                % AHM line --> homogeneous line (value and Jacs)
                [s, v, S_rf, S_sf, S_k, S_l] = ...
                    projAhmLinIntoPinHoleOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    l); % expectation s is a 2d segment
                [e, E_s] = seg2hmgLin(s); % expectation e is a homogeneous line
                E_rf = E_s*S_rf;
                E_sf = E_s*S_sf;
                E_l  = E_s*S_l;

                % normalize wrt director vector e(1:2):
                ine12 = 1/norm(e(1:2));
                e     = e    * ine12;
                E_rf  = E_rf * ine12;
                E_sf  = E_sf * ine12;
                % E_k   = E_k  * ine12;
                E_l   = E_l  * ine12;

                % 3d Segment from Plucker line and abscissas
                [si,SI_l] = ahmLinSegment(l,[Lmk.par.endp.t]);

                % projected segment
                [s, d, S_rf, S_sf, S_k, S_si] = projSegLinIntoPinHoleOnRob(...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    si); 
                
                % segment visibility
                [s,vis] = visibleSegment(s,d,Sen.par.imSize,0,Opt.obs.lines.minLength);

                
            otherwise % unknown landmark type for pin hole sensor
                error('??? Unknown landmark type ''%s'' for sensor ''%s''.', Lmk.type, Sen.type);

        end
        
        
    case 'pinHoleDepth'  % Pin hole sensor with depth information
        switch Lmk.type
            case 'eucPnt'
                
                % Point3D --> pixel+depth -(value and Jacobians)-
                [e, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projEucPntIntoPhdOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l) ;
                
                vis = isVisible(e(1:2,:),e(3,:),Sen.par.imSize);
                
            otherwise
                error('??? Unknown landmark type ''%s'' for sensor ''%s''.',Lmk.type,Sen.type);
        end
        
    case {'omniCam'} % Omnidirectional camera
        
        switch Lmk.type

            case {'eucPnt'} % euclidean point

                % Point3D --> pixel -(value and Jacobians)-
                [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projEucPntIntoOmniCamOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l) ;

                vis = isVisible(e,depth,Sen.par.imSize);
                
            case {'ahmPnt'}

                % Point3D --> pixel -(value and Jacobians)-
                [e, depth, E_rf, E_sf, E_k, E_d, E_l] = ...
                    projAhmPntIntoOmniCamOnRob( ...
                    Rob.frame, ...
                    Sen.frame, ...
                    Sen.par.k, ...
                    Sen.par.d, ...
                    l);

                vis = isVisible(e,depth,Sen.par.imSize);
                
            otherwise % unknown landmark type for pin hole sensor
                error('??? Unknown landmark type ''%s'' for sensor ''%s''.',Lmk.type,Sen.type);
                
        end
        
        
        
    otherwise % unknown Sensor type
        error('??? Unknown sensor type ''%s''.',Sen.type);

end % sensor type


% COVARIANCES
if strcmp(Map.type,'ekf')

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

else
    E = [];
end

% Other parameters
switch Lmk.type(4:6)
    case 'Lin'
        % for lines, project endpoints with covariances:

        % compute endpoints
        Obs.par.endp(1).e = s(1:2);
        Obs.par.endp(2).e = s(3:4);

        if Map.type == 'ekf'
            % Rob-Sen-Lmk Jacobian of projected segment
            if Sen.frameInMap
                S_rsl = [S_rf S_sf S_si*SI_l];
            else
                S_rsl = [S_rf S_si*SI_l];
            end
            % compute covariances
            S = S_rsl*Map.P(rslr,rslr)*S_rsl'; % segment covariance
            Obs.par.endp(1).E = S(1:2,1:2);
            Obs.par.endp(2).E = S(3:4,3:4);
        end
        
end


% UPDATE OBS STRUCTURE
Obs.sid     = Sen.id ;
Obs.lid     = Lmk.id ;
Obs.ltype   = Lmk.type ;
Obs.vis     = vis ;
Obs.exp.e   = e ;
Obs.exp.E   = E ;
Obs.exp.um  = det(E);  % uncertainty measure proportional to ellipsoid area
Obs.Jac.E_r = E_rf;
Obs.Jac.E_s = E_sf;
Obs.Jac.E_l = E_l;



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

