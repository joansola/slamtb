function Map = createMap(Rob,Sen,Opt)

% CREATEMAP Create an empty Map structure.
%   Map = CREATEMAP(Rob,Sen,Lmk,Opt) creates the structure Map from the
%   information contained in Rob, Sen and Lmk, using options Opt. The
%   resulting structure is an EKF map with all empty spaces, able to host
%   all states necessary for Rob, Sen and Lmk. It contains the fields:
%       .used   flags vector to used states in the map
%       .x      state vector
%       .P      covariances matrix
%       .t      current time - used to control time updates

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.

switch lower(Opt.map.type)
    case 'ekf'
        % Help: Map has state and covariances matrix. 
        % The state has:
        % - state of each robot
        % - state of each sensor being estimated
        % - state of each landmark
        % The covariances matrix has all cross-variances of the above.
        
        Map.type = 'ekf';
        
        RobStates = [Rob.state];
        SenStates = [Sen.state];
        
        % overall number of states needed to allocate robots, sensors and landmarks
        n = sum([RobStates.size SenStates.size Opt.map.lmkSize*Opt.map.numLmks]);
        
        Map.used = false(n,1);
        
        Map.x = zeros(n,1);
        Map.P = zeros(n,n);
        
    case 'graph'
        % Help: Map has nominal and manifold states. 
        % The state has:
        % - state of each pose of the trajectory of each robot
        % - state of each landmark
        % The manifold state has the same, but manifold states.
        % The true state is not stored, but obtained by composing nominal
        % and manifold states.
        
        % TODO: sensor in map not supported yet.
        
        Map.type = 'graph';
        
        RobStates = [Rob.state];
        
        % overall number of states needed to allocate frames and landmarks
        nf = sum([RobStates.dsize].*Opt.map.numFrames); % number of states for frames
        [ ~, lmkDSize ] = lmkSizes( Opt.init.initType, Opt.map.type);
        % EP-WARNING: Use lmkDSize or lmkInitDSize in the line below?
        nl = lmkDSize(2)*Opt.map.numLmks;  % number of states for landmarks
        n = nf + nl;    % total number of states
        
        % Map occupancy
        Map.used = false(n,1);
        
        % State and manifold
        Map.x = zeros(n,1);
        
        if Opt.map.useGtsam
            
            % Define ISAM2 options
            Map.gtsam.params = gtsam.ISAM2Params;
            switch Opt.map.gtsam.nonlinearOptimizer
                case 'GAUSSNEWTON'
                    optimizer = gtsam.ISAM2GaussNewtonParams();
                case 'DOGLEG'
                    optimizer = gtsam.ISAM2DoglegParams();
                    % ONE_STEP_PER_ITERATION makes the trust region
                    % increase only once every iteraction. See
                    % https://research.cc.gatech.edu/borg/sites/edu.borg/html/a00065.html#a52e03ca11a892d070c911db43f22cf04
                    % for details.
                    optimizer.setAdaptationMode(Opt.map.gtsam.doglegAdaptationMode);                    
            end
            if ~ischar( Opt.map.gtsam.wildfireTh )
                optimizer.setWildfireThreshold( Opt.map.gtsam.wildfireTh )
            end
            Map.gtsam.params.setOptimizationParams(optimizer);
            if ~ischar( Opt.map.gtsam.relinearizeSkip )
                Map.gtsam.params.setRelinearizeSkip( Opt.map.gtsam.relinearizeSkip );
            end
            if ~ischar( Opt.map.gtsam.relinearizeTh )
                Map.gtsam.params.setRelinearizeThreshold( Opt.map.gtsam.relinearizeTh );
            end
            Map.gtsam.params.setFactorization( Opt.map.gtsam.factorization );
            % This option is always true because we're removing and
            % re-adding factors when reanchoring
            Map.gtsam.params.setFindUnusedFactorSlots( true );
            
            % Build ISAM2 object
            Map.gtsam.isam = gtsam.ISAM2(Map.gtsam.params);
            
        else
        
            switch Opt.solver.decomposition

                case 'Cholesky'
                    % Hessian matrix in the manifold
                    Map.H  = sparse(n,n);
                    Map.R  = sparse(n,n);
                    Map.b  = zeros(n,1); % rhs vector.
                    Map.mr = []; % range of used states in H

                case 'QR'
                    m = 1000;
                    Map.A  = sparse(m,n); 
                    Map.R  = sparse(n,n);
                    Map.b  = zeros(m,1); % rhs vector.
                    Map.d  = zeros(n,1); % rhs vector.
                    Map.mr = []; % range of used states in A
                    Map.fr = []; % range of used factors in A

                case 'Schur'
                    % Hessian matrix in the manifold
                    Map.H    = sparse(n,n);
                    Map.b    = zeros(n,1); % rhs vector.
                    Map.sSff = sparse(nf,nf); % sqrt of the Schur complement
                    Map.iHll = sparse(nl,nl); % Inverse of the landmarks Hessian
                    Map.mr   = []; % range of used states in H

                otherwise
                    error('??? Unknown graph solver ''%s''.', Opt.solver.decomposition)
            end

        end
    otherwise
        
        error('??? Unknown Map type. Please use ''ekf'' or ''graph''.')
        
end

Map.t = 0; % Current Map's time



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

