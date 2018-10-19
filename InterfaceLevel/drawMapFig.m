function MapFig = drawMapFig(MapFig, Rob, Sen, Lmk, Trj, Frm, Fac, SimRob, SimSen, FigOpt)

% DRAWMAPFIG  Redraw the 3D map figure.
%   DRAWMAPFIG(MAPFIG, ROB, SEN, LMK, SIMROB, SIMSEN) updates all
%   graphic hadles in MAPFIG to reflect the changes in  ROB, SEN, LMK,
%   SIMROB, and SIMSEN. MAPFIG is the map structure created with
%   CREATEMAPFIG.
%
%   DRAWMAPFIG(...,FIGOPT) admits options to be given via FIGOPT.
%
%   See also CREATEMAPFIG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

global Map

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
    MapFig.Rob(rob).patch = drawObject(MapFig.Rob(rob).patch, Rob(rob));
    
    if FigOpt.map.showEllip && ~isempty(Map.pr)
        r = Rob(rob).state.r(1:3);
        P = Map.P(r,r);
        drawEllipse(MapFig.Rob(rob).ellipse,Rob(rob).frame.x(1:3),P);
    end
    
    for sen = Rob(rob).sensors
        % sensors
        F = composeFrames(Rob(rob).frame,Sen(sen).frame);
        MapFig.Sen(sen) = drawObject(MapFig.Sen(sen),Sen(sen),F);
    end    

end

% Factors' adjacency matrices and coordinates
if FigOpt.map.showMotFac || FigOpt.map.showMeaFac
    [motMat, motCrd, meaMat, meaCrd] = adjacencyAndCoords(Lmk,Frm,Fac);
end

% Motion factors
if FigOpt.map.showMotFac
    [X,Y,Z] = factorLines(motMat,motCrd);
    n = size(X,2);
    for i=1:n
        set(MapFig.Rob(rob).trj(i), 'visible', 'on', 'xdata', X(:,i), 'ydata', Y(:,i), 'zdata', Z(:,i));
    end
    set(MapFig.Rob(rob).trj(n+1:end), 'visible', 'off');
end

% Measurement factors
if FigOpt.map.showMeaFac
    [X,Y,Z] = factorLines(meaMat,meaCrd);
    n = size(X,2);
    for i=1:n
        set(MapFig.Rob(rob).factors(i), 'visible', 'on', 'xdata', X(:,i), 'ydata', Y(:,i), 'zdata', Z(:,i));
    end
    set(MapFig.Rob(rob).factors(n+1:end), 'visible', 'off');
end


% erase non used landmarks
used  = [Lmk.used];
drawn = [MapFig.Lmk.drawn];
erase = drawn & ~used;

if any(erase)
    [MapFig.Lmk(erase).drawn] = deal(false);
    set([MapFig.Lmk(erase).mean],   'visible','off');
    set([MapFig.Lmk(erase).ellipse],'visible','off');
    set([MapFig.Lmk(erase).label],  'visible','off');
end

% for each landmark:
for lmk=find(used)
    MapFig.Lmk(lmk).drawn = true;
    drawLmk(MapFig,Lmk(lmk),FigOpt.map);
end

% Simulate camera viewpoint
if nargin == 7 && strcmp(FigOpt.map.view,'self')
    set(MapFig.axes,...
        'cameraposition', fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;.02])),...
        'cameratarget',   fromFrame(Rob(1).frame, fromFrame(Sen(1).frame,[0;0;1])),...
        'cameraupvector', Rob(1).frame.R*Sen(1).frame.R*[0;-1;0]);
end

daz = FigOpt.map.orbit(1) * FigOpt.rendPeriod;
del = FigOpt.map.orbit(2) * FigOpt.rendPeriod;
camorbit(MapFig.axes,daz,del)



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

