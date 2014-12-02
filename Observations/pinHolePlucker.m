function [l,v,Lk,Ll] = pinHolePlucker(k,L)

% PINHOLEPLUCKER  Projects plucker line.
%   PINHOLEPLUCKER(K,L) projects the Plucker line L into a pin hole camera
%   K=[u0;v0;au;av] at the origin.
%
%   [l,Lk,Ll] = ... returns Jacobians wrt K and L.
%
%   See also PINHOLE.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[u0,v0,au,av] = split(k);
[L1,L2,L3]    = split(L);

l = [...
    av*L1
    au*L2
    -u0*av*L1-au*v0*L2+au*av*L3];

v = L(4:6);

if nargout > 2
    
    Lk = [...
        [            0,            0,            0,           L1]
        [            0,            0,           L2,            0]
        [       -av*L1,       -au*L2, -v0*L2+av*L3, -u0*L1+au*L3]];
    
    Ll = [...
        [     av,      0,      0,      0,      0,      0]
        [      0,     au,      0,      0,      0,      0]
        [ -u0*av, -au*v0,  au*av,      0,      0,      0]];

end

return
%%
syms L1 L2 L3 L4 L5 L6 real
syms u0 v0 au av real

k = [u0 v0 au av];
L = [L1 L2 L3 L4 L5 L6]';

l = pinHolePlucker(k,L)

Lk = jacobian(l,k)
Ll = jacobian(l,L)



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

