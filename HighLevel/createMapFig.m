function MapFig = createMapFig(Rob,Sen,Lmk,SimRob,SimSen,SimLmk,Figures)

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
%       .estRob array of handles to the estimated robots 'patch' objects
%       .estSen array of handles to the estimated sensors 'patch' objects
%       .estLmk array of structures with handles to the estimated landmarks, with
%           .mean       handle to the ellipsoid's center 'line' object
%           .ellipse    handle to the ellipsoid's contour 'line' object
%
%   The figure is updated using drawMapFig.
%
%   See also DRAWMAPFIG, CREATESENFIG, MAPOBSERVER, LINE, PATCH, SURFACE,
%   SET, GET.



% Figure
MapFig.fig = figure(99);
moreindatatip
clf
set(MapFig.fig,...
    'numbertitle', 'off',...
    'name',        '3D Map',...
    'doublebuffer','on',...
    'renderer',    Figures.renderer,...
    'toolbar',     'none',...
    'color',       'w');
cameratoolbar('show');
cameratoolbar('setmode','orbit');

% Map viewpoint
viewPnt       = mapObserver(SimLmk,Figures.mapView);

% Axes
axis equal
MapFig.axes = gca;
set(MapFig.axes,...
    'parent',             MapFig.fig,...
    'position',           [ 0 0 1 1],...
    'drawmode',           'fast',...
    'nextplot',           'replacechildren',...
    'projection',         Figures.mapProj,...
    'CameraPosition',     viewPnt.X,...
    'CameraPositionMode', 'manual',...
    'CameraUpVector',     viewPnt.upvec,...
    'CameraUpVectorMode', 'manual',...
    'CameraViewAngle',    viewPnt.fov,...
    'CameraViewAngleMode','manual',...
    'CameraTarget',       viewPnt.tgt,...
    'CameraTargetMode',   'manual',...
    'xlim',               [SimLmk.xMin SimLmk.xMax],...
    'ylim',               [SimLmk.yMin SimLmk.yMax],...
    'zlim',               [SimLmk.zMin SimLmk.zMax],...
    'xcolor',             Figures.colors.backgnd,...
    'ycolor',             Figures.colors.backgnd,...
    'zcolor',             Figures.colors.backgnd,...
    'color' ,             Figures.colors.backgnd);

% SIMULATED OBJECTS
% Ground
MapFig.ground = createGround(SimLmk,MapFig.axes);

% Robots
for rob = 1:numel(SimRob)

    % create and draw robot
    MapFig.simRob(rob) = createObjPatch(SimRob(rob),Figures.colors.simu,MapFig.axes);

    % Sensors
    for sen = SimRob(rob).sensors

        % create and draw sensor
        MapFig.simSen(sen) = createObjPatch(SimSen(sen),Figures.colors.simu,MapFig.axes);
        % redraw sensor in robot frame
        F = composeFrames(SimRob(rob).frame,SimSen(sen).frame);
        drawObject(MapFig.simSen(sen),SimSen(sen),F);
    end
end


% landmarks - do not loop, draw all at once
MapFig.simLmk = createSimLmkGraphics(SimLmk,Figures.colors.raw,MapFig.axes);


% ESTIMATED OBJECTS
% robots
for rob = 1:numel(Rob)

    % create and draw robot
    MapFig.estRob(rob) = createObjPatch(Rob(rob),Figures.colors.est,MapFig.axes);

    % sensors
    for sen = Rob(rob).sensors

        % create and draw sensor
        MapFig.estSen(sen) = createObjPatch(Sen(sen),Figures.colors.est,MapFig.axes);
        % redraw sensor in robot frame
        F = composeFrames(Rob(rob).frame,Sen(sen).frame);
        drawObject(MapFig.estSen(sen),Sen(sen),F);

    end
end


% landmarks
for lmk = 1:numel(Lmk)

    MapFig.estLmk(lmk) = createLmkGraphics(Lmk(lmk),Figures.colors.label,MapFig.axes);

end
