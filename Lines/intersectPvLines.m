function [t,p1,p2] = intersectPvLines(l1,l2)

% INTERSECTPVLINES  Intersect two point-vector lines.
%   [T,P1,P2] = INTERSECTPVLINES(L1,L2) intersects the two point-vector
%   lines L1=[E1,V1] and L2=[E2,V2], and returns a vector of abscissas
%   T=[T1;T2], and two intersection points P1 and P2, so that
%
%       P1 = E1 + T1*V1
%       P2 = E2 + T2*V2
%
%   If the lines intersect, we have the intersection point P = P1 = P2.
%   Otherwise, P1 and P2 are the points of the lines that are closest to
%   the other line, that is, the line passing over P1 and P2 is orthogonal
%   to both L1 and L2.
%
%   See also INTERSECTSEGMENTS, SEG2PVLIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


e1 = l1(1:3); % point in line
v1 = l1(4:6);
e2 = l2(1:3);
v2 = l2(4:6);

A = [-v1'*v1 v2'*v1;-v2'*v1 v2'*v2];
b = [v1';v2']*(e1-e2);

t = A^-1*b;

if nargout > 1
    p1 = e1 + t(1)*v1;
    p2 = e2 + t(2)*v2;
end



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

