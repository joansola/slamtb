function [Lmk,Obs] = smartDeleteLmk(Lmk,Obs)

% SMARTDELETELMK  Smart deletion of landmarks.
%   [Lmk,Obs] = SMARTDELETELMK(Lmk,Obs) detetes landmark Lmk if:
%       * the ratio between inliers and searches is smaller than 0.5, and
%       * the number of searches is at least 10.
%   Structure Obs, which must refer to the same landmark, is updated
%   accordingly.
%
%   See also DELETELMK.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

switch Lmk.type
    case {'idpPnt','ahmPnt'}
        if Map.x(Lmk.state.r(end)) < 0
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
    case {'idpLin'}
        if any(Map.x(Lmk.state.r([6,9])) < 0)
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
    case {'ahmLin'}
        if any(Map.x(Lmk.state.r([7,11])) < 0)
            [Lmk,Obs] = deleteLmk(Lmk,Obs);
        end
end

if Lmk.nSearch >= 10

    matchRatio       = Lmk.nMatch  / Lmk.nSearch;
    consistencyRatio = Lmk.nInlier / Lmk.nMatch;

    if matchRatio < 0.1 
        fprintf('Deleted unstable landmark ''%d''.\n',Lmk.id)
        [Lmk,Obs] = deleteLmk(Lmk,Obs);
    end

    if consistencyRatio < 0.5
        fprintf('Deleted inconsistent landmark ''%d''.\n',Lmk.id)
        [Lmk,Obs] = deleteLmk(Lmk,Obs);
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

%   SLAMTB is Copyright 2007,2008,2009
%   by Joan Sola, David Marquez and Jean Marie Codol @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

