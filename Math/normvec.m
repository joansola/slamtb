function [vn,VN_v] = normvec(v,jacMethod)

% NORMVEC Normalize vector.
%   NORMVEC(V) is the unit length vector in the same direction and sense as
%   V. It is equal to V/norm(V).
%
%   [NV,NV_v] = NORMVEC(V) returns the Jacobian of the normed vector wrt V.
%
%   [NV,NV_v] = NORMVEC(V,method) , with method ~= 0, uses a scalar diagonal
%   matrix as Jacobian, meaning that the vector has been just scaled to
%   length one by a scalar factor.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

n2 = dot(v,v);
n  = sqrt(n2);

vn = v/n;

if nargout > 1
    s = numel(v);

    if nargin > 1 && jacMethod ~= 0  % use scalar method (approx)
        VN_v = eye(s)/n;
        
    else                             % use full vector method (exact)
        n3  = n*n2;       
        VN_v = (n2*eye(s) - v*v')/n3;
        
    end

end

return

%%
syms v1 v2 v3 v4 v5 real
v = [v1;v2;v3;v4;v5];
[vn,VN_v] = normvec(v);

simplify(VN_v - jacobian(vn,v))



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

