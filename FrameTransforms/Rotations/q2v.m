function [v, V_q] = q2v(q)

%Q2V Quaternion to rotation vector conversion.
%   Q2V(Q) transforms the quaternion Q into a rotation vector representing
%   the same rotation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.
%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.

if nargout == 1
    
    [a,u] = q2au(q);
    v = a*u;
    
else

    [a,u,A_q,U_q] = q2au(q);
    v   = a*u;
    V_a = u;
    V_u = a; % = a*eye(3);
    
    if ~isnumeric(a) || a > 1e-7
        V_q = V_a*A_q + V_u*U_q;
    else
        V_q = [zeros(3,1) 2*eye(3)];
    end

end

return

%%
syms q0 q1 q2 q3 real
q = [q0;q1;q2;q3];
[v, V_q] = q2v(q);

simplify(V_q - jacobian(v,q))


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

