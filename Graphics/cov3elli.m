function [X,Y,Z] = cov3elli(x,P,ns,NP)

% COV3ELLI  3D ellipsoid from Gaussian mean and covariance.
%   [X,Y,Z] = COV3ELLI(x0,P,ns,NP) gives X, Y and Z coordinates of the
%   points corresponding to the 2 biggest semi-diametres of the ellipsoid
%   defined by the covariances matrix P and centered at x0:
%
%        (x-x0)'*(P^-1)*(x-x0) = ns^2.
%
%   The ellipsoid can be plotted in a 3D graphic by just creating a line
%   with line(X,Y,Z).
%
%   See also COV2ELLI, IDP3ELLI, LINE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

persistent spheroid

% Basic shape: 2 circles at 90 degrees, with the pole at the major axis X.
if isempty(spheroid)
    alpha = 2*pi/NP*(0:NP);
    spheroid = [...
        cos(alpha)    cos(alpha)
        sin(alpha)    zeros(1,NP+1)
        zeros(1,NP+1) sin(alpha)];
end

% Rotation R and semi-diameters d, obtained from P by SVD
[R,D] = svd(P);  % rotation matrix R
d     = sqrt(D); % semi-axes

% spheroid -> aligned ellipsoid -> rotated ellipsoid -> ns-ellipsoid
ellip = ns*R*d*spheroid;

% Choleski is not good here: ellipsoid cross not aligned w/ axis
% C = chol(P)';
% ellip = ns*C*spheroid;

% output ready for plotting (X, Y and Z line vectors), offset by x
X = x(1)+ellip(1,:);
Y = x(2)+ellip(2,:);
Z = x(3)+ellip(3,:);



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

