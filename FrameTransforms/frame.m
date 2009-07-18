% FRAME  Help on frames for the FrameTransforms/ toolbox.
%
%   Frames are Matlab structures used to store data belonging to 3D frames.
%   We do this to avoid having to compute multiple times rotation matrices
%   and other frame-related constructions. 
%
%   A frame is specified with a translation vector and an orientation
%   quaternion (see QUATERNION), giving a state vector of 7 components.
%   This is the essential frame information, stored in field frame.x. From
%   this 7-vector, all other fields are created or updated using the
%   UPDATEFRAME function.
%
%   The fields of a frame structure are:
%
%     .x      * the state 7-vector
%     .t      * translation vector,     t  = x(1:3)
%     .q      * orientation quaternion, q  = x(4:7)
%     .R      * rotation matrix,        R  = q2R(q)
%     .Rt     * transposed R,           Rt = R'
%     .it     * inverse position,       it = -Rt*t
%     .iq     * inverse or conjugate quaternion, iq = q2qc(q)
%     .Pi     * PI matrix,              Pi = q2Pi(q)
%     .Pc     * conjugate PI matrix,    Pc = q2Pi(iq)
% 
%   Fields .Pi and .Pc are used to help computing some Jacobians of
%   functions involving frame transformations. See TOFRAME in case you are
%   interested in finding out more.
%
%   See also UPDATEFRAME, SPLITFRAME, QUATERNION, TOFRAME, FROMFRAME,
%   COMPOSEFRAMES. 

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



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

