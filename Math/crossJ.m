function [c,Ca,Cb] = crossJ(a,b)

% CROSSJ  Cross product with Jacobians output
%   CROSSJ(A,B) is equivalent to CROSS(A,B) when A and B are 3-vectors.
%
%   [c,Ca,Cb] = CROSSJ(A,B) returns the Jacobians wrt A and B.
%
%   See also CROSS, HAT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

c = cross(a,b);

if nargout > 1
    
    Ca = -hat(b);

    Cb = hat(a);

end

return

%%

syms x y z u v w real
a = [x;y;z];
b = [u,v,w];

[c,Ca,Cb] = crossJ(a,b);

Ca - jacobian(c,a)

Cb - jacobian(c,b)



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

