function [hm,HMpix] = euc2hmg(pix)

% EUC2HMG Euclidean to Homogeneous point transform.
%   EUC2HMG(E) transforms the Euclidean point E onto homogeneous space by
%   appending 1 at the last coordinate.
%
%   [h,H_e] = EUC2HMG(E) returns the Jacobian of the transformation.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


hm = [pix;1];

if nargout > 1 % Jac -- OK
    
    HMpix = [eye(numel(pix));zeros(1,numel(pix))];

end

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

%   SLAMTB is Copyright 2007,2008,2009 
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

