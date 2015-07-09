function [MapFig,SenFig] = createGraphicsStructures(...
    Rob, Sen, Lmk, Obs,...
    Trj, Frm, Fac, ...
    SimRob, SimSen, SimLmk,...
    FigOpt)

% CREATEGRAPHICSSTRUCTURES Create figures and graphics handles structures.
%   [MAPFIG,SENFIG] = CREATEGRAPHICSSTRUCTURES ...
%       (ROB,SEN,LMK,OBS,SIMROB,SIMSEN,SIMLMK,MAPFIGURE,SENFIGURES) creates
%   a 3D figure MapFig and one figure for each sensor in Sen(). It returns
%   a structure MAPFIG with handles to objects in the map figure, and a
%   structure array SENFIG with handles to graphics objects in each sensor
%   figure. To do so, its need information from the following sources:
%
%       ROB:      Structure array of robots.
%       SEN:      Structure array of sensors.
%       LMK:      Structure array of landmarks.
%       OBS:      Structure array of observations.
%       SIMROB:   Structure array of simulated robots.
%       SIMSEN:   Structure array of simulated sensors.
%       SIMLMK:   Structure array of simulated landmarks.
%       FIGOPT:   User-defined structure with options for figures
%
%   See also CREATEMAPFIG, CREATESENFIG, USERDATA, SLAMTB, and
%   consult slamToolbox.pdf in the root directory.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


% Init map figure
MapFig = createMapFig(Rob,Sen,Lmk, Trj, Frm, Fac,SimRob,SimSen,SimLmk,FigOpt);

% Init sensor's measurement space figures
SenFig = createSenFig(Sen,Obs,SimLmk,FigOpt);



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

