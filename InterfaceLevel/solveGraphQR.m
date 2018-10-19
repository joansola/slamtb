function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphQR(Rob,Sen,Lmk,Obs,Frm,Fac,options)

% SOLVEGRAPHQR Solves the SLAM graph using QR decomposition.
%   [Rob,Sen,Lmk,Obs,Frm,Fac] = SOLVEGRAPHQR(Rob,Sen,Lmk,Obs,Frm,Fac)
%   solves the graph-SLAM problem using QR decomposition of the
%   Hessian matrix. 
%
%   IMPORTANT NOTE: This method is illustrative and constitutes the
%   motivation for this toolbox. One can achieve better performances, both
%   in computing time and possibly in robustness and accuracy, by using
%   Matlab's built-in nonlinear optimization tools, such as LSQNONLIN.
%   
%   See courseSLAM.pdf in the documentation for details about the QR
%   decomposition for solving the graph-SLAM problem.
%
%   See also SOLVEGRAPHCHOLESKY, ERRORSTATEJACOBIANS, UPDATESTATES,
%   COMPUTEERROR, COMPUTERESIDUAL, COLAMD, '\', MLDIVIDE, LSQNONLIN.

% Copyright 2015-    Joan Sola @ IRI-UPC-CSIC.

global Map

% Control of iterations and exit conditions
n_iter      = options.niterations; % exit criterion of number of iterations
target_dres = options.target_dres; % exit criterion for error variation
target_res  = options.target_res;  % exit criterion for current residual
res_old     = 1e10;                   % last iteration's error

% Map states range
Map.mr = find(Map.used);
% Map factors range
errs = [Fac.err];
Map.fr = 1:sum([errs.size]);

for it = 1:n_iter
    
    % Compute Jacobians for projection onto the manifold
    [Frm,Lmk] = errorStateJacobians(Frm,Lmk);
    
    % Build Hessian A and rhs vector b, in global Map
    Fac       = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac);
    
    if it == 1 % do this only once:
        
        % Column permutation
        p  = colamd(Map.A(Map.fr,Map.mr))';
        
        % Permutated map range
        pr = Map.mr(p);
        Map.pr = pr;
        
    end
    
    % Decomposition
    [Map.d, Map.R] = qr(Map.A(Map.fr,pr), Map.b(Map.fr), 0);
    
    % Solve for dx and reorder:
    %   - dx is Map.x(mr)
    %   - reordered dx is Map.x(pr)
    Map.x(pr) = -Map.R\Map.d; % solve for dx;
    
    % NOTE: Matlab is able to do all the reordering and QR factorization
    % for you. If you just use the operator '\', as in 'dx = -A\b', Matlab
    % will reorder A, then factor it to get R and d, then solve the
    % factored problem, then reorder back the result into dx. Use the
    % following line to accomplish this, and comment out the code from line
    % 'if it == 1' until here:
    %
    %     Map.x(Map.mr) = -Map.A(Map.fr,Map.mr)\Map.b(Map.fr);
    
    % Update nominal states
    [Rob,Lmk,Frm] = updateStates(Rob,Lmk,Frm);
    
    % Check resulting errors
    [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac);
    dres           = res - res_old;
    res_old        = res;
    
    % Test and exit
    if ( ( -dres <= target_dres ) || (err_max <= target_res) ) %&& ( abs(derr) < target_derr) )
        break;
    end
    
end

% Compute full covariance matrix.
Map.P(pr,pr) = inv(full(Map.R))*inv(full(Map.R))';

end

function Fac = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac)

% BUILDPROBLEM Build least squares problem's matrix A and vector b 
%   Fac = BUILDPROBLEM(Rob,Sen,Lmk,Obs,Frm,Fac) Builds the least squares
%   problem's matrix A and vector b for a solution using sparse QR
%   factorization of A.

global Map


% Reset Hessian and rhs vector
Map.A(Map.fr,Map.mr) = 0;
Map.b(Map.fr)    = 0;

% Iterate all factors
facCount = 1;
for fac = find([Fac.used])
    
    % Extract some pointers
    rob    = Fac(fac).rob;
    sen    = Fac(fac).sen;
    lmk    = Fac(fac).lmk;
    frames = Fac(fac).frames;
    
    % Compute factor error, info mat, and Jacobians
    [Fac(fac), e, ~, Wsqrt, J1, J2, r1, r2] = computeError(...
        Rob(rob),       ...
        Sen(sen),       ...
        Lmk(lmk),       ...
        Obs(sen,lmk),   ...
        Frm(frames),    ...
        Fac(fac));
        
    % row band matrix size
    m  = numel(e);
    mr = (facCount : facCount + m - 1);
    
    % Update A and b
    Map.A(mr,r1) = Wsqrt * J1;
    Map.A(mr,r2) = Wsqrt * J2;
    
    Map.b(mr,1)  = Wsqrt * e;

    % Advance to next row band
    facCount = facCount + m;

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

