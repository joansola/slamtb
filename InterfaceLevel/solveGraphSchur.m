function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphSchur(Rob,Sen,Lmk,Obs,Frm,Fac,options)

% SOLVEGRAPHSCHUR Solves the SLAM graph using Schur decomposition.
%   [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphSchur(Rob,Sen,Lmk,Obs,Frm,Fac)
%   solves the graph-SLAM problem using Schur decomposition of the
%   Hessian matrix.
%
%   IMPORTANT NOTE: This method is illustrative and constitutes the
%   motivation for this toolbox. One can achieve better performances, both
%   in computing time and possibly in robustness and accuracy, by using
%   Matlab's built-in nonlinear optimization tools, such as LSQNONLIN.
%
%   See courseSLAM.pdf in the documentation for details about the Schur
%   decomposition for solving the graph-SLAM problem.
%
%   See also ERRORSTATEJACOBIANS, UPDATESTATES, COMPUTEERROR,
%   COMPUTERESIDUAL, COLAMD, '\', MLDIVIDE, LSQNONLIN.

% Copyright 2015-    Joan Sola @ IRI-UPC-CSIC.

global Map

% Control of iterations and exit conditions
n_iter      = options.niterations; % exit criterion of number of iterations
target_dres = options.target_dres; % exit criterion for error variation
target_res  = options.target_res;  % exit criterion for current residual
res_old     = 1e10;                   % last iteration's error

% Map states range
Map.mr = find(Map.used);

for it = 1:n_iter
    
    % Compute Jacobians for projection onto the manifold
    [Frm,Lmk] = errorStateJacobians(Frm,Lmk);
    
    % Build Hessian H and rhs vector b, in global Map
    Fac       = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac);
    
    % Get partition ranges
    fr = ranges(Frm);
    lr = ranges(Lmk);
    
    % Get Schur complement -- The schur complement Spp is the sqrt factor
    [Map.sSff, Map.iHll] = schurc(Map.H(Map.mr,Map.mr),lr,fr,1);
    
    % Solve frames subproblem
    bf        = Map.b(fr) - Map.H(fr,lr) * Map.iHll * Map.b(lr);
    y         = - Map.sSff'\bf;
    Map.x(fr) = Map.sSff\y;
    
    % Solve landmarks subproblem
    bl        = Map.b(lr) + Map.H(lr,fr) * Map.x(fr);
    Map.x(lr) = - Map.iHll * bl;
        
    % Update nominal states
    [Rob,Lmk,Frm]  = updateStates(Rob,Lmk,Frm);
    
    % Check resulting errors
    [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac);
    dres           = res - res_old;
    res_old        = res;
    
    if ( ( -dres <= target_dres ) || (err_max <= target_res) ) %&& ( abs(derr) < target_derr) )
        break;
    end
    
end

end


function Fac = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac)

% BUILDPROBLEM Build least squares problem's matrix H and vector b
%   Fac = BUILDPROBLEM(Rob,Sen,Lmk,Obs,Frm,Fac) Builds the least squares
%   problem's matrix H and vector b for a solution using sparse Schur
%   factorization of H.

global Map

% Reset Hessian and rhs vector
Map.H(Map.mr,Map.mr) = 0;
Map.b(Map.mr)    = 0;

% Iterate all factors
for fac = find([Fac.used])
    
    % Extract some pointers
    rob    = Fac(fac).rob;
    sen    = Fac(fac).sen;
    lmk    = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, info mat, and Jacobians
    [Fac(fac), e, W, ~, J1, J2, r1, r2] = computeError(...
        Rob(rob),       ...
        Sen(sen),       ...
        Lmk(lmk),       ...
        Obs(sen,lmk),   ...
        Frm(frames),    ...
        Fac(fac));
    
    % Compute sparse Hessian blocks
    H_11 = J1' * W * J1;
    H_12 = J1' * W * J2;
    H_22 = J2' * W * J2;
    
    % Compute rhs vector blocks
    b1   = J1' * W * e;
    b2   = J2' * W * e;
    
    % Update H and b
    Map.H(r1,r1) = Map.H(r1,r1) + H_11;
    Map.H(r1,r2) = Map.H(r1,r2) + H_12;
    Map.H(r2,r1) = Map.H(r2,r1) + H_12';
    Map.H(r2,r2) = Map.H(r2,r2) + H_22;
    
    Map.b(r1,1)  = Map.b(r1,1)  + b1;
    Map.b(r2,1)  = Map.b(r2,1)  + b2;
    
end

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

