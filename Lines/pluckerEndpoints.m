function [e1,e2,E1_l,E2_l,E1_s1,E2_s2] = pluckerEndpoints(L,s1,s2)

% PLUCKERENDPOINTS  Plucker line and abscissas to endpoints conversion.
%   [E1,E2] = PLUCKERENDPOINTS(L,S1,S2) are the endpoints of the Plucker
%   line L at abscissas S1 and S2.
%
%   [E1,E2,E1_l,E2_l,E1_s1,E2_s2] = PLUCKERENDPOINTS(L,S1,S2) returns the
%   Jacobians wrt the line L and the abscissas S1 and S2.
%
%   See also LS2E, LS2SEG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

v = L(4:6);

if nargout == 1

    vn = normvec(v);
    p0 = pluckerOrigin(L);
    e1 = p0 + s1*vn;
    e2 = p0 + s2*vn;

else % Jac
    
    [vn,VN_v] = normvec(v,0);
    [p0,P0_l] = pluckerOrigin(L);

    P0_n  = P0_l(:,1:3);
    P0_v  = P0_l(:,4:6);
    
    e1    = p0 + s1*vn;
    E1_s1 = vn;

    E1_n  = P0_n;
    E1_v  = P0_v + s1*VN_v;

    E1_l  = [E1_n E1_v];

    e2    = p0 + s2*vn;
    E2_s2 = vn;

    E2_n  = P0_n;
    E2_v  = P0_v + s2*VN_v;

    E2_l  = [E2_n E2_v];

end

return

%% jac

syms n1 n2 n3 v1 v2 v3 s1 s2 real
L = [n1;n2;n3;v1;v2;v3];

[e1,e2,E1_l,E2_l,E1_s1,E2_s2] = pluckerEndpoints(L,s1,s2);

simplify(E1_l - jacobian(e1,L))
simplify(E2_l - jacobian(e2,L))
simplify(E1_s1 - jacobian(e1,s1))
simplify(E2_s2 - jacobian(e2,s2))



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

