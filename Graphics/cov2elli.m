function [X,Y] = cov2elli(x,P,ns,NP)

% COV2ELLI  Ellipse points from mean and covariances matrix.
%   [X,Y] = COV2ELLI(X0,P,NS,NP) returns X and Y coordinates of the NP
%   points of the the NS-sigma bound ellipse of the Gaussian defined by
%   mean X0 and covariances matrix P.
%
%   The ellipse can be plotted in a 2D graphic by just creating a line
%   with line(X,Y).
%
%   See also COV3ELLI, LINE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


persistent circle

if isempty(circle)
    alpha = 2*pi/NP*(0:NP);
    circle = [cos(alpha);sin(alpha)];
end

% SVD method, R*d*d*R' = P
% [R,D]=svd(P);
% d = sqrt(D);
% % circle -> aligned ellipse -> rotated ellipse -> ns-ellipse
% ellip = ns*R*d*circle;

% Choleski method, C*C' = P
C = chol(P)';
ellip = ns*C*circle;

% output ready for plotting (X and Y line vectors)
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);



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

