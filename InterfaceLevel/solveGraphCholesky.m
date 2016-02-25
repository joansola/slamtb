function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac,options)

% SOLVEGRAPHCHOLESKY Solves the SLAM graph using Cholesky decomposition.
%   [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac)
%   solves the graph-SLAM problem using Cholesky decomposition of the
%   Hessian matrix. 
%
%   IMPORTANT NOTE: This method is illustrative and constitutes the
%   motivation for this toolbox. One can achieve better performances, both
%   in computing time and possibly in robustness and accuracy, by using
%   Matlab's built-in nonlinear optimization tools, such as LSQNONLIN.
%   
%   See courseSLAM.pdf in the documentation for details about the Cholesky
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
    
%     fprintf('----------------\nIteration: %d; \n',it)

    % Compute Jacobians for projection onto the manifold
    [Frm,Lmk] = errorStateJacobians(Frm,Lmk);
    
    % Build Hessian H and rhs vector b, in global Map
    Fac       = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac);
    % This function must be defined as a local function within this same
    % file. You will find the prototype at the bottom of this file. You
    % have to write the whole function. There are some comments to help you
    % with this job.
    
    % After this line, the global variable Map has been updated. Relevant
    % fields are:
    %   Map.H : Hessian matrix
    %   Map.b : error vector
    %   Map.mr: indices to all states being used
    % Then, by doing mr = Map.mr, one can access the current Hessian and
    % error vector:
    %   H = Map.H(mr,mr)
    %   b = Map.b(mr)
    % From this point on, we should be able to solve for dx. For this,
    % follow these steps:
    %
    
    % 1) Apply reordering
    %   Use colamd() on matrix H
    %   Store the result in permutation vector pr
    
    % 2) Get the Choolesky decomposition of H
    %   Use chol() on the reordered H
    %   Check for ill-conditioning of H and issue an error if necessary
    %   Type '> help chol' for help.
    %   Store the result in Map.R
    
    % 3) Solve R'*y = b and R*dx = y
    %   Use operator '\'. Type '> help \' for help
    %   Store the result in variable dx
    
    % 4) Transfer dx to Map.x 
    %   Use the permutation vector pr computed in 1).
    
    % At this point, we have the update step stored in the Map variable, in
    % Map.x, in the original ordering.
    
    % We can use this step to update each of the state blocks:
    %   - All the Frames in Frm    --- use updateKeyFrame()
    %   - All the landmarks in Lmk --- use a linear update.
    % Type '> help updateKeyFrame' for help.
    
    
    % The algorithm continues by checking the new residual error and
    % deciding on whether it is necessary to continue iterating. You do
    % not have to code this part.
        
    % Check resulting errors
    [res, err_max] = computeResidual(Rob,Sen,Lmk,Obs,Frm,Fac);
    dres           = res - res_old;
    res_old        = res;
    
    %         fprintf('Residual: %.2e; variation: %.2e \n', res, dres)
    
    if ( ( -dres <= target_dres ) || (err_max <= target_res) ) %&& ( abs(derr) < target_derr) )
        break;
    end
    
end

end


function Fac = buildProblem(Rob,Sen,Lmk,Obs,Frm,Fac)

% BUILDPROBLEM Build least squares problem's matrix H and vector b 
%   Fac = BUILDPROBLEM(Rob,Sen,Lmk,Obs,Frm,Fac) Builds the least squares
%   problem's matrix H and vector b for a solution using sparse Cholesky
%   factorization of H.

global Map

% In this function, we build the problem to be solved by Cholesky
% factorization. The goal, then, is to enter the right values in the
% Hessian matrix,
%
%   Map.H
%
% and the error vector,
%
%   Map.b
%
% using the methods in the documentation, see graphSLAM.pdf.

% The variable Map stores the following important fields (type
% '> diginto(Map)' for the full structure)
%
%   Map.H : preallocated Hessian matrix
%   Map.b : preallocated error vector
%   Map.mr: vector of indices of all states used.
%
% the indices vector Map.mr is very useful to exploit sparsity. Use it as
% follows:
%
%   mr = Map.mr:  <-- just to make a short name for these notes
%
%   H = Map.H(mr,mr) is the current Hessian matrix, using only the states
%   currently active in the problem.
%
%   b = Map.b(mr) is the current error vector, using only the states
%   currently active in the problem.
%
% To filll the blocks of Map.H and Map.b, you need to access them via the
% ranges of the state blocks you are considering. Examples:
%
%   rr = Frm.state.r <-- vector of indices to the robot's state block
%   lr = Lmk.state.r <-- vectos of indices to the landmark's state block
%
% you can use these ranges to access the appropriate blocks in the Hessian:
%
%   Map.H(rr,rr) is the Hessian block of the robot
%   Map.H(lr,lr) is the Hessian block of the landmark
%   Map.H(rr,lr) is the Hessian block of the robot and landmark
%   Map.H(lr,rr) is the Hessian block of the landmark and robot
%
% Similarly, we can access the  error vector blocks with Map.b(rr) and
% Map.b(lr).

% To write this function, follow the Cholesky algorithm in courseSLAM.pdf.
% We provide the error function computeError(), returning the following
% fields (type '> help computeError' for help):
%
%   Fac: an updated structure for the factor Fac
%   e  : the factor error
%   W  : the factor information matrix
%   Wsq: the square root of W
%   J1 : the Jacobian wrt the first state block
%   J2 : the Jacobian wrt the second state block
%   r1 : the range of the first state block
%   r2 : the range of the second state block
%
% Easily, the ranges r1 and r2 are used instead of rr and rl in the example
% above.
%
% Similarly, the Jacobians J1 and J2 are used to compute the Hessian blocks
% and error vector blocks. Again, consult the Cholesky algorithm in
% courseSLAM.pdf.

% It follows a guideline of the code you need to insert

% 1) Reset Hessian H and error vector b

% 2) Iterate for all factors present in the problem
for fac = find([Fac.used])
    
    % 2.a Extract relevant pointers for the factor
    % rob    = <-- robot associated to the factor...
    % sen    = <-- sensor   ... idem ...
    % lmk    = <-- landmark ... idem ...
    % frames = <-- frames   ... idem ...
    
    % 2.b Compute factor error, info mat, and Jacobians
    [Fac(fac), e, W, ~, J1, J2, r1, r2] = computeError(...
        Rob(rob),       ...
        Sen(sen),       ...
        Lmk(lmk),       ...
        Obs(sen,lmk),   ...
        Frm(frames),    ...
        Fac(fac));

    % 2.c Compute sparse Hessian blocks
    % H_11 = <-- block 1-1;
    % H_12 = <-- block 1-2;
    % H_22 = <-- block 2-2;
    % H_21 = <-- block 2-1;
    
    % 2.d Compute rhs vector blocks
    % b1   = <-- block 1;
    % b2   = <-- block 2;
    
    % 2.e Update H and b
    % Map.H(r1,r1) = <-- block 1-1;
    % ... etc for the other blocks of Map.H and Map.b.

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

