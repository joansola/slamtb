function [lmksToObs,lmksToSkip] = selectLmksToObserve(Obs,N)

% SELECTLMKSTOOBSERVE  Select landmarks to observe.
%   SELECTLMKSTOOBSERVE(Obs,N) returns a sorted rew-vector of landmark
%   indices to be observed. In Active Search, this corresponds to those
%   observations with the largest uncertainty measure (Obs.exp.um). The
%   vector length is limited to N elements.
%
%   See also OBSERVEKNOWNLMKS, SORT.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

switch Map.type
    case 'ekf'
        
        % Use the sizes of the projected ellipses

        Oexp = [Obs.exp];   % expectations structure array
        um   = [Oexp.um];   % uncertainty measures
        
        % sort from highest to lowest uncertainty measures
        [sortedUm,sortedIdx] = sort(um,2,'descend');
        
        % landmark indices, sorted
        lmkList = [Obs(sortedIdx).lmk];
        

    case 'graph'
        
        % Use random set
        perm = randperm(length(Obs));
        lmkList = [Obs(perm).lmk];
        
    otherwise
   
        error('??? Unknown Map type ''%s''.', Map.type);
end

% limit to N elements
n          = min(N,numel(lmkList));
lmksToObs  = lmkList(1:n);     % these are selected for update
lmksToSkip = lmkList(n+1:end); % these are to be skipped


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

