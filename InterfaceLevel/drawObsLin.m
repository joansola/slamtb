function drawObsLin(SenFig, Obs, colors, showEllip)

% DRAWOBSLIN  Draw an observed line on the pinHole sensor figure.
%   DRAWOBSLIN(SENFIG, OBS, COLORS, SHOWELLIP)  redraws a line
%   landmark on the pinHole sensor figure.
%
%   SENFIG    is the sensor figure's handles structure.
%   OBS       is the landmark-sensor observation structure.
%   COLORS    is a structure with graphic colors:
%       .meas   color of the measurement
%       .ellip  color of the ellipses
%       .label  color of the label
%   SHOWELLIP is a flag for controlling ellipses visibility
%
%   See also DRAWOBSPNT, DRAWSENFIG, TRIMHMGLIN, COV2ELLI.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

posOffset = 8;

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    drawSeg(SenFig.measure(Obs.lmk),y,colors.meas)
    
    % the label
    c = (y(1:2)+y(3:4))*0.5;     % segment's center
    v = (y(1:2)-y(3:4));         % segment's vector
    n = normvec([-v(2);v(1)]);   % segment's normal vector
    pos = c + n*posOffset;
    drawLabel(SenFig.label(Obs.lmk), pos, num2str(Obs.lid))

else
    set(SenFig.measure(Obs.lmk),...
        'vis',   'off');
    set(SenFig.label(Obs.lmk),'vis','off');
end

% the expectation
xlim = get(SenFig.axes,'xlim');
ylim = get(SenFig.axes,'ylim');
imSize = [xlim(2);ylim(2)];
s = trimHmgLin(Obs.exp.e, imSize);
if ~isempty(s)
 
    % mean
    drawSeg(SenFig.mean(Obs.lmk),s,colors.mean)

    % ellipses
    if showEllip
        drawEllipse(SenFig.ellipse(Obs.lmk,1), ...
            Obs.par.endp(1).e, ...
            Obs.par.endp(1).E, ...
            colors.ellip)
        drawEllipse(SenFig.ellipse(Obs.lmk,2), ...
            Obs.par.endp(2).e, ...
            Obs.par.endp(2).E, ...
            colors.ellip)
    end
    
else % not visible
    set(SenFig.mean(Obs.lmk),      'vis', 'off');
    set(SenFig.ellipse(Obs.lmk,:), 'vis', 'off');
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

