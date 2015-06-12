function [Rob,Sen] = installSensors(Rob,Sen)

% INSTALLSENSORS  Install sensors on robots.
%   [Rob, Sen] = INSTALLSENSORS(Rob, Sen) installs each sensor in Sen on
%   the robot Rob(rob), with rob = Sen(sen).robot. Installation is done
%   by augmenting the vector in field Rob(rob).sensors with the new sensor.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


for sen = 1:numel(Sen)

    rob = Sen(sen).robot;

    if rob > numel(Rob)

        error('Attempt to install sensor on inexistent robot.');

    else

        Rob(rob).sensors = [Rob(rob).sensors sen];

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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

