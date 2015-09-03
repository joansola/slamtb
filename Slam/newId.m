function id = newId(factoryName, idreset)

% NEWID  Id factory.
%   NEWID(FACTORYNAME) returns an increasing ID each time it is called with
%   the same FACTORYNAME string. The first created ID is 1.
%
%   NEWID(FACTORYNAME,ID) resets the counter of the id factory FACTORYNAME
%   to the given ID and returns it. For negative ID inputs, the counter is
%   set to zero, and zero is returned.
%
%   Copyright 2015 Joan Sola @ IRI-CSIC-UPC
%   Copyright 2015 Ellon Paiva @ LAAS-CNRS

persistent ids;

if nargin == 2
    
    if idreset < 0
        ids.(factoryName) = 0;
    else
        ids.(factoryName) = idreset;
    end
    
else
    
    if ~isfield(ids,factoryName)
        ids.(factoryName) = 0;
    end
    
    ids.(factoryName) = ids.(factoryName) + 1;
    
end

id = ids.(factoryName);
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

