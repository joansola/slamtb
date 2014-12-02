function l = segLength(seg)

% SEGLENGTH  Segment length.
%   SEGLENGTH(S) computes the length of segment S = [E1;E2], where E1 and
%   E2 are the two endpoints defining the segment. It works for any
%   dimension.
%
%   SEGLENGTH admits segment matrices S=[S1 ... Sn], in which case it
%   returns a lengths vector L = [L1 ... Ln];

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

n = size(seg,1);

v = seg(1:n/2,:) - seg(n/2+1:n,:);

l = sqrt(sum(v.^2,1));



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

