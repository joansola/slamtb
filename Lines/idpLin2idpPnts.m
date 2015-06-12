function [p1,p2,P1_l,P2_l] = idpLin2idpPnts(l)

% IDPLIN2IDPPNTS  IDP line to two IDP points conversion.
%   [P1,P2] = IDPLIN2IDPPNTS(L) extracts the two endpoints of the IDP line
%   L in the form of two IDP points with the same anchor of that of the
%   line.
%
%   [p1,p2,P1_l,P2_l] = IDPLIN2IDPPNTS(...) returns the Jacobians wrt L.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

p1 = l(1:6,:);
p2 = l([1:3 7:9],:);

if nargout > 2

    P1_l = [eye(6) zeros(6,3)];
    P2_l = [eye(3) zeros(3,6) ; zeros(3,6) eye(3)];

end

return

%% jac

syms x y z p1 y1 r1 p2 y2 r2 real
l = [x y z p1 y1 r1 p2 y2 r2]';

[p1,p2,P1_l,P2_l] = idpLin2idpPnts(l);

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

