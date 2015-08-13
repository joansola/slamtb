function [Fac, e, W, Wsqrt, J1, r1, J2, r2, J3, r3, J4, r4] = computeError(Rob,Sen,Lmk,Obs,Frm,Fac)

% COMPUTEERROR Compute factor error.
%   [Fac, e, W, Wsqrt, J1, J2, r1, r2] = COMPUTEERROR(Rob,Sen,Lmk,Obs,Frm,Fac)
%   computes the error associated to the factor Fac given the current
%   states in Frm and / or Lmk.

%   Copyright 2015 Joan Sola @ IRI-UPC-CSIC.


switch Fac.type
    case 'absolute'
        if ~isempty(Fac.frames)
            % Given an expected pose and a pose measurement, compute the error
            % as the minimal pose that transforms the measurement into the
            % given pose, that is:
            %   err = minimal(frameIncrement(meas, expected))
            % where frameIncrement(F,G) implements the composition of the
            % inverse of F and G,
            %   composeFrames(invertFrame(F), G)
            % and minimal() is a 6 DoF expression of the frame, done using the
            % function qframe2vframe().
            Fac.exp.e         = Frm.state.x;
            [pq, PQ_y, PQ_e]  = frameIncrement(Fac.meas.y, Fac.exp.e); % err = h(x) (-) y
            [Fac.err.z, Z_pq] = qpose2vpose(pq);
            Fac.err.J1        = Z_pq * PQ_e * Frm.state.M; % Jac wrt manifold
            Fac.err.J2        = zeros(6,0);
            Fac.err.J3        = zeros(6,0);
            Fac.err.J4        = zeros(6,0);
            Z_y               = Z_pq * PQ_y;
            Fac.err.Z         = symmetrize(Z_y * Fac.meas.R * Z_y');
            Fac.err.W         = Fac.err.Z^-1;
            Fac.err.Wsqrt     = chol(Fac.err.W);
            Fac.state.r1      = Frm.state.r;
            Fac.state.r2      = [];
            Fac.state.r3      = [];
            Fac.state.r4      = [];
        else
            % Given a expected prior for the landmark inverse depth,
            % compute the error between the inverse depth and the prior.

            % NOTE: Factor err.e, err.Z, err.W, and err.Wsqrt are constant
            % and already stored on Fac.
            Fac.err.z         = Lmk.state.x(6) - Fac.exp.e;
            Fac.err.J1        = Lmk.state.M; % Jac wrt manifold
            Fac.err.J2        = zeros(1,0);
            Fac.err.J3        = zeros(1,0);
            Fac.err.J4        = zeros(1,0);
            Fac.state.r1      = Lmk.state.r(3);
            Fac.state.r2      = [];
            Fac.state.r3      = [];
            Fac.state.r4      = [];
        end
        
    case 'motion'
        % Given two expected poses and a pose increment measurement,
        % compute the error as the minimal pose that transforms the
        % measured increment into the increment between the given poses,
        % that is:
        %   err = minimal(frameIncrement(meas, frameIncremennt(pose1, pose2)))
        % where frameIncrement(F,G) implements the composition of the
        % inverse of F and G,
        %   composeFrames(invertFrame(F), G)
        % and minimal() is a 6 DoF expression of the frame, done using the
        % function qframe2vframe().
        [Fac.exp.e, E_x1, E_x2] = frameIncrement(...
            Frm(1).state.x, ...
            Frm(2).state.x);
        [pq, PQ_y, PQ_e]  = frameIncrement(Fac.meas.y, Fac.exp.e); % err = h(x) (-) y
        [Fac.err.z, Z_pq] = qpose2vpose(pq);
        Fac.err.J1        = Z_pq * PQ_e * E_x1 * Frm(1).state.M; % Jac wrt manifold 1
        Fac.err.J2        = Z_pq * PQ_e * E_x2 * Frm(2).state.M; % Jac wrt manifold 2
        Fac.err.J3        = zeros(6,0);
        Fac.err.J4        = zeros(6,0);
        Z_y               = Z_pq * PQ_y;
        Fac.err.Z         = symmetrize(Z_y * Fac.meas.R * Z_y');
        Fac.err.W         = Fac.err.Z^-1;
        Fac.err.Wsqrt     = chol(Fac.err.W);
        Fac.state.r1      = Frm(1).state.r;
        Fac.state.r2      = Frm(2).state.r;
        Fac.state.r3      = [];
        Fac.state.r4      = [];


    case 'measurement'
        % Given an expected pose and an expected landmark, compute the
        % measurement error as the difference between the expected
        % measurement of the landmark and the actual measurement.
        switch Lmk.type
            case 'eucPnt'
                % all projection factors are the same
                Rob           = frm2rob(Rob,Frm);
                Obs           = projectLmk(Rob,Sen,Lmk,Obs);
                Fac.exp.e     = Obs.exp.e;
                Fac.err.z     = Fac.exp.e - Fac.meas.y;     % err = h(x) - y
                Fac.err.J1    = Obs.Jac.E_r * Frm.state.M; % Jac wrt manifold 1
                Fac.err.J2    = Obs.Jac.E_l * Lmk.state.M; % Jac wrt manifold 2
                Fac.err.J3    = zeros(numel(Obs.exp.e),0);
                Fac.err.J4    = zeros(numel(Obs.exp.e),0);
                Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                Fac.err.W     = Fac.err.Z^-1;
                Fac.err.Wsqrt = chol(Fac.err.W);
                Fac.state.r1  = Frm.state.r;
                Fac.state.r2  = Lmk.state.r;
                Fac.state.r3  = [];
                Fac.state.r4  = [];
                
            case 'idpPnt'
                % EP-WARNING: I'm not so sure about the computation of the jacobians below.
                if numel(Fac.frames) == 1
                    % factor is a projection to anchor
                    Rob           = frm2rob(Rob,Frm);
                    Obs           = projectLmk(Rob,Sen,Lmk,Obs);
                    Fac.exp.e     = Obs.exp.e;
                    Fac.err.z     = Fac.exp.e - Fac.meas.y;     % err = h(x) - y
                    Fac.err.J1    = Obs.Jac.E_r * Frm.state.M; % Jac wrt manifold 1
                    Fac.err.J1(:,1:3) = zeros(numel(Obs.exp.e),3); % There's no contribution to pose anchor
                    Fac.err.J2    = Obs.Jac.E_l(:,4:6) * Lmk.state.M; % Jac wrt manifold 2
                    Fac.err.J3    = zeros(numel(Obs.exp.e),0);
                    Fac.err.J4    = zeros(numel(Obs.exp.e),0);
                    Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                    Fac.err.W     = Fac.err.Z^-1;
                    Fac.err.Wsqrt = chol(Fac.err.W);
                    Fac.state.r1  = Frm.state.r;
                    Fac.state.r2  = Lmk.state.r;
                    Fac.state.r3  = [];
                    Fac.state.r4  = [];

                elseif numel(Fac.frames) == 2
                    % factor is a normal idpPnt projection factor
                    Rob           = frm2rob(Rob,Frm(2));
                    Obs           = projectLmk(Rob,Sen,Lmk,Obs);
                    Fac.exp.e     = Obs.exp.e;
                    Fac.err.z     = Fac.exp.e - Fac.meas.y;     % err = h(x) - y
                    RobAnchor     = Rob; % just to have the structure
                    RobAnchor     = frm2rob(RobAnchor,Frm(1));
                    [~, RS_r, ~]  = composeFrames(RobAnchor.frame,Sen.frame);
                    Fac.err.J1    = Obs.Jac.E_l(:,1:3) * RS_r(1:3,:) * Frm(1).state.M; % Jac wrt anchor (manifold 1)
                    Fac.err.J2    = Obs.Jac.E_r * Frm(2).state.M; % Jac wrt current frame (manifold 2)
                    Fac.err.J3    = Obs.Jac.E_l(:,4:6) * Lmk.state.M; % Jac wrt idp landmark w/o anchor (manifold 3)
                    Fac.err.J4    = zeros(numel(Obs.exp.e),0);
                    Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                    Fac.err.W     = Fac.err.Z^-1;
                    Fac.err.Wsqrt = chol(Fac.err.W);
                    Fac.state.r1  = Frm(1).state.r;
                    Fac.state.r2  = Frm(2).state.r;
                    Fac.state.r3  = Lmk.state.r;
                    Fac.state.r4  = [];
                    
                else
                    error('??? Something went wrong: idpPnt meas factor has ''%s'' frames (2 frames max allowed).', numel(Fac.frames))
                end
                
            case 'papPnt'
                if numel(Fac.frames) == 1
                    % factor is a projection to main anchor
                    % EP-WARNING: I'm not so sure about the computation of the jacobians below.
                    Rob           = frm2rob(Rob,Frm);
                    [~, ~, py, ~] = splitPap( Lmk.state.x );
                    [v, V_py]     = py2vec(py);
                    [cam, CAM_rob, ~] = composeFrames(Rob.frame,Sen.frame);
                    [vc, VC_camq, VC_v] = Rtp(cam.q,v);
                    [u, ~, U_vc, ~, ~] = pinHole(vc,Sen.par.k,Sen.par.d);
                    Fac.exp.e     = u;
                    Fac.err.z     = Fac.exp.e - Fac.meas.y;   % err = h(x) - y
                    Fac.err.J1    = [zeros(numel(Fac.err.z),3) U_vc*VC_camq]*CAM_rob*Frm(1).state.M; % Jac wrt manifold 1
                    Fac.err.J2    = [U_vc*VC_v*V_py zeros(numel(Fac.err.z),1)] * Lmk.state.M; % Jac wrt manifold 2
                    Fac.err.J3    = zeros(numel(Fac.err.z),0);
                    Fac.err.J4    = zeros(numel(Fac.err.z),0);
                    Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                    Fac.err.W     = Fac.err.Z^-1;
                    Fac.err.Wsqrt = chol(Fac.err.W);
                    Fac.state.r1  = Frm.state.r;
                    Fac.state.r2  = Lmk.state.r;
                    Fac.state.r3  = [];
                    Fac.state.r4  = [];
                    

                elseif numel(Fac.frames) == 2
                    % factor is a projection to associated anchor
                    Rob           = frm2rob(Rob,Frm(2));
                    RobAssoAnchor = Rob;
                    [RobAssoAnchor.frame, CAMASSO_assorf, CAMASSO_sf]  = composeFrames(RobAssoAnchor.frame,Sen.frame);
                    Obs           = projectLmk(RobAssoAnchor,Sen,Lmk,Obs);
                    
                    Fac.exp.e     = Obs.exp.e;
                    Fac.err.z     = Fac.exp.e - Fac.meas.y;     % err = h(x) - y
                    
                    RobMainAnchor = Rob; % just to have the structure
                    RobMainAnchor = frm2rob(RobMainAnchor,Frm(1));
                    [~, CAMMAIN_mainrf, ~] = composeFrames(RobMainAnchor.frame,Sen.frame);
                    Fac.err.J1    = Obs.Jac.E_l(:,1:3) * CAMMAIN_mainrf(1:3,:) * Frm(1).state.M; % Jac wrt main anchor (manifold 1)

                    Fac.err.J2    = (Obs.Jac.E_l(:,4:6) + Obs.Jac.E_r(:,1:3)) * CAMASSO_assorf(1:3,:) * Frm(2).state.M; % Jac wrt associated anchor (manifold 2)
                    Fac.err.J3    = Obs.Jac.E_l(:,7:9) * Lmk.state.M; % Jac wrt pap landmark w/o anchors (manifold 3)
                    Fac.err.J4    = zeros(numel(Fac.err.z),0);
                    Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                    Fac.err.W     = Fac.err.Z^-1;
                    Fac.err.Wsqrt = chol(Fac.err.W);
                    Fac.state.r1  = Frm(1).state.r;
                    Fac.state.r2  = Frm(2).state.r;
                    Fac.state.r3  = Lmk.state.r;
                    Fac.state.r4  = [];
                    
                elseif numel(Fac.frames) == 3
                    % factor is a normal pap projection factor
                    Rob           = frm2rob(Rob,Frm(3));
                    [Rob.frame, CAM_rf, CAMASSO_sf]  = composeFrames(Rob.frame,Sen.frame);
                    Obs           = projectLmk(Rob,Sen,Lmk,Obs);
                    
                    Fac.exp.e     = Obs.exp.e;
                    Fac.err.z     = Fac.exp.e - Fac.meas.y;     % err = h(x) - y
                    
                    RobMainAnchor = Rob; % just to have the structure
                    RobMainAnchor = frm2rob(RobMainAnchor,Frm(1));
                    [~, CAMMAIN_mainrf, ~] = composeFrames(RobMainAnchor.frame,Sen.frame);
                    Fac.err.J1    = Obs.Jac.E_l(:,1:3) * CAMMAIN_mainrf(1:3,:) * Frm(1).state.M; % Jac wrt main anchor (manifold 1)

                    RobAssoAnchor = Rob; % just to have the structure
                    RobAssoAnchor = frm2rob(RobAssoAnchor,Frm(2));
                    [~, CAMASSO_assorf, ~] = composeFrames(RobAssoAnchor.frame,Sen.frame);
                    Fac.err.J2    = Obs.Jac.E_l(:,4:6) * CAMASSO_assorf(1:3,:) * Frm(2).state.M; % Jac wrt asso anchor (manifold 1)
                    
                    Fac.err.J3    = Obs.Jac.E_r * CAM_rf * Frm(3).state.M; % Jac wrt current frame (manifold 2)
                    Fac.err.J4    = Obs.Jac.E_l(:,7:9) * Lmk.state.M; % Jac wrt idp landmark w/o anchor (manifold 3)

                    Fac.err.Z     = Fac.meas.R; % Measurement Jac is negative identity
                    Fac.err.W     = Fac.err.Z^-1;
                    Fac.err.Wsqrt = chol(Fac.err.W);
                    Fac.state.r1  = Frm(1).state.r;
                    Fac.state.r2  = Frm(2).state.r;
                    Fac.state.r3  = Frm(3).state.r;
                    Fac.state.r4  = Lmk.state.r;
                   
                else
                    error('??? Something went wrong: papPnt meas factor has ''%s'' frames (3 frames max allowed).', numel(Fac.frames))
                end
                
            otherwise
                error('??? Error function of ''%s'' factor linking to lmk type ''%s'' not yet implemented.', Fac.type, Lmk.type);
        end
    otherwise
        error('??? Unknown factor type ''%s''.', Fac.type)
end

if nargout > 1
    % Return unstructured info also (optional)
    e     = Fac.err.z;     % measurement error
    W     = Fac.err.W;     % measurement info matrix
    Wsqrt = Fac.err.Wsqrt; % sqrt of info mat
    J1    = Fac.err.J1;    % Jacobian wrt block 1
    J2    = Fac.err.J2;    % Jacobian wrt block 2
    J3    = Fac.err.J3;    % Jacobian wrt block 3
    J4    = Fac.err.J4;    % Jacobian wrt block 3
    r1    = Fac.state.r1;  % range of block 1
    r2    = Fac.state.r2;  % range of block 2
    r3    = Fac.state.r3;  % range of block 3
    r4    = Fac.state.r4;  % range of block 3
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

