function [v, V_p, V_k, V_d] = pinHoleDepth(p,k,d)


% PINHOLEDEPTH Pin hole projection with distance measurement
%   [v, V_p, V_k, V_d] = PINHOLEDEPTH(l, k, d) projects the Eucliden point
%   l into a pinhole+depth camera. k is the intrinsic vector of the
%   subjacent pinhole model, and d the distortion vector.
%
%   See also PINHOLE, INVPINHOLEDEPTH.

%   Copyright 2015-     Joan Sola @ IRI-UPC-CSIC.


if nargout == 1
    [v(1:2,:),v(3,:)] = pinHole(p,k,d);
else
    [u,s,U_p,U_k,U_d] = pinHole(p,k,d);
    S_p = [0 0 1]; % s = p(3,1) --> ds/dp = [0 0 1];
    v = [u;s];
    V_p = [U_p ; S_p];
    V_k = [U_k ; zeros(1, length(k))];
    V_d = [U_d ; zeros(1, length(d))];
end

return

%%
syms x y z u0 v0 au av real
p = [x;y;z];
k = [u0;v0;au;av];
d = [];

[v, V_p, V_k, V_d] = pinHoleDepth(p,k,d);

simplify(V_p - jacobian(v,p))
simplify(V_k - jacobian(v,k))



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

