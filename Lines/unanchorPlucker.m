function [L,L_al] = unanchorPlucker(aL)

% UNANCHORPLUCKER  Remove Plucker anchor.
%   UNANCHORPLUCKER(L) removes the anchor of the Plucker line L.
%
%   [L,L_Al] = UNANCHORPLUCKER(L,X) returns the Jacobians.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


ax = aL(1:3);
an = aL(4:6);
av = aL(7:9);

L = [an + cross(ax,av);av];

if nargout > 1
    
    Z33 = zeros(3);
    I33 = eye(3);

    L_al = [...
        -hat(av) I33  hat(ax)
        Z33      Z33   I33];
    
end

return

%%

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

aL = [x1;x2;x3;n1;n2;n3;v1;v2;v3];

[L,L_al] = unanchorPlucker(aL);

simplify(L_al - jacobian(L,aL))



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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

