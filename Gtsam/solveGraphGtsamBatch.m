function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphGtsamBatch(Rob,Sen,Lmk,Obs,Frm,Fac,Opt)

% SOLVEGRAPHGTSAM Solves the SLAM graph using GTSAM.
%   [Rob,Sen,Lmk,Obs,Frm,Fac] = SOLVEGRAPHGTSAM(Rob,Sen,Lmk,Obs,Frm,Fac)
%   solves the graph-SLAM problem using GTSAM as a backend.
%
%   See also SOLVEGRAPHCHOLESKY, ERRORSTATEJACOBIANS, UPDATESTATES,
%   COMPUTEERROR, COMPUTERESIDUAL, COLAMD, '\', MLDIVIDE, LSQNONLIN.

% Copyright 2015    Ellon Paiva @ LAAS-CNRS.

global Map

% Build new factors to be added to ISAM
% Also get index of factors to be removed due to replacement
newFactors = gtsam.NonlinearFactorGraph;
[Fac, newFactors] = makeGtsamFactors(Rob,Sen,Lmk,Obs,Frm,Fac,Opt,newFactors);

% Gather new values from Frm and Lmk
initialEstimates = gtsam.Values;
[ Lmk, Frm, initialEstimates] = getGtsamValues(Lmk,Frm,initialEstimates);

% Update ISAM
try
    LMoptimizer = gtsam.LevenbergMarquardtOptimizer(newFactors, initialEstimates);
%     result = LMoptimizer.optimize();
    LMoptimizer.iterate();
catch e
    display(e.message);
    error('LMoptimizer threw an exeption. Use the lines below to inspect its internals internals.')
    nonlinearFactorGraph = Map.gtsam.isam.getFactorsUnsafe();
    linearizationPoint = Map.gtsam.isam.getLinearizationPoint();
    gaussianFactorGraph = nonlinearFactorGraph.linearize(linearizationPoint);
%     jacobian = gaussianFactorGraph.augmentedJacobian(); % WARNING: This line crashes matlab
    hessian = gaussianFactorGraph.augmentedHessian();
    figure; spy(hessian);
    varIndex = Map.gtsam.isam.getVariableIndex
end

% Do extra updates if requested
for i = 1:Opt.solver.niterations-1
    LMoptimizer.iterate();
end

% Update Frm and Lmk from isam result
result = LMoptimizer.values();
[Lmk, Frm] = updateStatesFromGtsam(Sen,Lmk,Frm,result);


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

