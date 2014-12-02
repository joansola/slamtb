function [s,S1,S2] = makeSegment(p1,p2)

% MAKESEGMENT  Make a segment out of two endpoints
%   MAKESEGMENT(E1,E2) makes a segment out of the two endpoints E1 and E2
%   by stacking both endpoints [E1;E2];
%
%   [s,S1,S2] = MAKESEGMENT(E1,E2) returns the Jacobians of the segments
%   wrt the endpoints.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

s = [p1(:);p2(:)];

if nargout>1
    
    n  = numel(p1);
    S1 = [eye(n);zeros(n)];
    S2 = [zeros(n);eye(n)];
    
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

