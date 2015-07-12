function F = updateFrame(F, norm)

% UPDATEFRAME Update frame structure.
%   F = UPDATEFRAME(F)  updates the matrices R, Pi and Pc and the
%   vectors t, q, it and iq in the frame structure F. The only required
%   field in F is F.x, the 7-vector containing translation and orientation
%   quaternion of the frame F:
%
%       F.x = [t;q] = [x y z a b c d]'
%
%   where q = [a b c d]' must already be a unit vector.
%
%   F = UPDATEFRAME(F, true) forces quaternion normalization.
%
%   As a result, the following fields are created/updated as follows:
%
%       F.t  = F.x(1:3);
%       F.q  = F.x(4:7);
%       F.R  = q2R(F.q);
%       F.Rt = F.R';
%
%   See also FRAME, Q2R, SPLITFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if (nargin > 1) && (norm ~= false)
    F.x(4:7)  = normvec(F.x(4:7)); % normalize quaternion
end

F.t  = F.x(1:3);
F.q  = F.x(4:7);
F.R  = q2R(F.q);
F.Rt = F.R';



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

