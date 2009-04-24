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
    'numbertitle', 'off',...
    'name',        '3D Map',...
    'doublebuffer','on',...
    'renderer',    FigOpt.renderer,...
    'toolbar',     'none',...
    'color',       FigOpt.map.colors.bckgnd);
cameratoolbar('show');
cameratoolbar('setmode','orbit');

% Map viewpoint
viewPnt = mapObserver(SimLmk,FigOpt.map.view);

% Axes
axis equal
MapFig.axes = gca;
set(MapFig.axes,...
    'parent',             MapFig.fig,...
    'position',           [ 0 0 1 1],...
    'drawmode',           'fast',...
    'nextplot',           'replacechildren',...
    'projection',         FigOpt.map.proj,...
    'CameraPosition',     viewPnt.X,...
    'CameraPositionMode', 'manual',...
    'CameraUpVector',     viewPnt.upvec,...
    'CameraUpVectorMode', 'manual',...
    'CameraViewAngle',    viewPnt.fov,...
    'CameraViewAngleMode','manual',...
    'CameraTarget',       viewPnt.tgt,...
    'CameraTargetMode',   'manual',...
    'xlim',               [SimLmk.lims.xMin SimLmk.lims.xMax],...
    'ylim',               [SimLmk.lims.yMin SimLmk.lims.yMax],...
    'zlim',               [SimLmk.lims.zMin SimLmk.lims.zMax],...
    'xcolor',             FigOpt.map.colors.bckgnd,...
    'ycolor',             FigOpt.map.colors.bckgnd,...
    'zcolor',             FigOpt.map.colors.bckgnd,...
    'color' ,             FigOpt.map.colors.bckgnd);

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


% landmarks - do not loop, draw all at once
MapFig.simLmk = createSimLmkGraphics(SimLmk,FigOpt.map.colors.simLmks,MapFig.axes);


% ESTIMATED OBJECTS
% robots
for rob = 1:numel(Rob)

    % create and draw robot
    MapFig.estRob(rob) = createObjPatch(Rob(rob),FigOpt.map.colors.est,MapFig.axes);

    % sensors
    for sen = Rob(rob).sensors

        % create and draw sensor
        MapFig.estSen(sen) = createObjPatch(Sen(sen),FigOpt.map.colors.est,MapFig.axes);
        
        % redraw sensor in robot frame
        F = composeFrames(Rob(rob).frame,Sen(sen).frame);
        drawObject(MapFig.estSen(sen),Sen(sen),F);

    end
end


% landmarks
for lmk = 1:numel(Lmk)

    MapFig.estLmk(lmk) = createLmkGraphics(Lmk(lmk),FigOpt.map.colors.label,MapFig.axes);

end
