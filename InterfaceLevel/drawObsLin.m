function drawObsLin(SenFig, Obs, SenFigOpt)

% DRAWOBSLIN  Draw an observed line on the pinHole sensor figure.
%   DRAWOBSLIN(SENFIG, OBS, COLORS, SENFIGOPT)  redraws a line
%   landmark on the pinHole sensor figure.
%
%   SENFIG    is the sensor figure's handles structure.
%   OBS       is the landmark-sensor observation structure.
%   SENFIGOPT is the sensor figure options, SENFIGOPT = FigOpt.sen.
%
%   See also DRAWOBSPNT, DRAWSENFIG, TRIMHMGLIN, COV2ELLI.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

posOffset = 8;
colors = SenFigOpt.colors.plkLin; 

% the measurement:
if Obs.measured
    y = Obs.meas.y;
    set(SenFig.measure(Obs.lmk),...
        'xdata', [y(1);y(3)],...
        'ydata', [y(2);y(4)],...
        'color', colors.meas,...
        'vis',   'on');
    
    % the label
    c = (y(1:2)+y(3:4))*0.5;     % segment's center
    v = (y(1:2)-y(3:4));         % segment's vector
    n = normvec([-v(2);v(1)]);   % segment's normal vector
    pos = c + n*posOffset;
    set(SenFig.label(Obs.lmk),...
        'position', pos,...
        'string',   num2str(Obs.lid),...
        'vis',      'on');

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
    X = s([1 3]);
    Y = s([2 4]);
    set(SenFig.mean(Obs.lmk),...
        'xdata', X,...
        'ydata', Y,...
        'color', colors.mean,...
        'vis',   'on');

    % ellipses
    if SenFigOpt.showEllip
        [X,Y] = cov2elli(Obs.par.endp(1).e, Obs.par.endp(1).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,1),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors.ellip,...
            'vis',   'on');
        [X,Y] = cov2elli(Obs.par.endp(2).e, Obs.par.endp(2).E, 3, 10) ;
        set(SenFig.ellipse(Obs.lmk,2),...
            'xdata', X,...
            'ydata', Y,...
            'color', colors.ellip,...
            'vis',   'on');
    end
    
else % not visible - this piece of code only for robustness
    set(SenFig.mean(Obs.lmk),'vis','off');
    set(SenFig.ellipse(Obs.lmk,:),'vis','off');
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

