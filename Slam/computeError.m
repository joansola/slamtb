function [Fac, e, W, J1, J2, r1, r2] = computeError(Rob,Sen,Lmk,Obs,Frm,Fac)

switch Fac.type
    case 'absolute'
        % Given an expected pose and a pose measurement, compute the error
        % as the minimal pose that transforms the measurement into the
        % given pose, that is:
        %   err = minimal(frameIncrement(meas, expected))
        % where frameIncrement(F,G) implements the composition of the
        % inverse of F and G,
        %   composeFrames(invertFrame(F), G)
        % and minimal() is a 6 DoF expression of the frame, done using the
        % function qframe2vframe().
        Fac.exp.e = Frm.state.x;
        [pq, PQ_y, PQ_e] = frameIncrement(Fac.meas.y, Fac.exp.e); % h(x) (-) y
        [Fac.err.z, Z_pq] = qpose2vpose(pq);
        Fac.err.J1 = Z_pq * PQ_e * Frm.state.M; % Jac wrt manifold
        Fac.err.J2 = zeros(6,0);
        Z_y = Z_pq * PQ_y;
        Fac.err.Z = symmetrize(Z_y * Fac.meas.R * Z_y');
        Fac.err.W = Fac.err.Z^-1;
        Fac.state.r1 = Frm.state.r;
        Fac.state.r2 = [];
        
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
        [pq, PQ_y, PQ_e] = frameIncrement(Fac.meas.y, Fac.exp.e); % h(x) (-) y
        [Fac.err.z, Z_pq] = qpose2vpose(pq);
        Fac.err.J1 = Z_pq * PQ_e * E_x1 * Frm(1).state.M; % Jac wrt manifold 1
        Fac.err.J2 = Z_pq * PQ_e * E_x2 * Frm(2).state.M; % Jac wrt manifold 2
        Z_y = Z_pq * PQ_y;
        Fac.err.Z = symmetrize(Z_y * Fac.meas.R * Z_y');
        Fac.err.W = Fac.err.Z^-1;
        Fac.state.r1 = Frm(1).state.r;
        Fac.state.r2 = Frm(2).state.r;

    case 'measurement'
        Rob = frm2rob(Rob,Frm);
        Obs = projectLmk(Rob,Sen,Lmk,Obs);
        Fac.exp.e = Obs.exp.e;
        Fac.err.z = Fac.exp.e - Fac.meas.y; % h(x) (-) y
        Fac.err.J1 = Obs.Jac.E_r * Frm.state.M; % Jac wrt manifold 1
        Fac.err.J2 = Obs.Jac.E_l * Lmk.state.M; % Jac wrt manifold 2
        Fac.err.Z = Fac.meas.R; % Measurement Jac is negative identity
        Fac.err.W = Fac.err.Z^-1;
        Fac.state.r1 = Frm.state.r;
        Fac.state.r2 = Lmk.state.r;
    otherwise
        error('??? Unknown factor type ''%s''.', Fac.type)
end

if nargout > 1
    e = Fac.err.z;
    W = Fac.err.W;
    J1 = Fac.err.J1;
    J2 = Fac.err.J2;
    r1 = Fac.state.r1;
    r2 = Fac.state.r2;
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

