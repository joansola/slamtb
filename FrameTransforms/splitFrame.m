function [t,q,R,Rt] = splitFrame(F)

% SPLITFRAME  Split frame information into useful matrices and vectors.
%   [T,Q,R,Rt] = SPLITFRAME(F), for a frame F, returns the translation
%   vector T, quaternion Q, rotation matrix R and its transpose Rt. The
%   frame F can be either a 7-vector F=[T;Q] or a structure containing, at
%   least, the fields F.t, F.q, F.R and F.Rt.
%
%   See also FRAME, UPDATEFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

if isa(F,'struct')
    t  = F.t;
    q  = F.q;
    R  = F.R;
    Rt = F.Rt;

else % F is a 7-vector
    t  = F(1:3);
    q  = F(4:7);
    R  = q2R(q);
    Rt = R';

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

