function drawAplLin(MapFig,Lmk,color,MapOpt)

% DRAWAPLLIN  Draw anchored Plucker line landmark in MapFig.
%   DRAWAPLLIN(MapFig, Lmk, CLR, MapOpt) redraws in figure MapFig the
%   anchored Plucker landmark Lmk, with color CLR. MapOpt is used to
%   control visibility of some objects, see the code for details.

global Map

r   = Lmk.state.r; % range
apl = Map.x(r); % mean
APL = Map.P(r,r); % covariances matrix
[plk,PLK] = propagateUncertainty(apl,APL,@unanchorPlucker);
t   = [Lmk.par.endp.t]'; % abscissas of endpoints, t = [t1;t2]

% % extract endpoints - mean and covariance
[e1,e2,E1_plk,E2_plk] = pluckerEndpoints(plk,t(1),t(2));
E1 = E1_plk*PLK*E1_plk';
E2 = E2_plk*PLK*E2_plk';

% the mean:
set(MapFig.Lmk(Lmk.lmk).mean,...
    'xdata',   [e1(1);e2(1)],...
    'ydata',   [e1(2);e2(2)],...
    'zdata',   [e1(3);e2(3)],...
    'color',   color.mean,...
    'marker',  'none',...
    'visible', 'on');

% the covariance ellipses
if MapOpt.showEllip
    [X,Y,Z] = cov3elli(e1, E1, 3, 10) ;
    set(MapFig.Lmk(Lmk.lmk).ellipse(1),...
        'xdata',   X,...
        'ydata',   Y,...
        'zdata',   Z,...
        'color',   color.ellip,...
        'visible', 'on');

    [X,Y,Z] = cov3elli(e2, E2, 3, 10) ;
    set(MapFig.Lmk(Lmk.lmk).ellipse(2),...
        'xdata',   X,...
        'ydata',   Y,...
        'zdata',   Z,...
        'color',   color.ellip,...
        'visible', 'on');
end

% the label
n = plk(1:3); % Plucker's normal vector
posOffset = 0.2*n;     % label orthogonally out of the line.
set(MapFig.Lmk(Lmk.lmk).label,...
    'position', 0.5*(e1+e2) + posOffset,...
    'string',   num2str(Lmk.id),...
    'visible',  'on');



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

