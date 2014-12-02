function F = fundamental(k0, k1, f0, f1)

%  FUNDAMENTAL Fundamental matrix between 2 cameras.
%   FUNDAMENTAL(K0, K1, REL) returns the fundamental matrix of the pair of
%   calibrated cameras with intrinsic parameters K0 and K1, and related by
%   a frame transformation REL relative between camera 0 and camera 1, that
%   is, the position and orientation of camera 1 with respect to camera 0.
%
%   REL is either a 7-vector REL=[t;q] or a FRAME structure with at least
%   the fields REL.t and REL.Rt updated. Use REL=updateFrame(REL) prior to
%   your call to FUNDAMENTAL if unsure about the state of these fields.
%
%   K0 is the base camera intrinsic matrix, or intrinsic vector.
%   K1 is the local camera intrinsic matrix, or intrinsic vector.
%
%   The fundamental matrix F is defined as:
%       F = (K1^-1)' * E * K0^-1
%   where E is the essential matrix associated with the transformation REL.
%
%   FUNDAMENTAL(K0, K1, F0, F1) uses different frames for each camera. They
%   must be expressed with respect to a common frame. 
%
%   See also ESSENTIAL, INTRINSIC, FRAME, UPDATEFRAME.

%   (c) Joan Sola 2014


if nargin < 4
    f_relative = f0;
else
    f_relative = composeFrames(invertFrame(f0), f1);
end

if numel(k0) == 4
    iK_base = invIntrinsic(k0);
else
    iK_base = inv(k0);
end
if numel(k1) == 4
    iK_local = invIntrinsic(k1);
else
    iK_local = inv(k1);
end

F = iK_local' * essential(f_relative) * iK_base;

return

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

