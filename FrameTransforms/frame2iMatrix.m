function H = frame2iMatrix(F)

% FRAME2IMATRIX Frame to motion matrix.
%   FRAME2IMATRIX(F) is the 4-by-4 motion matrix corresponding to the
%   inverse of the frame transformation F, i.e.,
%       [F.Rt   F.it
%         0      1  ]
%
%   See also FRAME2IMOTION, FRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

H = [F.Rt F.it;0 0 0 1];



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

