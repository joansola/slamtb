function [aL,AL_l,AL_x] = anchorPlucker(L,x)

% ANCHORPLUCKER  Plucker to anchored Plucker line conversion
%   ANCHORPLUCKER(L,X) anchors the Plucker line L to the point X.
%
%   [aL,AL_l,AL_x] = ANCHORPLUCKER(L,X) returns the Jacobians of the
%   conversion wrt L and X.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

n = L(1:3);
v = L(4:6);

aL = [x;n-cross(x,v);v];

if nargout > 1
    
    Z33 = zeros(3);
    I33 = eye(3);
    
    AL_l = [...
        Z33 Z33
        I33 -hat(x)
        Z33 I33];
    
    AL_x = [...
        I33
        hat(v)
        Z33];
    
end

return

%% test jac

syms t1 t2 t3 x1 x2 x3 a b c d n1 n2 n3 v1 v2 v3 real

L = [n1;n2;n3;v1;v2;v3];
x = [x1;x2;x3];

[aL,AL_l,AL_x] = anchorPlucker(L,x);

simplify(AL_l - jacobian(aL,L))
simplify(AL_x - jacobian(aL,x))



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

