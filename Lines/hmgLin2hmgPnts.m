function [p1,p2,P1_l,P2_l] = hmgLin2hmgPnts(l)

% HMGLIN2HMGPNTS  HMG line to two IDP points conversion.
%   [P1,P2] = HMGLIN2HMGPNTS(L) extracts the two endpoints of the HMG line
%   L in the form of two HMG points.
%
%   [p1,p2,P1_l,P2_l] = HMGLIN2HMGPNTS(...) returns the Jacobians wrt L.

%   Copyright 2009 Teresa Vidal.

p1 = l(1:4,:);
p2 = l(5:8,:);

if nargout > 2

    P1_l = [eye(4)    zeros(4)];
    P2_l = [zeros(4)  eye(4)];

end

return

%% jac

syms p1 a1 b1 c1 n1 p2 a2 b2 c2 n2 real
l = [a1 b1 c1 n1 a2 b2 c2 n2]';

[p1,p2,P1_l,P2_l] = hmgLin2hmgPnts(l);

simplify(P1_l - jacobian(p1,l))
simplify(P2_l - jacobian(p2,l))



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

