function MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,FigOpt)

% CREATEMAPFIG  Create 3D map figure and handles.
%   MAPFIG = CREATEMAPFIG(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,MapFigure)
%   creates the map figure in figure 1, containing the following graphics
%   objects:
%       - a grid representing the ground
%       - simulated robots and sensors - in green
%       - estimated robots and sensors - in blue
%       - simulated landmarks (virtual world) - in red
%       - estimated landmarks, containing mean and uncertainty ellipsoid - in
%       colors depending on the landmark type.
%
%   The output MAPFIG is a structure of handles to all these graphics
%   objects. See the Matlab documentation for information about graphics
%   handles and the way to efficiently manipulate graphics. MAPFIG has the
%   following fields:
%       .fig    handle to the figure
%       .axes   handle to the axes
%       .simRob array of handles to the simulated robots 'patch' objects
%       .simSen array of handles to the simulated sensors 'patch' objects
%       .simLmk handle to the simulated landmarks 'line' object
%       .Rob array of handles to the estimated robots 'patch' objects
%       .Sen array of handles to the estimated sensors 'patch' objects
%       .Lmk array of structures with handles to the estimated landmarks, with
%           .mean       handle to the ellipsoid's center 'line' object
%           .ellipse    handle to the ellipsoid's contour 'line' object
%
%   The figure is updated using drawMapFig.
%
%   See also DRAWMAPFIG, CREATESENFIG, MAPOBSERVER, LINE, PATCH, SURFACE,
%   SET, GET.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Figure
if ishandle(99)
    MapFig.fig = figure(99);
else
    MapFig.fig = figure(99);
    figPos     = get(MapFig.fig,'position');
    figSize    = FigOpt.map.size;
    newFigPos  = [figPos(1:2)  figSize];
    set(MapFig.fig,'position',newFigPos);
end
clf
moreindatatip

set(MapFig.fig,...
    'numbertitle',   'off',...
    'name',          '3D Map',...
    'doublebuffer',  'off',...
    'renderer',      FigOpt.renderer,...
    'toolbar',       'none',...
    'color',         FigOpt.map.colors.bckgnd);
cameratoolbar('show');
cameratoolbar('setmode','orbit');

% Map viewpoint
viewPnt = mapObserver(SimLmk,FigOpt.map.view);

% Axes
axis equal
MapFig.axes = gca;
set(MapFig.axes,...
    'parent',              MapFig.fig,...
    'nextplot',            'replacechildren',...
    'position',            [ 0 0 1 1],...
    'drawmode',            'fast',...
    'projection',          FigOpt.map.proj,...
    'CameraPosition',      viewPnt.X,...
    'CameraPositionMode',  'manual',...
    'CameraUpVector',      viewPnt.upvec,...
    'CameraUpVectorMode',  'manual',...
    'CameraViewAngle',     viewPnt.fov,...
    'CameraViewAngleMode', 'manual',...
    'CameraTarget',        viewPnt.tgt,...
    'CameraTargetMode',    'manual',...
    'xlim',                [SimLmk.lims.xMin SimLmk.lims.xMax],...
    'ylim',                [SimLmk.lims.yMin SimLmk.lims.yMax],...
    'zlim',                [SimLmk.lims.zMin SimLmk.lims.zMax],...
    'alimmode',            'manual',...
    'climmode',            'manual',...
    'vis',                 'off');%,...

% landmarks - do not loop, draw all at once
MapFig.simLmk = createSimLmkGraphics(SimLmk,FigOpt.map.colors.simLmk,MapFig.axes,FigOpt.map.showSimLmk);


% ESTIMATED OBJECTS
% robots
for rob = 1:numel(Rob)

    % create and draw robot - with ellipse
    MapFig.Rob(rob).patch = createObjPatch(Rob(rob),FigOpt.map.colors.est,MapFig.axes);
    MapFig.Rob(rob).ellipse = line(...
        'parent', MapFig.axes,...
        'xdata',  [],    ...
        'ydata',  [],    ...
        'zdata',  [],    ...
        'color',  'r',   ...
        'marker', 'none');

    % sensors
    for sen = Rob(rob).sensors

        % create and draw sensor
        MapFig.Sen(sen) = createObjPatch(Sen(sen),FigOpt.map.colors.est,MapFig.axes);
        
        % redraw sensor in robot frame
        F = composeFrames(Rob(rob).frame,Sen(sen).frame);
        drawObject(MapFig.Sen(sen),Sen(sen),F);

    end
end


% landmarks
for lmk = 1:numel(Lmk)

    MapFig.Lmk(lmk) = createLmkGraphics(Lmk(lmk),FigOpt.map.colors.label,MapFig.axes);

end


% SIMULATED OBJECTS
% Ground
MapFig.ground = createGround(SimLmk,MapFig.axes,FigOpt.map.colors.ground);

% Robots
for rob = 1:numel(SimRob)

    % create and draw robot
    MapFig.simRob(rob) = createObjPatch(SimRob(rob),FigOpt.map.colors.simu,MapFig.axes);

    % Sensors
    for sen = SimRob(rob).sensors

        % create and draw sensor
        MapFig.simSen(sen) = createObjPatch(SimSen(sen),FigOpt.map.colors.simu,MapFig.axes);
        
        % redraw sensor in robot frame
        F = composeFrames(SimRob(rob).frame,SimSen(sen).frame);
        drawObject(MapFig.simSen(sen),SimSen(sen),F);
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

