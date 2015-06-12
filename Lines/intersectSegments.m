function [t,p1,p2] = intersectSegments(l1,l2)

% INTERSECTSEGMENTS  Intersect two 3d segments.
%   [T,P1,P2] = INTERSECTSEGMENTS(L1,L2) intersects the two segments
%   L1=[E1,F1] and L2=[E2,F2], and returns a vector of abscissas T=[T1;T2],
%   and two intersection points P1 and P2, so that
%
%       P1 = E1 + T1*V1
%       P2 = E2 + T2*V2
%
%   where V1=F1-E1 and V2=F2-E2 are director vectors.
%
%   Note that what we really intersect is the infinite line supporting the
%   segments. Some examples (intersection is at the cross '+'):
%
%       ----+----         +         |
%                                   |
%           |           / |     ----+---
%           |          /  |         |
%
%   If the lines do intersect in the 3D space, we have the intersection
%   point P = P1 = P2. Otherwise, P1 and P2 are the points of the lines
%   that are closest to the other line, that is, the line passing over P1
%   and P2 is orthogonal to both L1 and L2.
%
%   See also INTERSECTPVLINES, SEG2PVLIN.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


m1 = seg2pvLin(l1);
m2 = seg2pvLin(l2);

[t,p1,p2] = intersectPvLines(m1,m2);



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

