function [p,Ph1,Ph2] = intersectHmgLin(h1,h2,euc)

% INTERSECTHMGLIN  Intersection of 2 homogeneous lines.
%   INTERSECTHMGLIN(H1,H2) is the intersection point in homogeneous coordinates of the
%   two homogeneous lines H1 and H2, defined in the projective plane P^2.
%
%   INTERSECTHMGLIN(H1,H2,EUC), with EUC ~= 0, returns the point in Euclidean
%   coordinates.
%
%   [P,P_h1,P_h2] = INTERSECTHMGLIN(...) returns the Jacobians wrt the lines H1 and H2.
%
%   See also PP2HMGLIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


if nargout == 1

    p = cross(h1,h2);

    if nargin == 3 && euc % Return Euclidean point
        p = hmg2euc(p);
    end

else % Jac

    [p,Ph1,Ph2] = crossJ(h1,h2);
    
     if nargin == 3 && euc % Return Euclidean point
        [p,Pp] = hmg2euc(p);
        Ph1 = Pp*Ph1;
        Ph2 = Pp*Ph2;
     end
end

return

%% Jac
syms l1 l2 l3 m1 m2 m3 real
l = [l1;l2;l3];
m = [m1;m2;m3];

%% homogeneous
[p,Pl,Pm] = intersectHmgLin(l,m);

Pl - jacobian(p,l)
Pm - jacobian(p,m)

%% Euclidean
[p,Pl,Pm] = intersectHmgLin(l,m,1);

Pl - jacobian(p,l)
Pm - jacobian(p,m)



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

