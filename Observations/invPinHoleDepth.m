function [p,P_v,P_s,P_k,P_c] = invPinHoleDepth(v,k,c)

% INVPINHOLEDEPTH Pin hole back-projection with distance measurement
%   [p,P_v,P_s,P_k,P_c] = INVPINHOLEDEPTH(v, k, c) retro-projects the
%   pixel+depth measurement v from a pinhole+depth camera. k is the
%   intrinsic vector of the subjacent pinhole model, and c the distortion
%   correction vector.
%
%   See also INVPINHOLE, PINHOLEDEPTH.

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.


if nargout == 1
    
    p = invPinHole(v(1:2),v(3),k,c);
    
else
    
    u = v(1:2);
    s = v(3);
    [p,P_u,P_s,P_k,P_c] = invPinHole(u,s,k,c);
    P_v = [P_u , P_s];
    
end

return

%%
syms x y z u0 v0 au av real
v = [x;y;z];
k = [u0;v0;au;av];
c = [];

[p,P_v,P_s,P_k,P_c] = invPinHoleDepth(v,k,c);

simplify(P_v - jacobian(p,v))
simplify(P_k - jacobian(p,k))



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

