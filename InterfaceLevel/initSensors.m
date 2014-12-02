function Sen = initSensors(Sen)

% INITSENSORS Initialize sensors in Map.
%   Sen = INITSENSORS(Sen) initializes all sensors in Sen() in the global
%   map Map. It does so by:
%       getting a range of free states for the sensor
%       assigning it to the appropriate fields of Sen
%       setting Sen's mean and cov. matrices in Map
%       setting all Map.used positions in the range to 'true'.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

for sen = 1:numel(Sen)

    r = addToMap(Sen(sen).state.x,Sen(sen).state.P);

    Sen(sen).frame.r = r;
    Sen(sen).state.r = r;

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

