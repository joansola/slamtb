function drawMapFig(MapFig, Rob, Sen, Lmk, SimRob, SimSen, FigOpt)

% DRAWMAPFIG  Redraw the 3D map figure.
%   DRAWMAPFIG(MAPFIG, ROB, SEN, LMK, SIMROB, SIMSEN) updates all
%   graphic hadles in MAPFIG to reflect the changes in  ROB, SEN, LMK,
%   SIMROB, and SIMSEN. MAPFIG is the map structure created with
%   CREATEMAPFIG.
%
%   DRAWMAPFIG(...,FIGOPT) admits options to be given via FIGOPT.
%
%   See also CREATEMAPFIG.

% SIMULATED OBJECTS

% for each robot:
for rob = 1:numel(SimRob)
    MapFig.simRob(rob) = drawObject(MapFig.simRob(rob),SimRob(rob));

    for sen = SimRob(rob).sensors
        F = composeFrames(SimRob(rob).frame,SimSen(sen).frame);
        MapFig.simSen(sen) = drawObject(MapFig.simSen(sen),SimSen(sen),F);
    end

end




% ESTIMATED OBJECTS

% for each robot:
for rob = 1:numel(Rob)

    % robots
    MapFig.estRob(rob) = drawObject(MapFig.estRob(rob),Rob(rob));

    for sen = Rob(rob).sensors
        % sensors
        F = composeFrames(Rob(rob).frame,Sen(sen).frame);
        MapFig.estSen(sen) = drawObject(MapFig.estSen(sen),Sen(sen),F);
    end

end



% erase non used landmarks
used  = [Lmk.used];
ellipseHandles = [MapFig.estLmk.ellipse];
drawn = (strcmp((get(ellipseHandles(1:2:end),'visible')),'on'))';
erase = drawn & ~used;

set([MapFig.estLmk(erase).mean],'visible','off');
set([MapFig.estLmk(erase).ellipse],'visible','off');

% for each landmark:
for lmk=find(used)
    drawLmk(MapFig,Lmk(lmk));
end

% Simulate camera viewpoint
if nargin == 7 && strcmp(FigOpt.map.view,'self')
    set(MapFig.axes,...
        'cameraposition', fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;.02])),...
        'cameratarget',   fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;1])),...
        'cameraupvector', Rob(1).frame.R*Sen(1).frame.R*[0;-1;0]);
end
