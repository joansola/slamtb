function H = composeFrames(F,G)

% COMPOSEFRAMES  Compose two 3D frames.
%   H = COMPOSEFRAMES(F,G) composes frames F and G, where frame G is
%   specified in frame F, to get a single frame transform H. Frames are
%   structures with at least the following fields:
%       .t  translation vector
%       .q  orientation quaternion
%
%   The resulting frame H, however, contains the full frame structure.
%
%   See also FRAME, SPLITFRAME, QUATERNION.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

H.t = fromFrame(F,G.t);
H.q = qProd(F.q,G.q);
H.x = [H.t;H.q];
H   = updateFrame(H);



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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

