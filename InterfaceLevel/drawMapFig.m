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

used   = [Lmk.used];
drawn = (strcmp((get([MapFig.estLmk.ellipse],'visible')),'on'))';
erase = drawn & ~used;

set([MapFig.estLmk(erase).mean],'visible','off');
set([MapFig.estLmk(erase).ellipse],'visible','off');

% for each landmark:
for lmk=find(used)

    switch (Lmk(lmk).type)

        % landmark types
        % --------------
        case {'idpPnt'}
            color = [1 0.5 0.5];
            drawIdpLmk(MapFig, Lmk(lmk), color);
            % TODO : print the landmark
            %            fprintf('[updateMapFig.m] Error, landmark type idpPnt not implemented \n') ;
        case {'eucPnt'}
            color = [.5 .5 1];
            drawEucLmk(MapFig, Lmk(lmk), color);
            % TODO : print the landmark
            %            fprintf('[updateMapFig.m] Error, landmark type eucPnt not implemented \n') ;
            
        case {'hmgPnt'}
            color = [.5 .5 1];
            drawHmgLmk(MapFig, Lmk(lmk), color);
            % TODO : print the landmark
            %            fprintf('[updateMapFig.m] Error, landmark type eucPnt not implemented \n') ;
            
            
            
        otherwise
            % TODO : print an error and go out
            error(['The landmark type is unknown, cannot display the landmark in map figure ( type: ',Lmk(lmkIndex).type,' unknown) !\n']);
    end
end

if nargin == 7 && strcmp(FigOpt.map.view,'self')
    % MAP VIEW -- uncomment to simulate a view from camera 1
    set(MapFig.axes,...
        'cameraposition', fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;.02])),...
        'cameratarget',   fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;1])),...
        'cameraupvector', Rob(1).frame.R*Sen(1).frame.R*[0;-1;0]);
end
