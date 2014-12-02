function [s, S_l, S_t] = pluckerSegment(l,t)

% PLUCKERSEGMENT Segment from Plucker line and endpoint abscissas.
%   PLUCKERSEGMENT(L,T) returns a segment [p1;p2] of two endpoints given a
%   Plucker line L and its two endpoint abscissas in T.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

[e1,e2,E1_l,E2_l,E1_t1,E2_t2] = pluckerEndpoints(l,t(1),t(2));

s = [e1;e2];

if nargout > 1
    S_l = [E1_l;E2_l];
    if nargout > 2
        S_t = [E1_t1 E1_t2
            E2_t1;E2_t2];
    end
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
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

