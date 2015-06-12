function [idp,IDP_p,IDP_p0] = p2idp(p,p0)

% P2IDP Point to inverse-depth point conversion.
%   P2IDP(P,P0) is the inverse depth point anchored at P0 corresponding to
%   the Euclidean point P.
%
%   An inverse-depth point (idp) is a 6-vector: 
%
%           idp = [x0 y0 z0 el az rho]',
%
%   where:
%       x0, z0, y0: anchor: the 3D point P0 where where distance is referred to.
%       el, az: azimuth and elevation of the ray through P that starts at P0.
%       rho: inverse of the distance from point P to P0.
%
%   [idp,IDP_p,IDP_p0] returns the Jacobians wrt P and P0.
%
%   See also IDP2P.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if nargout == 1
    m   = p-p0;
    rho = 1/sqrt(dot(m,m));
    py  = vec2py(m);

    idp = [p0;py;rho];
else

    m           = p-p0;
    M_p         = 1;
    M_p0        = -1;
    [mn2,MN2_m] = dotJ(m,m);
    rho         = 1/mn2;
    RHO_mn2     = -1/mn2^2;
    [py,PY_m]   = vec2py(m);

    idp = [p0;py;rho];

    RHO_m = RHO_mn2*MN2_m;
    
    IDP_p = [zeros(3);PY_m*M_p;RHO_m*M_p];
    IDP_p0 = [eye(3);PY_m*M_p0;RHO_m*M_p0];

end


return

%% Jac

syms x y z x0 y0 z0 real
p = [x;y;z];
p0 = [x0;y0;z0];

idp = p2idp(p,p0);

simplify(IDP_p  - jacobian(idp,p))
simplify(IDP_p0 - jacobian(idp,p0))



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

