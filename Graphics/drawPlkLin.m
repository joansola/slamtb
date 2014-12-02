function drawPlkLin(MapFig,Lmk,color,MapOpt)

% DRAWPLKLIN  Draw Plucker line landmark in MapFig.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

r   = Lmk.state.r; % range
plk = Map.x(r); % mean
PLK = Map.P(r,r); % covariances matrix
t   = [Lmk.par.endp.t]'; % abscissas of endpoints, t = [t1;t2]

% % extract endpoints - mean and covariance
[e1,e2,E1_plk,E2_plk] = pluckerEndpoints(plk,t(1),t(2));
E1 = E1_plk*PLK*E1_plk';
E2 = E2_plk*PLK*E2_plk';

% the mean:
drawSeg(MapFig.Lmk(Lmk.lmk).mean,[e1;e2],color.mean)

% the covariance ellipses
if MapOpt.showEllip
    drawEllipse(MapFig.Lmk(Lmk.lmk).ellipse(1), e1, E1, color.ellip)
    drawEllipse(MapFig.Lmk(Lmk.lmk).ellipse(2), e2, E2, color.ellip)
end

% the label
n = plk(1:3); % Plucker's normal vector
posOffset = 0.2*n;     % label orthogonally out of the line.
drawLabel(MapFig.Lmk(Lmk.lmk).label,0.5*(e1+e2) + posOffset,num2str(Lmk.id))



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

