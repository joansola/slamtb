function [y,Y] = propagateUncertainty(x,X,f)

% PROPAGATEUNCERTAINTY  Non-linear propagation of Gaussian uncertainty.
%   [y,Y] = PROPAGATEUNCERTAINTY(x,X,@f) propagates the Gaussian
%   uncertainty N(x,X) through function f(), resulting in the Gaussian
%   approximation N(y,Y).
%
%   The propagation is made by using the Jacobian of f(), thus the function
%   in file f.m must have the form [y,F] = f(x), with F the Jacobian of f()
%   wrt x.
%
%   See also Q2EG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


[y,Y_x] = f(x);
Y = Y_x*X*Y_x';

return

%% test

x = randn(3,1)
X = randn(3)/1e5
[y,Y] = propagateUncertainty(x,X,@e2q)
[x,X] = propagateUncertainty(y,Y,@q2e)



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

