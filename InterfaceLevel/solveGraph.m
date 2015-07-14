function [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraph(Rob,Sen,Lmk,Obs,Frm,Fac,Opt)

% SOLVEGRAPH  Solve the SLAM problem posed as a graph of states and
% factors.
%
%   [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraph(Rob,Sen,Lmk,Obs,Frm,Fac,Opt)
%   solves the graph defined by Frm, Lmk and Fac, using one solver
%   specified in Opt.
%
%   See also SOLVEGRAPHCHOLESKY, SOLVEGRAPHQR, SOLVEGRAPHSCHUR.

% Take algorithms from courseSLAM.pdf

switch Opt.solver.decomposition
    case 'QR'
        [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphQR(Rob,Sen,Lmk,Obs,Frm,Fac,Opt.solver);
    case 'Cholesky'
        [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphCholesky(Rob,Sen,Lmk,Obs,Frm,Fac,Opt.solver);
    case 'Schur'
%         error('??? Graph solver ''%s'' not implemented. Try ''Cholesky''.', Opt.solver.decomposition)
        [Rob,Sen,Lmk,Obs,Frm,Fac] = solveGraphSchur(Rob,Sen,Lmk,Obs,Frm,Fac,Opt.solver);
    otherwise
        error('??? Unknown graph solver ''%s''.', Opt.map.solver)
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

