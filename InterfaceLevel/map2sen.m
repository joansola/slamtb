function Sen = map2sen(Sen)
% MAP2SEN  Update Sen structure from the Map information.
%   SEN = MAP2SEN(SEN) updates the structure SEN to reflect the information
%   contained in the golbal map Map.
%
%   See also UPDATEFRAME.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

if Sen.frameInMap

    % normalize quaternion in Map - mean and covariance
    [Map.x(Sen.frame.r(4:7)),NQ_q] = normvec(Map.x(Sen.frame.r(4:7)),1);
    Map.P(Sen.frame.r(4:7),Map.used) = NQ_q*Map.P(Sen.frame.r(4:7),Map.used);
    Map.P(Map.used,Sen.frame.r(4:7)) = Map.P(Map.used,Sen.frame.r(4:7))*NQ_q';
    
    Sen.state.x = Map.x(Sen.state.r);
    Sen.frame.x = Map.x(Sen.frame.r);

    Sen.frame   = updateFrame(Sen.frame);

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

