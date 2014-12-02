function [hm,HMs] = seg2hmgLin(s)

% SEG2HMGLIN  Segment to homogeneous line conversion.
%   SEG2HMGLIN(S) converts the segment S=[P;Q], with P and Q two Euclidean
%   points, into an homogeneous line in the plane.
%
%   [hm,HMs] = SEG2HMGLIN(S) returns the Jacobians wrt S.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


p = s(1:2);
q = s(3:4);
if nargout == 1
    hm = pp2hmgLin(p,q);
else 
    [hm,HMp,HMq] = pp2hmgLin(p,q);
    HMs = [HMp HMq];
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

