function g = gauss(x, m, P)

% GAUSS Gaussian distribution value
%   GAUSS(X, M, P) gives the probability density at point X, following a
%   Gaussian or Normal distribution with mean M and covariances matrix P.
%
%   For X vector, the evaluation happens at a single point denoted by X,
%   and the result is a positive scalar in the range [0 , 1].
%
%   For X matrix, the evaluation happens at each row of X, and the result
%   is a row-vector of scalars, one for each column of X.

%   Copyright 2013 Joan Sola

d = size(x,1);
n = size(x,2);
MD2 = zeros(1,n);

if (size(m,1) == d) && (size(P,1) == d) && (size(P,2) == d)
    
    z = x - repmat(m, 1, n);
    for i = 1:n
        MD2(1,i) = z(:,i)' * P^-1 * z(:,i);
    end
    a = sqrt((2*pi)^d * det(P));
    g = exp(-0.5 * MD2) / a;
    
else
    error ('Input sizes don''t match')
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

