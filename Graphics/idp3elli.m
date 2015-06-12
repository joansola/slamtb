function [X,Y,Z] = idp3elli(idp,IDP,ns,NP)

%IDP3ELLI 3D ellipsoid from Gaussian IDP.
%   [X,Y,Z] = IDP3ELLI(x0,P,ns,NP) gives X, Y and Z coordinates of the
%   points corresponding to the 2 biggest semi-diametres of the ellipsoid
%   defined by the covariances matrix P and centered at x0:
%
%        (x-x0)'*(P^-1)*(x-x0) = ns^2.
%
%   where P and x0 are obtained by transforming the input inverse-depth
%   point idp and covariance IDP to an euclidean point:
%
%       x0 = idp2p(idp)
%       P = J*IDP*J'
%
%   being J the Jacobian of the conversion function. This conversion is
%   performed internally by the function PROPAGATEUNCERTAINTY.
%
%   The ellipsoid can be plotted in a 3D graphic by just creating a line
%   with line(X,Y,Z).
%
%   See also COV3ELLI, LINE, IDP2P, PROPAGATEUNCERTAINTY.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[p,P] = propagateUncertainty(idp,IDP,@idp2p);

[X,Y,Z] = cov3elli(p,P,ns,NP);



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

