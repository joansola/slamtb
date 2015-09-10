function [a, A_u, A_v] = vecsAngle(u,v)

% VECSANGLE  Angle between two vectors.
%   VECSANGLE(U,V) returns the angle between column vectors U and V. The
%   angle is defined between 0 and pi.
%
%   VECSANGLE(U,M) returns a row vector with the m angles between the
%   n-vector U and the m colums of the n-by-m matrix M.
%
%   [A, A_u, A_v] = VECSANGLE(U,V) returns teh Jacobians wrt U and V. Note
%   that this only works for single vectors U and V.

%   Copyright 2008,2009,2010 Joan Sola @ LAAS-CNRS, old acos() version.
%   Copyright 2015- Joan Sola @ IRI-CSIC-UPC, better atan2() version, jacs.


if size(v,2) == 1
    
    if nargout == 1 

        a = atan2(norm(cross(u,v)), dot(u,v));
    
    else % we want Jacobians
        
        [uxv, UXV_u, UXV_v] = crossJ(u,v);          % OK
        [nuxv, NUXV_uxv]    = vecnorm(uxv);         % OK
        [udv, UDV_u, UDV_v] = dotJ(u,v);            % OK
        [a, A_nuxv, A_udv]  = atan2jac(nuxv, udv);  % OK
        
        A_uxv = A_nuxv*NUXV_uxv;                    % OK
        
        A_u = A_uxv*UXV_u + A_udv*UDV_u;    % See note 1) below
        A_v = A_uxv*UXV_v + A_udv*UDV_v;    % See note 1) below
        
    end

else
    
    uxv  = hat(u)*v;            % cross(u,v) for v = M
    nuxv = sqrt(sum(uxv.*uxv)); % all norms of the above
    udv  = u'*v;                % all dot prods of u and M
    
    a    = atan2( nuxv , udv );
    
end

%% Notes
%
% 1) Let w=h(u,v), u=f(x), v=g(x). Then,
%   dw/dx = dw/du * du/dx + dw/dv * dv/dx.


return

%%
syms u v w x y z real
U=[u;v;w];
V=[x;y;z];
[a,A_u,A_v]=vecsAngle(U,V);

simplify(A_u - jacobian(a,u))
simplify(A_v - jacobian(a,v))


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

