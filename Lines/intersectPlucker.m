function [e,t] = intersectPlucker(L,r)

% INTERSECTPLUCKER  Intersect Plucker lines, get point and abscissa.
%   INTERSECTPLUCKER(L,R)  intersects Plucker lines L and R and returns the
%   point in L that is closest to R.
%
%   [E,T] = INTERSECTPLUCKER(...) returns also the abscissa T so that
%
%       E = P0 + T*v(L)/norm(v(L))
%
%   where
%
%       P0   = LINEORIGIN(L) is the line's local origin
%       v(L) = L(4:6) is the lines director vector.
%
%   See also PLUCKERORIGIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


p0 = pluckerOrigin(L);
e  = lines2Epoint(L,r);

u  = normvec(L(4:6));

% solve the system e = p0 + t*u for variable t:
t = u'*(e - p0); % note that pinv(u) = u' because norm(u) = 1.



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

