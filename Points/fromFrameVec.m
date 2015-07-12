function [w, W_f, W_v] = fromFrameVec(F,v)

% FROMFRAMEVEC  From frame function for vectors.
%   FROMFRAMEVEC(F,V) transforms the 3d vector V from frame F to the global
%   frame.
%
%   [w, W_f, W_v] = FROMFRAMEVEC(...) returns the Jacobians wrt F and V.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


w = F.R*v;


if nargout > 1   % Jacobians.

    if size(v,2) == 1
        
        s = 2*q2Pi(F.q)*v;

        W_q = [...
            s(2) -s(1)  s(4) -s(3)
            s(3) -s(4) -s(1)  s(2)
            s(4)  s(3) -s(2) -s(1)];
        W_v = F.R;
        W_f = [zeros(3) W_q];

    else % multiple points
        error('??? Can''t give Jacobians for multiple points');
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

