function [L1,L1_l,L1_x1] = reanchorPlucker(L0,x1)

% REANCHORPLUCKER  Plucker to anchored Plucker line conversion
%   REANCHORPLUCKER(L,X) reanchors the anchored Plucker line L to the point X.
%
%   [L1,L1_l,L1_x] = REANCHORPLUCKER(L,X) returns the Jacobians.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


x0 = L0(1:3);
n0 = L0(4:6);
v0 = L0(7:9);

L1 = [x1; n0 + cross((x0-x1),v0); v0];

if nargout > 1

    Z33 = zeros(3);
    I33 = eye(3);

    L1_l = [...
        Z33      Z33    Z33
        -hat(v0) I33 hat(x0-x1)
        Z33      Z33    I33];
    
    L1_x1 = [...
        I33
        hat(v0)
        Z33];
    
end

return

%%
syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 y1 y2 y3 real

L0 = [x1;x2;x3;n1;n2;n3;v1;v2;v3];
y = [y1;y2;y3];

[L1,L1_l,L1_y] = reanchorPlucker(L0,y);

simplify(L1_l - jacobian(L1,L0))
simplify(L1_y - jacobian(L1,y))



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

