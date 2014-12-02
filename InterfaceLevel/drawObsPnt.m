function drawObsPnt(SenFig, Obs, colors)

% DRAWOBSPNT  Redraw a landmark on the pinHole sensor figure.
%   DRAWOBSPNT(SENFIG, OBS, COLORS)  (re)draw a landmark on the pinHole
%   sensor figure SENFIG.
%
%   COLORS is a structure with the colors to apply to the point. Ex:
%     colors.predicted = 'b'; % blue for only predicted points
%     colors.updated   = 'c'; % cyan for updated points
%   OBS is the observation of the couple (landmark/sensor).

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.



posOffset = [0;-15];

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    drawPnt(SenFig.measure(Obs.lmk),y,colors.updated)
else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
end

% the ellipse
if Obs.updated
    elliCol = colors.updated;
else
    elliCol = colors.predicted;
end

% draw ellipse and label
drawEllipse(SenFig.ellipse(Obs.lmk), Obs.exp.e, Obs.exp.E + Obs.meas.R, elliCol)
drawLabel(SenFig.label(Obs.lmk), Obs.exp.e + posOffset, num2str(Obs.lid))



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

