function mapObs = mapObserver(world,mapView)

% MAPOBSERVER  Define observer camera for map plots.
%   MAPOBSERVER(WRLD,VIEW) defines the camera parameters for the MapFig
%   figure so that the scanario defined in WRLD is viewed from a
%   perspective specified by VIEW.
%
%   WRLD is a structure containing at least
%       .l, .w, .h :          length, width and height of the scenario.
%       .xMean, yMean, zMean: values of the center of the scenario
%   VIEW is either a vector or a string. For vectors, one can enter
%       [az, el, fov] :      Azimuth, elevation, field of view, in degrees
%       [az, el, fov, dst] : The above plus distance.
%   for strings, they specify pre-defined views. Edit this file to see the
%   predefined views 'normal', 'top', 'side', 'view'.
%
%
%   See also CREATEMAPFIG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.


% Observer camera:
if isa(mapView,'char')
    switch mapView
        case 'normal'
            % a. normal view
            az  = 0;  % azimut angle in degrees
            el  = 25; % elevation angle in degrees
            fov = 40; % horizontal field of view, in degrees
            rd  = max([world.dims.l,world.dims.w,world.dims.h]); % distance in metres
        case 'top'
            % b. top view
            az  = 90;
            el  = 90;
            fov = 40;
            rd  = max([world.dims.l,world.dims.w,world.dims.h]);
        case 'side'
            % c. side view
            az  = 90;
            el = 0;
            fov = 40;
            rd = max([world.dims.l,world.dims.w,world.dims.h]);
        case 'view'
            % d. view
            az = 30;
            el = 40;
            fov = 40;
            rd = max([world.dims.l,world.dims.w,world.dims.h]);
        case 'self'
            % d. self
            az = 41;
            el = 60;
            fov = 90;
            rd = max([world.dims.l,world.dims.w,world.dims.h]);
        otherwise
            az = 0;
            el = 25;
            fov = 40;
            rd = max([world.dims.l,world.dims.w,world.dims.h]);
    end

else % custom view vector

    [az,el,fov] = split(mapView);
    if numel(mapView) == 4
        rd = mapView(4);
    else
        rd = max([world.dims.l,world.dims.w,world.dims.h]);
    end

end

% Observed target (optical axis points to)
mapObs.tgt   = [world.center.xMean;world.center.yMean;0];
% camera orientation
R  = e2R(deg2rad([0,el,az])); % given *pitch* and *yaw*.
mapObs.upvec = R*[0;0;1]; % this fixes *roll* in Matlab convention.
% camera position
mapObs.X     = mapObs.tgt + rd*R*[-1;0;0];
% field of view (Matlab wants this in degrees)
mapObs.fov   = fov;



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

